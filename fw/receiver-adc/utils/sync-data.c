#include <stdio.h>
#include <stdint.h>

#include <fcntl.h>
#include <unistd.h>

#include <sys/stat.h>
#include <sys/types.h>

int main(int argc, char** argv) {
  if (argc < 2) {
    fprintf(stderr, "missing argument\n");
    return -1;
  }

  int fd = open(argv[1], O_RDONLY);
  char buf[1024];
  char wbuf[1024];
  int synced = 0;
  int offset = 0;
  int write_pos = 0;
  const char preamble[] = {0xaa, 0xbb, 0xcc, 0xdd};
  unsigned char lb = 0, ub = 0;
  while (1) {
    int read_len = read(fd, buf, sizeof(buf));
    if (read_len == -1) {
      return -1;
    }

    for (int read_pos = 0; read_pos < read_len; read_pos++) {
      if (!synced) {
        if (buf[read_pos] == preamble[offset]) {
          offset++;
          if (offset == sizeof(preamble)) {
            fprintf(stderr, "sync\n");
            synced = 1;
          }
        } else {
          fprintf(stderr, "skip\n");
          offset = 0;
        }
      } else {
        if (offset < 4) {
          if (buf[read_pos] != preamble[offset]) {
            fprintf(stderr, "lost sync\n");
            offset = 0;
            synced = 0;
          }
          offset++;
          if ((offset == 4) && synced) {
            fprintf(stderr, "sync kept\n");
          }
        } else {
          ub = lb;
          lb = buf[read_pos];
          offset++;

          if (offset >= 64) {
            offset = 0;
          }
          if ((offset % 2) == 0 && (offset != 2) && (offset != 4)) {
            wbuf[write_pos] = lb;
            wbuf[write_pos + 1] = ub;
            write_pos += 2;
            if (write_pos == sizeof(wbuf)) {
              write(1, wbuf, sizeof(wbuf));
              write_pos = 0;
            }
          }
        }
      }
    }
  }
  close(fd);
}
