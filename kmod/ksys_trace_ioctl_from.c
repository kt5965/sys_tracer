#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/kprobes.h>
#include <linux/sched.h>
#include <linux/timekeeping.h>
#include <linux/miscdevice.h>
#include <linux/fs.h>
#include <linux/slab.h>
#include <linux/types.h>
#include <linux/poll.h>
#include <linux/ioctl.h>
#include <linux/moduleparam.h>
#include <linux/uaccess.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("kt5965");
MODULE_DESCRIPTION("Simple syscall tracer using kprobe (ksys v1 - refactored)");

// --- Constants ---
#define KSYS_COMM_LEN   16
#define KSYS_PATH_LEN   64
#define KSYS_RING_SIZE  1024
#define KSYS_IOC_MAGIC  'k'

// --- IOCTL Commands ---
#define KSYS_IOC_GET_STATS      _IOR(KSYS_IOC_MAGIC, 1, struct ksys_stats)
#define KSYS_IOC_SET_FILTERS    _IOW(KSYS_IOC_MAGIC, 2, struct ksys_filter)
#define KSYS_IOC_SET_START      _IOW(KSYS_IOC_MAGIC, 3, struct ksys_start)

// --- Data Structures ---

enum ksys_start_mode {
    KSYS_START_NOW    = 0,
    KSYS_START_OLDEST = 1,
    KSYS_START_SEQ    = 2,
};

struct ksys_start {
    u32 mode;
    u32 _pad;
    u64 seq;
};

struct ksys_stats {
    u64 cur_seq;
    u64 drops;
    u32 ring_size;
    u32 _pad;
};

struct ksys_event {
    u64 seq;
    u64 ts_ns;
    pid_t pid;
    pid_t tgid;
    char comm[KSYS_COMM_LEN];
    char path[KSYS_PATH_LEN];
    int dfd;
    int flags;
    umode_t mode;
};

struct ksys_filter {
    s32 pid;
    s32 tgid;
    char comm[KSYS_COMM_LEN];
};

struct ksys_reader {
    u64 next_seq;       // 이 리더가 다음에 읽어야 할 시퀀스 번호
    u64 drops;          // 리더가 늦어서 놓친 이벤트 수
    struct ksys_filter flt;
};

// --- Globals ---
static u64 ksys_seq = 0; // 단조 증가 시퀀스 번호
static struct ksys_event ksys_rb[KSYS_RING_SIZE];
static DEFINE_SPINLOCK(ksys_rb_lock);
static DECLARE_WAIT_QUEUE_HEAD(ksys_wq);

// --- Module Parameters ---
static int pid_filter = -1;
module_param(pid_filter, int, 0644);

static int tgid_filter = -1;
module_param(tgid_filter, int, 0644);

static char comm_filter[KSYS_COMM_LEN];
module_param_string(comm_filter, comm_filter, sizeof(comm_filter), 0644);

// --- Helper Functions ---

// 전역 필터 확인 (Probe 단계에서 사용)
static inline bool ksys_pass_filter(const struct ksys_event *ev)
{
    if (pid_filter != -1 && ev->pid != pid_filter)
        return false;
    if (tgid_filter != -1 && ev->tgid != tgid_filter)
        return false;
    if (comm_filter[0]) {
        if (strncmp(ev->comm, comm_filter, KSYS_COMM_LEN) != 0)
            return false;
    }
    return true;
}

// Reader별 필터 확인 (Read 단계에서 사용)
static inline bool ksys_match_event(const struct ksys_filter *f, const struct ksys_event *event)
{
    if (f->pid != -1 && event->pid != f->pid)
        return false;
    if (f->tgid != -1 && event->tgid != f->tgid)
        return false;
    if (f->comm[0]) {
        if (strncmp(event->comm, f->comm, KSYS_COMM_LEN) != 0)
            return false;
    }
    return true;
}

static inline u64 ksys_oldest_seq(u64 cur_seq)
{
    return (cur_seq > KSYS_RING_SIZE) ? (cur_seq - KSYS_RING_SIZE) : 0;
}

// 링 버퍼에 이벤트 푸시 (Lock은 호출자가 잡고 있어야 함)
static void ksys_rb_push_locked(const struct ksys_event *event)
{
    u32 idx = (u32)(ksys_seq % KSYS_RING_SIZE);

    ksys_rb[idx] = *event;
    ksys_rb[idx].seq = ksys_seq; // 이벤트 내부에 시퀀스 저장

    ksys_seq++;
}

// --- KProbe Handler ---

static struct kprobe kp = {
    .symbol_name = "__x64_sys_openat", 
};

static int handler_pre(struct kprobe *p, struct pt_regs *regs)
{
    struct ksys_event event;
    const struct pt_regs *uregs;
    const char __user *filename;
    char tmp[KSYS_PATH_LEN];
    long ret;
    unsigned long flags;

    // x86_64: syscall wrapper는 pt_regs 포인터를 di 레지스터에 넣음
    uregs = (const struct pt_regs *)regs->di;
    if (!uregs) return 0;

    // 인자 추출 (x86_64 Calling Convention: di, si, dx, r10, r8, r9)
    event.dfd   = (int)uregs->di;
    filename    = (const char __user *)uregs->si;
    event.flags = (int)uregs->dx;
    event.mode  = (umode_t)uregs->r10;

    event.ts_ns = ktime_get_ns();
    event.pid   = current->pid;
    event.tgid  = current->tgid;

    // 커널 내에서는 strscpy 권장
    strscpy(event.comm, current->comm, sizeof(event.comm));

    // 유저 공간 경로 복사
    memset(event.path, 0, sizeof(event.path));
    ret = strncpy_from_user(tmp, filename, sizeof(tmp));
    if (ret < 0) {
        strscpy(event.path, "<badptr>", sizeof(event.path));
    } else {
        tmp[sizeof(tmp) - 1] = '\0';
        strscpy(event.path, tmp, sizeof(event.path));
    }

    // 전역 필터 적용
    if (!ksys_pass_filter(&event))
        return 0;

    // Critical Section
    spin_lock_irqsave(&ksys_rb_lock, flags);
    ksys_rb_push_locked(&event);
    spin_unlock_irqrestore(&ksys_rb_lock, flags);

    wake_up_interruptible(&ksys_wq);
    return 0;
}

static void handler_post(struct kprobe *p, struct pt_regs *regs, unsigned long flags) {}

// --- File Operations ---

static int ksys_dev_open(struct inode *inode, struct file *file)
{
    struct ksys_reader *r;
    unsigned long flags;

    r = kzalloc(sizeof(*r), GFP_KERNEL);
    if (!r)
        return -ENOMEM;

    spin_lock_irqsave(&ksys_rb_lock, flags);
    r->next_seq = ksys_seq; // Open 시점부터의 데이터만 수신
    spin_unlock_irqrestore(&ksys_rb_lock, flags);

    r->drops = 0;
    r->flt.pid = -1;
    r->flt.tgid = -1;
    r->flt.comm[0] = '\0';

    file->private_data = r;
    return 0;
}

static int ksys_dev_release(struct inode *inode, struct file *file)
{
    kfree(file->private_data);
    return 0;
}

static ssize_t ksys_dev_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
{
    struct ksys_reader *r = file->private_data;
    struct ksys_event *tmp;
    u64 cur_seq, oldest_seq;
    size_t max_evs = count / sizeof(struct ksys_event);
    size_t out = 0;

    if (max_evs == 0)
        return -EINVAL;

retry:
    // 데이터 가용성 확인
    {
        unsigned long flags;
        bool avail;

        spin_lock_irqsave(&ksys_rb_lock, flags);
        cur_seq = ksys_seq;
        oldest_seq = ksys_oldest_seq(cur_seq);

        // Reader가 너무 뒤쳐졌으면 가장 오래된 데이터로 점프
        if (r->next_seq < oldest_seq) {
            r->drops += (oldest_seq - r->next_seq);
            r->next_seq = oldest_seq;
        }
        avail = (r->next_seq < cur_seq);
        spin_unlock_irqrestore(&ksys_rb_lock, flags);

        if (!avail) {
            if (file->f_flags & O_NONBLOCK)
                return -EAGAIN;

            if (wait_event_interruptible(ksys_wq, ({
                unsigned long f2;
                u64 s2;
                spin_lock_irqsave(&ksys_rb_lock, f2);
                s2 = ksys_seq;
                spin_unlock_irqrestore(&ksys_rb_lock, f2);
                s2 != cur_seq;
            })))
                return -ERESTARTSYS;

            goto retry;
        }
    }

    // 임시 버퍼 할당
    tmp = kmalloc_array(max_evs, sizeof(*tmp), GFP_KERNEL);
    if (!tmp)
        return -ENOMEM;

    // Copy + Filter Loop
    {
        unsigned long flags;

        spin_lock_irqsave(&ksys_rb_lock, flags);
        cur_seq = ksys_seq;
        oldest_seq = ksys_oldest_seq(cur_seq);

        // 락을 다시 잡았으니 시퀀스 재확인
        if (r->next_seq < oldest_seq) {
            r->drops += (oldest_seq - r->next_seq);
            r->next_seq = oldest_seq;
        }

        while (r->next_seq < cur_seq) {
            struct ksys_event ev = ksys_rb[r->next_seq % KSYS_RING_SIZE];
            r->next_seq++;

            // Reader별 필터 적용
            if (!ksys_match_event(&r->flt, &ev))
                continue;

            if (out < max_evs)
                tmp[out++] = ev;

            if (out == max_evs)
                break;
        }
        spin_unlock_irqrestore(&ksys_rb_lock, flags);
    }

    // 필터링 결과 읽을 게 없으면 다시 대기
    if (out == 0) {
        kfree(tmp);
        if (file->f_flags & O_NONBLOCK)
            return -EAGAIN;
        goto retry;
    }

    // 유저 공간으로 복사
    size_t bytes = out * sizeof(*tmp);
    if (copy_to_user(buf, tmp, bytes)) {
        kfree(tmp);
        return -EFAULT;
    }

    kfree(tmp);
    return bytes;
}

static bool ksys_has_match_locked(struct ksys_reader *r, u64 cur_seq)
{
    u64 oldest_seq = ksys_oldest_seq(cur_seq);
    u64 s = r->next_seq;

    if (s < oldest_seq)
        s = oldest_seq;

    for (; s < cur_seq; s++) {
        // 기존 코드의 'ring' 변수명 오타 수정 -> ksys_rb
        struct ksys_event ev = ksys_rb[s % KSYS_RING_SIZE];
        if (ksys_match_event(&r->flt, &ev))
            return true;
    }
    return false;
}

static __poll_t ksys_dev_poll(struct file *file, poll_table *wait)
{
    struct ksys_reader *r = file->private_data;
    unsigned long flags;
    u64 cur_seq;
    __poll_t mask = 0;

    poll_wait(file, &ksys_wq, wait);

    spin_lock_irqsave(&ksys_rb_lock, flags);
    cur_seq = ksys_seq;
    
    if (ksys_has_match_locked(r, cur_seq))
        mask |= POLLIN | POLLRDNORM;
        
    spin_unlock_irqrestore(&ksys_rb_lock, flags);

    return mask;
}

static long ksys_dev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
{
    struct ksys_reader *r = file->private_data;
    if (!r) return -EINVAL;

    switch (cmd)
    {
        case KSYS_IOC_GET_STATS: {
            struct ksys_stats st;
            unsigned long flags;

            spin_lock_irqsave(&ksys_rb_lock, flags);
            st.cur_seq = ksys_seq;
            spin_unlock_irqrestore(&ksys_rb_lock, flags);

            st.drops = r->drops;
            st.ring_size = KSYS_RING_SIZE;
            st._pad = 0;

            if (copy_to_user((void __user*)arg, &st, sizeof(st)))
                return -EFAULT;
            return 0;
        }

        case KSYS_IOC_SET_FILTERS: {
            struct ksys_filter ft;

            if (copy_from_user(&ft, (void __user*)arg, sizeof(ft)))
                return -EFAULT;

            r->flt.pid = ft.pid;
            r->flt.tgid = ft.tgid;
            // 사이즈 오타 수정: sizeof(KSYS_COMM_LEN) -> KSYS_COMM_LEN
            strncpy(r->flt.comm, ft.comm, KSYS_COMM_LEN);
            return 0;
        }

        case KSYS_IOC_SET_START: {
            struct ksys_start st;
            unsigned long flags;
            u64 cur_seq, oldest;

            // 오타 수정: sizeof(St) -> sizeof(st)
            if (copy_from_user(&st, (void __user*)arg, sizeof(st)))
                return -EFAULT; // 오타 수정: -EFAULT: -> -EFAULT;

            spin_lock_irqsave(&ksys_rb_lock, flags);
            cur_seq = ksys_seq;
            oldest = ksys_oldest_seq(cur_seq);

            switch (st.mode) {
                case KSYS_START_NOW:
                    r->next_seq = cur_seq;
                    break;
                case KSYS_START_OLDEST:
                    r->next_seq = oldest;
                    break;
                case KSYS_START_SEQ:
                    if (st.seq < oldest)
                        r->next_seq = oldest;
                    else if (st.seq > cur_seq)
                        r->next_seq = cur_seq;
                    else
                        r->next_seq = st.seq;
                    break;
                default:
                    spin_unlock_irqrestore(&ksys_rb_lock, flags);
                    return -EINVAL;
            }
            
            r->drops = 0; 
            spin_unlock_irqrestore(&ksys_rb_lock, flags);
            return 0;
        }
        
        default:
            return -ENOTTY;
    }
}

static const struct file_operations ksys_fops = {
    .owner = THIS_MODULE,
    .open = ksys_dev_open,
    .release = ksys_dev_release,
    .read = ksys_dev_read,
    .poll = ksys_dev_poll,
    .unlocked_ioctl = ksys_dev_ioctl,
    .llseek = noop_llseek,
};

static struct miscdevice ksys_miscdev = {
    .minor = MISC_DYNAMIC_MINOR,
    .name  = "ksys_trace",
    .fops  = &ksys_fops,
    .mode  = 0444,
};

// --- Init/Exit ---

static int __init ksys_init(void)
{
    int ret;

    kp.pre_handler = handler_pre;
    kp.post_handler = handler_post;

    ret = register_kprobe(&kp);
    if (ret < 0) {
        pr_err("ksys: register_kprobe failed, ret=%d\n", ret);
        return ret;
    }

    ret = misc_register(&ksys_miscdev);
    if (ret) {
        pr_err("ksys: misc_register failed, ret=%d\n", ret);
        unregister_kprobe(&kp);
        return ret;
    }

    pr_info("ksys: module loaded. tracing %s\n", kp.symbol_name);
    return 0;
}

static void __exit ksys_exit(void)
{
    misc_deregister(&ksys_miscdev);
    unregister_kprobe(&kp);
    pr_info("ksys: module unloaded\n");
}

module_init(ksys_init);
module_exit(ksys_exit);