#include <math.h>

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
  char buf[2048];
  //char wbuf[2048];
  int synced = 0;
  int offset = 0;

  int detect = 0;

  unsigned char status_byte = 0;
  unsigned char lb = 0, ub = 0;
  while (1) {
    int read_len = read(fd, buf, sizeof(buf));
    if (read_len == -1) {
      return -1;
    }
    if (read_len == 0) {
      return 0;
    }
    for (int i = 0; i < read_len; i += 2) {
      uint8_t wbuf[2];
      wbuf[0] = buf[i];
      wbuf[1] = buf[i + 1];

      write(1, wbuf, 2);
      usleep(1000);
    }
  }
  close(fd);
}
