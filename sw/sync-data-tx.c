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
  int synced = 0;
  int offset = 0;
  const char preamble[] = {0xff, 0xff};
  int16_t gyro_x = 0, gyro_y = 0, gyro_z = 0;
  int16_t accel_x = 0, accel_y = 0, accel_z = 0;
  while (1) {
    int read_len = read(fd, buf, sizeof(buf));
    if (read_len == -1) {
      return -1;
    }

    for (int read_pos = 0; read_pos < read_len; read_pos++) {
      if (!synced) {
        switch (offset) {
          case 0:
          case 1:
            if (buf[read_pos] == preamble[offset]) {
              fprintf(stderr, "sync\n");
              synced = 1;
              ++offset;
            } else {
              fprintf(stderr, "skip\n");
              offset = 0;
            }
            break;
          default:
            fprintf(stderr, "bad state\n");
            return -1;
        }
      } else {
        if (offset < 2) {
          int fail = 0;
          switch (offset) {
            case 0:
            case 1:
              if (buf[read_pos] != preamble[offset]) {
                fail = 1;
              }
              break;
            default:
              fprintf(stderr, "bad state\n");
          }
          if (fail) {
            fprintf(stderr, "lost sync\n");
            offset = 0;
            synced = 0;
          }
          offset++;
          if ((offset == 2) && synced) {
            //fprintf(stderr, "sync kept\n");
          }
        } else {
          switch (offset) {
            case 2: //gxh
            case 3: //gxl
              gyro_x = (gyro_x << 8) | (unsigned char) buf[read_pos];
              break;
            case 4: //gyh
            case 5: //gyl
              gyro_y = (gyro_y << 8) | (unsigned char) buf[read_pos];
              break;
            case 6: //gzh
            case 7: //gzl
              gyro_z = (gyro_z << 8) | (unsigned char) buf[read_pos];
              break;
            case 8: //axh
            case 9: //axl
              accel_x = (accel_x << 8) | (unsigned char) buf[read_pos];
              break;
            case 10: //ayh
            case 11: //ayl
              accel_y = (accel_y << 8) | (unsigned char) buf[read_pos];
              break;
            case 12: //azh
            case 13: //azl
              accel_z = (accel_z << 8) | (unsigned char) buf[read_pos];
              break;
            case 14: //sum
              // TODO check sum
              fprintf(stderr, "%d %d %d %f %f %f\n",
                  gyro_x, gyro_z, gyro_z,
                  accel_x*15.6f, accel_y*15.6f, accel_z*15.6f);
              break;
            default:
              fprintf(stderr, "bad state\n");
          }
          offset++;

          if (offset >= (2 + 6 + 6 + 1)) {
            offset = 0;
          }
        }
      }
    }
  }
  close(fd);
}
