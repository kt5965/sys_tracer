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
#include <linux/uaccess.h> // copy_to_user

MODULE_LICENSE("GPL");
MODULE_AUTHOR("kt5965");
MODULE_DESCRIPTION("Simple syscall tracer using kprobe (ksys v1 - refactored)");

#define KSYS_COMM_LEN 16
#define KSYS_PATH_LEN 64
#define KSYS_RING_SIZE 1024 
#define KSYS_IOC_MAGIC 'k'

//  Data Structures 

#define KSYS_IOC_GET_STATS _IOR(KSYS_IOC_MAGIC, 1, struct ksys_stats)
#define KSYS_IOC_SET_FILTERS _IOW(KSYS_IOC_MAGIC, 2, struct ksys_filter)
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
    char comm[16];
};

struct ksys_reader {
    u64 next_seq; // 이 리더가 다음에 읽어야 할 시퀀스 번호
    u64 drops;    // 리더가 늦어서 놓친 이벤트 수
};

//  Globals 

static u64 ksys_seq = 0; // Monotonic increasing sequence number
static struct ksys_event ksys_rb[KSYS_RING_SIZE];
static DEFINE_SPINLOCK(ksys_rb_lock);
static DECLARE_WAIT_QUEUE_HEAD(ksys_wq); // wait_queue 정적 선언

//  Parameters 
static int pid_filter = -1;
module_param(pid_filter, int, 0644);
static int tgid_filter = -1;
module_param(tgid_filter, int, 0644);
static char comm_filter[KSYS_COMM_LEN];
module_param_string(comm_filter, comm_filter, sizeof(comm_filter), 0644);

//  Helper Functions 

static inline bool ksys_pass_filter(const struct ksys_event *ev)
{
    if (pid_filter != -1 && ev->pid != pid_filter) 
        return false;
    if (tgid_filter != -1 && ev->tgid != tgid_filter) 
        return false;
    if (comm_filter[0]) {
        if (strncmp(ev->comm, comm_filter, KSYS_COMM_LEN) != 0) {
            return false;
        }
    }
    return true;
}

// 링 버퍼에 이벤트 푸시 (Lock은 호출자가 잡고 있어야 함)
static void ksys_rb_push_locked(const struct ksys_event *event)
{
    u32 idx = (u32)(ksys_seq % KSYS_RING_SIZE);
    
    // 구조체 복사 (Seq는 글로벌 seq 할당)
    ksys_rb[idx] = *event;
    ksys_rb[idx].seq = ksys_seq; // 이벤트 내부에 시퀀스 박제
    
    ksys_seq++; // 전체 시퀀스 증가
}

//  Probe Handler 

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

    // x86_64 specific: syscall wrapper puts pt_regs* in di
    uregs = (const struct pt_regs *)regs->di;
    if (!uregs) return 0;

    event.dfd   = (int)uregs->di;
    filename    = (const char __user *)uregs->si;
    event.flags = (int)uregs->dx;
    event.mode  = (umode_t)uregs->r10;

    event.ts_ns = ktime_get_ns();
    event.pid   = current->pid;
    event.tgid  = current->tgid;

    // strscpy is safer for kernel buffers
    strscpy(event.comm, current->comm, sizeof(event.comm));

    // User space string copy
    // memset 0으로 초기화하여 보안 이슈 방지
    memset(event.path, 0, sizeof(event.path));
    ret = strncpy_from_user(tmp, filename, sizeof(tmp));
    if (ret < 0) {
        strscpy(event.path, "<badptr>", sizeof(event.path));
    } else {
        // strncpy_from_user may not null-terminate if max length reached
        tmp[sizeof(tmp) - 1] = '\0';
        strscpy(event.path, tmp, sizeof(event.path));
    }

    if (!ksys_pass_filter(&event))
        return 0;

    //  Critical Section Start 
    spin_lock_irqsave(&ksys_rb_lock, flags);
    ksys_rb_push_locked(&event);
    spin_unlock_irqrestore(&ksys_rb_lock, flags);
    //  Critical Section End 

    wake_up_interruptible(&ksys_wq);
    return 0;
}

static void handler_post(struct kprobe *p, struct pt_regs *regs, unsigned long flags) {}

//  File Operations 

static int ksys_dev_open(struct inode *inode, struct file *file)
{
    struct ksys_reader *r;
    unsigned long flags;

    r = kzalloc(sizeof(*r), GFP_KERNEL);
    if (!r) return -ENOMEM;

    spin_lock_irqsave(&ksys_rb_lock, flags);
    r->next_seq = ksys_seq; // Open 시점부터의 데이터만 수신
    spin_unlock_irqrestore(&ksys_rb_lock, flags);

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
    struct ksys_event *tmp_buf;
    unsigned long flags;
    u64 cur_seq, oldest_seq;
    size_t n_events, bytes;
    size_t i;

    if (count < sizeof(struct ksys_event)) {
        return -EINVAL;
    }

    // 최대 읽을 수 있는 개수
    size_t max_req = count / sizeof(struct ksys_event);

    //  Wait for data 
    // (조건: 읽을 데이터가 있거나, 시그널이 왔거나)
    if (wait_event_interruptible(ksys_wq, ({
        bool data_avail;
        spin_lock_irqsave(&ksys_rb_lock, flags);
        cur_seq = ksys_seq;
        // Reader가 따라잡아야 할 가장 오래된 시퀀스 계산
        // (현재 1200번이면, 링버퍼 크기 1000일 때 200번부터만 유효)
        oldest_seq = (cur_seq > KSYS_RING_SIZE) ? (cur_seq - KSYS_RING_SIZE) : 0;
        
        // Reader가 너무 뒤쳐졌으면 강제로 oldest로 이동 (Drop 발생)
        if (r->next_seq < oldest_seq) {
            r->drops += (oldest_seq - r->next_seq);
            r->next_seq = oldest_seq;
        }
        
        data_avail = (r->next_seq < cur_seq);
        spin_unlock_irqrestore(&ksys_rb_lock, flags);
        data_avail;
    }))) {
        return -ERESTARTSYS; // Signal interrupt
    }

    //  Copy Data 
    spin_lock_irqsave(&ksys_rb_lock, flags);
    cur_seq = ksys_seq;
    
    // 다시 한번 범위 체크 (Race condition 방지)
    oldest_seq = (cur_seq > KSYS_RING_SIZE) ? (cur_seq - KSYS_RING_SIZE) : 0;
    if (r->next_seq < oldest_seq) {
        r->drops += (oldest_seq - r->next_seq);
        r->next_seq = oldest_seq;
    }

    n_events = (size_t)(cur_seq - r->next_seq);
    if (n_events > max_req) n_events = max_req;

    // 임시 버퍼 할당 (Spinlock 안에서 copy_to_user 금지이므로 복사 후 락 해제)
    bytes = n_events * sizeof(struct ksys_event);
    tmp_buf = kmalloc(bytes, GFP_ATOMIC); // Spinlock 내부는 아니지만, 빠르게 처리하기 위해
    if (!tmp_buf) {
        spin_unlock_irqrestore(&ksys_rb_lock, flags);
        return -ENOMEM;
    }

    for (i = 0; i < n_events; i++) {
        u32 idx = (u32)((r->next_seq + i) % KSYS_RING_SIZE);
        tmp_buf[i] = ksys_rb[idx];
    }
    
    // 상태 업데이트
    r->next_seq += n_events;
    spin_unlock_irqrestore(&ksys_rb_lock, flags);

    // 유저 공간 복사
    if (copy_to_user(buf, tmp_buf, bytes)) {
        kfree(tmp_buf);
        return -EFAULT;
    }

    kfree(tmp_buf);
    return bytes;
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
    // 읽을 데이터가 있으면 POLLIN
    if (r->next_seq < cur_seq)
        mask |= POLLIN | POLLRDNORM;
    spin_unlock_irqrestore(&ksys_rb_lock, flags);

    return mask;
}

static long ksys_dev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
{
    struct ksys_reader *r = file->private_data;
    
    switch (cmd)
    {
        case KSYS_IOC_GET_STATS: {
            struct ksys_stats st;
            unsigned long flags;
            spin_lock_irqsave(&ksys_rb_lock, flags);
            st.cur_seq = ksys_seq;
            spin_unlock_irqrestore(&ksys_rb_lock, flags);
        
            st.drops = r ? r->drops : 0;
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
            pid_filter = ft.pid;
            tgid_filter = ft.tgid;
            strncpy(comm_filter, ft.comm, sizeof(KSYS_COMM_LEN));
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
    .read  = ksys_dev_read,
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

//  Init/Exit 

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