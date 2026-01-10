// user/ksysdump.c

#include <poll.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>

#define KSYS_COMM_LEN 16
#define KSYS_PATH_LEN 64
#define KSYS_IOC_MAGIC 'k'


struct ksys_stats {
    uint64_t cur_seq;
    uint64_t drops;
    uint32_t ring_size;
    uint32_t _pad;
};

#define KSYS_IOC_GET_STATS _IOR(KSYS_IOC_MAGIC, 1, struct ksys_stats)

struct ksys_event {
    uint64_t seq;
    uint64_t ts_ns;                   // timestamp (ns)
    int32_t  pid;                     // pid_t 와 크기가 같다고 가정 (x86_64)
    int32_t  tgid;                    // tgid
    char     comm[KSYS_COMM_LEN];     // 프로세스 이름
    char     path[KSYS_PATH_LEN];     // 파일 경로
    int32_t  dfd;                     // dir fd (AT_FDCWD == -100)
    int32_t  flags;                   // open flags
    uint32_t mode;                    // umode_t (퍼미션 비트)
};

int main(void)
{
    int fd;
    struct ksys_stats st;
    size_t i, cnt;

    fd = open("/dev/ksys_trace", O_RDONLY | O_NONBLOCK);
    if (fd < 0) {
        perror("open /dev/ksys_trace");
        return 1;
    }
    struct pollfd pfd = {.fd = fd, .events = POLLIN};
    // struct pollfd fd -> fd, events -> 대기 중인 이벤트, revent ->  fd에 발생한 event를 의미
    for(;;)
    {
        int pr = poll(&pfd, 1, -1); // 무한 대기
        if (pr == -1)
        {
            perror("poll");
            break;
        }
        if (pfd.revents & POLLIN) {
            struct ksys_event event[128];
            ssize_t n;
            n = read(fd, event, sizeof(event));
            if (n < 0) {
                perror("read");
                close(fd);
                return 1;
            }
            cnt = n / sizeof(struct ksys_event);
            printf("got %zu events\n", cnt);
            for (i = 0; i < cnt; i++) {
                struct ksys_event *e = &event[i];
                printf("[%3zu] pid=%d tgid=%d comm=%s dfd=%d flags=0x%x mode=%o path=%s\n",
                       i, e->pid, e->tgid, e->comm, e->dfd, e->flags, e->mode, e->path);
            }
        }
        if (ioctl(fd, KSYS_IOC_GET_STATS, &st) == 0) {
            if (st.drops) {
                fprintf(stderr, "[stats] drops=%llu cur_seq=%llu ring=%u\n",
                (unsigned long long)st.drops,
                (unsigned long long)st.cur_seq,
                st.ring_size);
            }
        }
    }
    close(fd);
    return 0;
}