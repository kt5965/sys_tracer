// kmod/ksys_trace.c
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/kprobes.h>
#include <linux/sched.h>    // current
#include <linux/timekeeping.h>

// procfs 추가 부
#include <linux/proc_fs.h>
#include <linux/seq_file.h>

// char dev 추가 부
#include <linux/miscdevice.h>
#include <linux/fs.h>
#include <linux/slab.h>

#include <linux/types.h>
#include <linux/poll.h>
#include <linux/ioctl.h>
#include <linux/moduleparam.h>


MODULE_LICENSE("GPL");
MODULE_AUTHOR("kt5965");
MODULE_DESCRIPTION("Simple syscall tracer using kprobe (ksys v0)");

#define KSYS_COMM_LEN 16
#define KSYS_PATH_LEN 64
#define KSYS_RING_SIZE 1024
#define KSYS_IOC_MAGIC 'k'

struct ksys_stats {
    u64 cur_seq;    // ksys_seq snapshot
    u64 drops;      // FD의 누적 드랍
    u32 ring_size;
    u32 _pad;
};
#define KSYS_IOC_GET_STATS _IOR(KSYS_IOC_MAGIC, 1, struct ksys_stats)


struct ksys_event {
    u64 seq;            // 이벤트 시퀀스 번호 (monotonic)
    u64 ts_ns;          // timestamp (ns 단위)
    pid_t pid;          // PID: 커널이 프로세스/스레드에 붙인 ID
    pid_t tgid;         // TGID: "프로세스" ID (스레드 그룹 ID)
    char comm[KSYS_COMM_LEN];      // 커맨드 이름 (task_struct->comm)
    char path[KSYS_PATH_LEN];      // openat 경로
    int  dfd;           // dir fd: openat 기준 디렉터리 FD (AT_FDCWD == -100)
    int  flags;         // O_RDONLY / O_WRONLY / O_CREAT 등 플래그
    umode_t mode;       // 파일 퍼미션 모드 (0777 등)
};

struct ksys_reader {
    u64 next_seq; // fd가 다음에 읽어야 할 이벤트 seq
    u64 drops;
};

u64 ksys_seq; // 다음 이벤트에 부여할 seq (monotonic) 지금까지 생성된 이벤트 총 개수
static wait_queue_head_t ksys_wq; // reader가 “이벤트 생길 때까지” 잠드는 큐

static struct ksys_event ksys_rb[KSYS_RING_SIZE];

// 생성된 디렉토리에 관련된 정보를 담는 구조체
static struct proc_dir_entry *ksys_proc_entry;

static unsigned int ksys_head; // 다음에 쓸 index
static unsigned int ksys_count; // 현재 들어있는 event count

static int pid_filter = -1;          // -1이면 필터 없음. (pid: 스레드 ID)
module_param(pid_filter, int, 0644);
static int tgid_filter = -1;         // -1이면 필터 없음. (tgid: 프로세스 ID)
module_param(tgid_filter, int, 0644);
static char *comm_filter = NULL;     // NULL이면 필터 없음. ("bash", "node" 등)
module_param(comm_filter, charp, 0644);

static DEFINE_SPINLOCK(ksys_rb_lock);

static long ksys_dev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
{
    struct ksys_reader *r = file->private_data;
    struct ksys_stats st;
    unsigned long flags;
    if (cmd != KSYS_IOC_GET_STATS)
    {
        return -EINVAL;
    }

    spin_lock_irqsave(&ksys_rb_lock, flags);
    st.cur_seq = ksys_seq;
    spin_unlock_irqrestore(&ksys_rb_lock, flags);
    st.drops = r ? r->drops : 0;
    st.ring_size = KSYS_RING_SIZE;
    st._pad = 0;
    
    if (copy_to_user((void __user*)arg, &st, sizeof(st))) {
        return -EFAULT;
    }
    return 0;
}
static inline bool ksys_pass_filter(const struct ksys_event *ev)
{
    if (pid_filter != -1 && ev->pid != pid_filter)
        return false;
    if (tgid_filter != -1 && ev->tgid != tgid_filter)
        return false;
    if (comm_filter && comm_filter[0] && strncmp(ev->comm, comm_filter, KSYS_COMM_LEN))
        return false;
    return true;
}

static ssize_t ksys_dev_read(struct file *file, char __user  *buf, size_t count, loff_t *ppos)
{
    struct ksys_reader *r = file->private_data;
    struct ksys_event *tmp;
    unsigned long flags;
    u64 cur_seq, oldest_seq;
    size_t max_events, n_events, bytes;
    size_t i;

    // 버퍼가 event 단위가 아니면 리턴
    if (count < sizeof(struct ksys_event))
    {
        return -EINVAL;
    }

    max_events = count / sizeof(struct ksys_event);

retry:
    spin_lock_irqsave(&ksys_rb_lock, flags);
    cur_seq = ksys_seq; // 현재까지 총 이벤트 개수
    // oldest -> 현재 링버퍼에 남아있을 수 있는 가장 오래된 seq
    oldest_seq = (cur_seq > KSYS_RING_SIZE) ? (cur_seq - KSYS_RING_SIZE) : 0;

    if (r->next_seq < oldest_seq) {
        // reader가 너무 뒤쳐짐: 가장 오래된 이벤트부터 시작
        r->next_seq = oldest_seq;
        r->drops += (oldest_seq - r->next_seq);
    }
    
    if (r->next_seq >= cur_seq) {
        // 읽을게 없음
        spin_unlock_irqrestore(&ksys_rb_lock, flags);

        // non-blocking 이면 바로 리턴
        if (file->f_flags & O_NONBLOCK)
        {
            return -EAGAIN;
        }

        if (wait_event_interruptible(ksys_wq, ({
            unsigned long f2;
            u64 s2;
            spin_lock_irqsave(&ksys_rb_lock, f2);
            s2 = ksys_seq;
            spin_unlock_irqrestore(&ksys_rb_lock, flags);
            s2 != cur_seq;
        })))
            return -ERESTARTSYS;
        goto retry;
    }

    n_events = (size_t)(cur_seq - r->next_seq);
    if (n_events > max_events)
        n_events = max_events;
    
    bytes = n_events * sizeof(struct ksys_event);
    // 유저 버퍼에 들어갈 수 있는 최대 이벤트 개수
    spin_unlock_irqrestore(&ksys_rb_lock, flags);

    tmp = kmalloc(bytes, GFP_KERNEL);
    if (!tmp) {
        return -ENOMEM;
    }

    spin_lock_irqsave(&ksys_rb_lock, flags);
    for (i = 0; i < n_events; i++) {
        u64 seq = r->next_seq + i;
        unsigned int idx = (unsigned int)(seq % KSYS_RING_SIZE);
        tmp[i] = ksys_rb[idx];
    }
    r->next_seq += n_events;
    spin_unlock_irqrestore(&ksys_rb_lock, flags);
    if (copy_to_user(buf, tmp, bytes)) {
        kfree(tmp);
        return -EFAULT;
    }

    kfree(tmp);
    return bytes;
}

static __poll_t ksys_dev_poll(struct file *file, poll_table *wait)
{
    struct ksys_reader *r = file->private_data;
    unsigned long flags;
    u64 cur_seq, oldest_seq;
    __poll_t mask = 0;

    poll_wait(file, &ksys_wq, wait); // 잠들 준비 등록
    spin_lock_irqsave(&ksys_rb_lock, flags);
    cur_seq = ksys_seq;
    oldest_seq = (cur_seq > KSYS_RING_SIZE) ? (cur_seq-KSYS_RING_SIZE) : 0;
    if (r->next_seq < oldest_seq)
        r->next_seq = oldest_seq;
    if (r->next_seq < cur_seq)
        mask |= POLLIN | POLLRDNORM;
    spin_unlock_irqrestore(&ksys_rb_lock, flags);
    return mask;
}


static int ksys_proc_show(struct seq_file *m, void *v)
{
    unsigned long flags;
    unsigned int head, count;
    unsigned int oldest;
    unsigned int i;

    // irq disable && save irq state in flag
    spin_lock_irqsave(&ksys_rb_lock, flags);
    head = ksys_head;
    count = ksys_count;

    spin_unlock_irqrestore(&ksys_rb_lock, flags);

    if (count == 0) {
        seq_puts(m, "ksys: ring buffer empty\n");
        return 0;
    }

    // 가장 오래 된 위치`
    oldest = (head + KSYS_RING_SIZE - count) % KSYS_RING_SIZE;

    spin_lock_irqsave(&ksys_rb_lock, flags);

    for (i = 0; i < count; i++) {
        unsigned int idx = (oldest + i) % KSYS_RING_SIZE;
        const struct ksys_event *event = &ksys_rb[idx];
        seq_printf(m,
            "[%5u] ts=%llu ns pid=%d tgid=%d comm=%s "
            "dfd=%d flags=0x%x mode=%o path=%s\n",
            i,
            event->ts_ns,
            event->pid,
            event->tgid,
            event->comm,
            event->dfd,
            event->flags,
            event->mode,
            event->path);
    }
    spin_unlock_irqrestore(&ksys_rb_lock, flags);
    return 0;
}


// “왜 open에서 r->next_seq=ksys_seq로 시작하냐?”
// → 열자마자 옛날 이벤트(ps 스팸 등)를 쏟아내지 말고 지금부터 생기는 이벤트만 스트리밍 하려고.
static int ksys_dev_open(struct inode *inode, struct file *file)
{
    struct ksys_reader *r;
    unsigned long flags;
    u64 cur;

    r = kzalloc(sizeof(*r), GFP_KERNEL);
    if (!r)
        return -ENOMEM;

    spin_lock_irqsave(&ksys_rb_lock, flags);
    cur = ksys_seq; // 현재까지 발생한 마지막 다음 seq
    spin_unlock_irqrestore(&ksys_rb_lock, flags);

    r->next_seq = cur; // 지금부터 이후 이벤트만 받고
    file->private_data = r;
    return 0;
}

static int ksys_dev_release(struct inode *inode, struct file *file)
{
    kfree(file->private_data);
    return 0;
}

static int ksys_proc_open(struct inode *inode, struct file *file)
{
    return single_open(file, ksys_proc_show, NULL);
}

static const struct file_operations ksys_fops = {
    .owner = THIS_MODULE,
    .open = ksys_dev_open,
    .release = ksys_dev_release,
    .read  = ksys_dev_read,
    .poll = ksys_dev_poll,
    .llseek = noop_llseek,   // lseek(파일 위치 이동) 안 됨
    .unlocked_ioctl = ksys_dev_ioctl,
};

static const struct proc_ops ksys_proc_ops = {
    .proc_open    = ksys_proc_open,
    .proc_read    = seq_read,
    .proc_lseek   = seq_lseek,
    .proc_release = single_release,
};

static void ksys_rb_push(const struct ksys_event *event)
{
    unsigned long flags;
    u64 seq;
    u32 idx;

    spin_lock_irqsave(&ksys_rb_lock, flags);
    seq = ksys_seq++;

    idx = (unsigned int)(seq % KSYS_RING_SIZE);

    ksys_rb[idx] = *event;

    if (ksys_count < KSYS_RING_SIZE)
        ksys_count++;
    else
    {
        
    }

    spin_unlock_irqrestore(&ksys_rb_lock, flags);
    
    // read/poll로 기다리는 프로세스 깨우기
    wake_up_interruptible(&ksys_wq);
}

// x86_64 기준: openat syscall 핸들러 심볼 이름
static struct kprobe kp = {
    .symbol_name = "__x64_sys_openat",
};

// /dev/ksys_trace 생성 (miscdevice 등록)
static struct miscdevice ksys_miscdev = {
    .minor = MISC_DYNAMIC_MINOR, // 자동으로 사용 가능한 minor 번호 할당
    .name  = "ksys_trace",       // /dev/ksys_trace 라는 이름으로 생성
    .fops  = &ksys_fops,         // 위에서 정의한 file_operations
    .mode  = 0444,               // 퍼미션: r--r--r-- (모두 읽기 가능)
};

// 중단점 앞에서 실행되는 처리 함수
static int handler_pre(struct kprobe *p, struct pt_regs *regs)
{
    struct ksys_event event;
    const struct pt_regs *uregs;
    const char __user *filename;
    char tmp[KSYS_PATH_LEN];
    int ret;

    // __x64_sys_openat(const struct pt_regs *regs) → regs->di 안에 그 포인터
    uregs = (const struct pt_regs *)regs->di;

    // syscall 인자 꺼내기
    event.dfd   = (int)uregs->di; // destination index 메모리 주소 오프셋
    filename = (const char __user *)uregs->si; // source index 
    event.flags = (int)uregs->dx;
    event.mode  = (umode_t)uregs->r10;

    // 공통 정보 채우기 
    event.ts_ns = ktime_get_ns();
    event.pid   = current->pid;
    event.tgid  = current->tgid;

    memset(event.comm, 0, sizeof(event.comm));
    strncpy(event.comm, current->comm, sizeof(event.comm) - 1);

    memset(event.path, 0, sizeof(event.path));

    // 유저 포인터에서 문자열 복사
    ret = strncpy_from_user(tmp, filename, sizeof(tmp));
    if (ret < 0) {
        strncpy(event.path, "<badptr>", sizeof(event.path) - 1);
    } else {
        tmp[sizeof(tmp) - 1] = '\0';  // 혹시 모를 미종결 방지
        strncpy(event.path, tmp, sizeof(event.path) - 1);
    }
    if (!ksys_pass_filter(&event)) {
        return 0;
    }
    ksys_rb_push(&event);
    return 0;
}



static void handler_post(struct kprobe *p, struct pt_regs *regs,
                         unsigned long flags)
{
    // v0에서는 안 씀. 필요하면 추후 사용
}


static int __init ksys_init(void)
{
    int ret;
    init_waitqueue_head(&ksys_wq);
    kp.pre_handler   = handler_pre;
    kp.post_handler  = handler_post;

    // kp 구조체의 주소를 매개변수로 받아서 트랩을 설치
    ret = register_kprobe(&kp);
    if (ret < 0) {
        pr_err("ksys: register_kprobe failed, ret=%d\n", ret);
        return ret;
    }

    // /proc/ksys_rb 생성 (읽기 전용)
    ksys_proc_entry = proc_create("ksys_rb", 0444, NULL, &ksys_proc_ops);
    if (!ksys_proc_entry) {
        pr_err("ksys: failed to create /proc/ksys_rb\n");
        unregister_kprobe(&kp);
        return -ENOMEM;
    }

    // /dev/ksys_trace 생성 (misc device 등록)
    ret = misc_register(&ksys_miscdev);
    if (ret) {
        pr_err("ksys: misc_register failed, ret=%d\n", ret);
        proc_remove(ksys_proc_entry);
        unregister_kprobe(&kp);
        return ret;
    }
    pr_info("ksys: kprobe registered at %p for %s\n", kp.addr, kp.symbol_name);
    return 0;
}

static void __exit ksys_exit(void)
{
    misc_deregister(&ksys_miscdev);
    if (ksys_proc_entry) {
        proc_remove(ksys_proc_entry);
        ksys_proc_entry = NULL;
    }
    unregister_kprobe(&kp);
    pr_info("ksys: kprobe unregistered\n");
}

module_init(ksys_init);
module_exit(ksys_exit);
