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
#include <sys/epoll.h>
#include <sys/ioctl.h>
#include <unistd.h>

#ifndef KSYS_COMM_LEN
#define KSYS_COMM_LEN 16
#endif

#ifndef KSYS_PATH_MAX
#define KSYS_PATH_MAX 256
#endif

struct ksys_event {
    uint64_t seq;
    uint64_t ts_ns;
    int32_t  pid;     // tid
    int32_t  tgid;    // pid
    int32_t  dfd;     // AT_FDCWD=-100
    uint32_t flags;
    uint32_t mode;
    char     comm[KSYS_COMM_LEN];
    char     path[KSYS_PATH_MAX];
};

#define KSYS_IOC_MAGIC      'k'
struct ksys_stats {
    uint64_t cur_seq;
    uint64_t drops;
    uint32_t ring_size;
    uint32_t _pad;
};
#define KSYS_IOC_GET_STATS  _IOR(KSYS_IOC_MAGIC, 1, struct ksys_stats)

struct ksys_filter {
    int32_t pid;
    int32_t tgid;
    char    comm[KSYS_COMM_LEN];
};
#define KSYS_IOC_SET_FILTER _IOW(KSYS_IOC_MAGIC, 2, struct ksys_filter)

struct ksys_start {
    uint32_t mode; // 0=NOW,1=OLDEST,2=SEQ
    uint32_t _pad;
    uint64_t seq;
};
#define KSYS_IOC_SET_START  _IOW(KSYS_IOC_MAGIC, 3, struct ksys_start)
enum { KSYS_START_NOW=0, KSYS_START_OLDEST=1, KSYS_START_SEQ=2 };

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
            if (c < 0x20) printf("\\u%04x", (unsigned)c);
            else putchar((int)c);
            break;
        }
    }
    putchar('"');
}

static void print_event_json(const struct ksys_event *e)
{
    fputs("{\"type\":\"openat\"", stdout);
    printf(",\"seq\":%" PRIu64, e->seq);
    printf(",\"ts_ns\":%" PRIu64, e->ts_ns);
    printf(",\"pid\":%d", e->pid);
    printf(",\"tgid\":%d", e->tgid);
    printf(",\"dfd\":%d", e->dfd);
    printf(",\"flags\":%u", e->flags);
    printf(",\"mode\":%u", e->mode);
    fputs(",\"comm\":", stdout); json_escape_print(e->comm, sizeof(e->comm));
    fputs(",\"path\":", stdout); json_escape_print(e->path, sizeof(e->path));
    fputs("}\n", stdout);
}

static void print_stats_json(const struct ksys_stats *st)
{
    printf("{\"type\":\"stats\",\"cur_seq\":%" PRIu64 ",\"drops\":%" PRIu64 ",\"ring_size\":%u}\n",
           st->cur_seq, st->drops, st->ring_size);
}

static int apply_filter_start(int fd, const struct ksys_filter *flt, const struct ksys_start *st)
{
    if (ioctl(fd, KSYS_IOC_SET_FILTER, flt) != 0) return -1;
    if (ioctl(fd, KSYS_IOC_SET_START,  st)  != 0) return -1;
    return 0;
}

int main(int argc, char **argv)
{
    const char *dev = "/dev/ksys_trace";
    int stats_every = 0;      // N회 드레인마다 stats 출력
    bool use_et = false;      // --et면 EPOLLET
    struct ksys_filter flt;
    struct ksys_start st;

    memset(&flt, 0, sizeof(flt));
    flt.pid = -1;
    flt.tgid = -1;
    flt.comm[0] = '\0';

    st.mode = KSYS_START_NOW;
    st._pad = 0;
    st.seq  = 0;

    for (int i = 1; i < argc; i++) {
        if (!strcmp(argv[i], "--dev") && i + 1 < argc) {
            dev = argv[++i];
        } else if (!strcmp(argv[i], "--stats-every") && i + 1 < argc) {
            stats_every = atoi(argv[++i]);
            if (stats_every < 0) stats_every = 0;
        } else if (!strcmp(argv[i], "--et")) {
            use_et = true;
        } else if (!strcmp(argv[i], "--pid") && i + 1 < argc) {
            flt.pid = atoi(argv[++i]);
        } else if (!strcmp(argv[i], "--tgid") && i + 1 < argc) {
            flt.tgid = atoi(argv[++i]);
        } else if (!strcmp(argv[i], "--comm") && i + 1 < argc) {
            snprintf(flt.comm, sizeof(flt.comm), "%s", argv[++i]);
        } else if (!strcmp(argv[i], "--from") && i + 1 < argc) {
            const char *v = argv[++i];
            if (!strcmp(v, "now")) st.mode = KSYS_START_NOW;
            else if (!strcmp(v, "oldest")) st.mode = KSYS_START_OLDEST;
            else if (!strncmp(v, "seq:", 4)) { st.mode = KSYS_START_SEQ; st.seq = strtoull(v+4, NULL, 10); }
            else {
                fprintf(stderr, "bad --from: %s (now|oldest|seq:<N>)\n", v);
                return 2;
            }
        } else {
            fprintf(stderr,
                "usage: %s [--dev /dev/ksys_trace] [--pid TID] [--tgid PID] [--comm NAME]\n"
                "          [--from now|oldest|seq:<N>] [--et] [--stats-every N]\n",
                argv[0]);
            return 2;
        }
    }

    int fd = open(dev, O_RDONLY | O_NONBLOCK);
    if (fd < 0) { perror("open"); return 1; }

    if (apply_filter_start(fd, &flt, &st) != 0) {
        perror("ioctl SET_FILTER/SET_START");
        close(fd);
        return 1;
    }

    int ep = epoll_create1(0);
    if (ep < 0) { perror("epoll_create1"); close(fd); return 1; }

    struct epoll_event ev;
    memset(&ev, 0, sizeof(ev));
    ev.events = EPOLLIN | (use_et ? EPOLLET : 0);
    ev.data.fd = fd;

    if (epoll_ctl(ep, EPOLL_CTL_ADD, fd, &ev) != 0) {
        perror("epoll_ctl ADD");
        close(ep); close(fd);
        return 1;
    }

    int drain_round = 0;
    uint64_t last_drops = 0;

    for (;;) {
        struct epoll_event out[8];
        int n = epoll_wait(ep, out, 8, -1);
        if (n < 0) {
            if (errno == EINTR) {
                struct ksys_stats st2;
                if (ioctl(fd, KSYS_IOC_GET_STATS, &st2) == 0) print_stats_json(&st2);
                break;
            }
            perror("epoll_wait");
            break;
        }

        for (int i = 0; i < n; i++) {
            if (!(out[i].events & EPOLLIN)) continue;

            // ✅ EPOLLET일 때는 반드시 EAGAIN까지 드레인
            for (;;) {
                struct ksys_event evs[256];
                ssize_t r = read(fd, evs, sizeof(evs));
                if (r < 0) {
                    if (errno == EAGAIN) break;
                    if (errno == EINTR) continue;
                    perror("read");
                    goto done;
                }
                if (r == 0) break;

                size_t cnt = (size_t)r / sizeof(evs[0]);
                for (size_t k = 0; k < cnt; k++)
                    print_event_json(&evs[k]);
            }

            drain_round++;
            if (stats_every > 0 && (drain_round % stats_every) == 0) {
                struct ksys_stats st2;
                if (ioctl(fd, KSYS_IOC_GET_STATS, &st2) == 0) print_stats_json(&st2);
            } else {
                struct ksys_stats st2;
                if (ioctl(fd, KSYS_IOC_GET_STATS, &st2) == 0) {
                    if (st2.drops != last_drops) {
                        print_stats_json(&st2);
                        last_drops = st2.drops;
                    }
                }
            }
            fflush(stdout);
        }
    }

done:
    close(ep);
    close(fd);
    return 0;
}
