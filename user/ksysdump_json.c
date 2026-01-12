// ksysdump_json.c
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <poll.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <unistd.h>

// ===== 커널과 동일하게 맞춰야 하는 부분 =====
#define KSYS_COMM_LEN 16
#define KSYS_PATH_MAX 64

struct ksys_event {
    uint64_t seq;               // 이벤트 시퀀스
    uint64_t ts_ns;             // 타임스탬프(ns)
    int32_t  pid;               // thread id
    int32_t  tgid;              // process id
    char     comm[KSYS_COMM_LEN];
    char     path[KSYS_PATH_MAX];
    int32_t  dfd;               // dirfd (AT_FDCWD = -100)
    uint32_t flags;             // openat flags
    uint32_t mode;              // openat mode
};


#define KSYS_IOC_MAGIC   'k'
struct ksys_stats {
    uint64_t cur_seq;
    uint64_t drops;
    uint32_t ring_size;
    uint32_t _pad;
};

struct ksys_filter {
    int32_t pid;
    int32_t tgid;
    char comm[KSYS_COMM_LEN];
};
#define KSYS_IOC_GET_STATS _IOR(KSYS_IOC_MAGIC, 1, struct ksys_stats)
#define KSYS_IOC_SET_FILTERS _IOW(KSYS_IOC_MAGIC, 2, struct ksys_filter)
// ==========================================

// JSON 문자열 이스케이프(따옴표, 역슬래시, 제어문자)
static void json_escape_print(const char *s, size_t maxlen)
{
    putchar('"');
    for (size_t i = 0; i < maxlen && s[i]; i++) {
        unsigned char c = (unsigned char)s[i];
        switch (c) {
        case '\"': fputs("\\\"", stdout); break;
        case '\\': fputs("\\\\", stdout); break;
        case '\b': fputs("\\b", stdout); break;
        case '\f': fputs("\\f", stdout); break;
        case '\n': fputs("\\n", stdout); break;
        case '\r': fputs("\\r", stdout); break;
        case '\t': fputs("\\t", stdout); break;
        default:
            if (c < 0x20) {
                // control char -> \u00XX
                printf("\\u%04x", (unsigned)c);
            } else {
                putchar((int)c);
            }
            break;
        }
    }
    putchar('"');
}

static void print_event_json(const struct ksys_event *e)
{
    // JSON Lines: 한 줄에 하나
    // 타입 고정: openat tracer 이벤트
    fputs("{\"type\":\"openat\"", stdout);

    printf(",\"seq\":%" PRIu64, e->seq);
    printf(",\"ts_ns\":%" PRIu64, e->ts_ns);
    printf(",\"pid\":%d", e->pid);
    printf(",\"tgid\":%d", e->tgid);
    printf(",\"dfd\":%d", e->dfd);
    printf(",\"flags\":%u", e->flags);
    printf(",\"mode\":%u", e->mode);

    fputs(",\"comm\":", stdout);
    json_escape_print(e->comm, sizeof(e->comm));

    fputs(",\"path\":", stdout);
    json_escape_print(e->path, sizeof(e->path));

    fputs("}\n", stdout);
}

static void print_stats_json(const struct ksys_stats *st)
{
    printf("{\"type\":\"stats\",\"cur_seq\":%" PRIu64 ",\"drops\":%" PRIu64 ",\"ring_size\":%u}\n",
           st->cur_seq, st->drops, st->ring_size);
}


int main(int argc, char **argv)
{
    const char *dev = "/dev/ksys_trace";
    int stats_every = 0; // 0이면 stats 자동 출력 안함. 양수면 N회 read마다 stats 출력.
    struct ksys_filter flt;
    flt.pid = -1;
    flt.tgid = -1;
    flt.comm[0] = '\0';
    
    // 옵션: --dev <path>, --stats-every <N>, --pid,tgid,comm filter
    for (int i = 1; i < argc; i++) {
        if (!strcmp(argv[i], "--dev") && i + 1 < argc) {
            dev = argv[++i];
        } else if (!strcmp(argv[i], "--stats-every") && i + 1 < argc) {
            stats_every = atoi(argv[++i]);
            if (stats_every < 0) stats_every = 0;
        } else if (!strcmp(argv[i], "--pid") && i + 1 < argc) {
            flt.pid = atoi(argv[++i]);
        } else if (!strcmp(argv[i], "--tgid") && i + 1 < argc) {
            flt.tgid = atoi(argv[++i]);
        } else if (!strcmp(argv[i], "--comm") && i + 1 < argc) {
            const char *c = argv[++i];
            snprintf(flt.comm, sizeof(flt.comm), "%s", c);
        }
        else {
            fprintf(stderr, "usage: %s [--dev /dev/ksys_trace] [--stats-every N] [--pid TID] [--tgid PID] [--comm NAME]\n", argv[0]);
            return 2;
        }
    }

    int fd = open(dev, O_RDONLY | O_NONBLOCK);
    if (fd < 0) { perror("open"); return 1; }
    if (ioctl(fd, KSYS_IOC_SET_FILTERS, &flt) != 0) {
        perror("ioctl SET_FILTER ERR");
        close(fd);
        return 1;
    }

    struct pollfd pfd = { .fd = fd, .events = POLLIN };

    int read_round = 0;
    uint64_t last_drops = 0;

    for (;;) {
        int pr = poll(&pfd, 1, -1);
        if (pr < 0) {
            if (errno == EINTR) {
                // Ctrl+C 등 시그널로 poll이 끊길 수 있음 -> 종료 전 stats 한 번
                struct ksys_stats st;
                if (ioctl(fd, KSYS_IOC_GET_STATS, &st) == 0)
                    print_stats_json(&st);
                break;
            }
            perror("poll");
            break;
        }

        if (!(pfd.revents & POLLIN))
            continue;

        struct ksys_event evs[128];
        ssize_t n = read(fd, evs, sizeof(evs));
        if (n < 0) {
            if (errno == EAGAIN) continue;
            if (errno == EINTR) continue;
            perror("read");
            break;
        }

        size_t cnt = (size_t)n / sizeof(evs[0]);
        for (size_t i = 0; i < cnt; i++)
            print_event_json(&evs[i]);

        // stats 출력 정책
        read_round++;
        if (stats_every > 0 && (read_round % stats_every) == 0) {
            struct ksys_stats st;
            if (ioctl(fd, KSYS_IOC_GET_STATS, &st) == 0)
                print_stats_json(&st);
        } else {
            // drops가 증가했으면 즉시 stats 한 번 출력(유실 알림)
            struct ksys_stats st;
            if (ioctl(fd, KSYS_IOC_GET_STATS, &st) == 0) {
                if (st.drops != last_drops) {
                    print_stats_json(&st);
                    last_drops = st.drops;
                }
            }
        }

        fflush(stdout);
    }

    close(fd);
    return 0;
}
