#include <math.h>

#include <stdio.h>
#include <stdint.h>

#include <fcntl.h>
#include <unistd.h>

#include <sys/stat.h>
#include <sys/types.h>

#define SAMPLE_RATE   (100000LL)
#define CARRIER_FREQ  (10000LL)

const int kDetectCount = 5*SAMPLE_RATE/CARRIER_FREQ;

static float carrier_detect(float v) {
  static float last_snr = 0.0f;

  static float accum_i = 0.0f;
  static float accum_q = 0.0f;
  static float accum_s = 0.0f;
  static float accum_mean = 0.0f;
  static int count = 0;
  static float t = 0.0f;

  const float v_sq = v*v;

  // look for double the carrier frequency
  accum_i += cos(2*M_PI*CARRIER_FREQ*t) * v / kDetectCount;
  accum_q += sin(2*M_PI*CARRIER_FREQ*t) * v / kDetectCount;
  accum_s += v_sq / kDetectCount;
  accum_mean += v / kDetectCount;

  ++count;
  t += 1.0f/SAMPLE_RATE;

  static int decimate = 0;
  if (count >= kDetectCount) {
    const float s = (accum_i*accum_i) + (accum_q * accum_q);
    const float n = accum_s - accum_mean*accum_mean;
    last_snr = s/n;
    ++decimate;

    if (decimate == 1000 || last_snr > 1.0f) {
      fprintf(stderr, "snr: %f s %f n %f\n", last_snr, s, n);
      decimate = 0;
    }

    count = 0;
    accum_i = accum_q = accum_s = accum_mean = 0.0f;
  }

  return last_snr;
}

static void run_costas(float v) {
}

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

  int write_pos = 0;
  int write_seq = 0;
  const char preamble[] = {0xff, 0x00};
  unsigned char status_byte = 0;
  unsigned char lb = 0, ub = 0;
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
              ++offset;
            } else {
              fprintf(stderr, "skip\n");
              offset = 0;
            }
            break;
          case 2:
            status_byte = buf[read_pos];
            ++offset;
            break;
          case 3:
            if (buf[read_pos] != ~status_byte) {
              fprintf(stderr, "skip\n");
              offset = 0;
            } else {
              fprintf(stderr, "sync\n");
              fprintf(stderr, "status = %x\n", status_byte);
              ++offset;
              synced = 1;
            }
            break;
          default:
            fprintf(stderr, "bad state\n");
            return -1;
        }
      } else {
        if (offset < 4) {
          int fail = 0;
          switch (offset) {
            case 0:
            case 1:
              if (buf[read_pos] != preamble[offset]) {
                fail = 1;
              }
              break;
            case 2:
              status_byte = buf[read_pos];
              break;
            case 3:
              if (buf[read_pos] != ~status_byte) {
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
          if ((offset == 4) && synced) {
            //fprintf(stderr, "sync kept\n");
          }
        } else {
          lb = ub;
          ub = buf[read_pos];

          offset++;

          if (offset >= 64) {
            offset = 0;
          }

          const uint16_t val = ((uint16_t)ub << 8) | lb;
          const float v = (float)val;

          if (carrier_detect(v) > 1.0f) {
            if (!detect) {
              fprintf(stderr, "carrier detected\n");
              detect = 1;
            }
            run_costas(v);
          } else {
            detect = 0;
          }
        }
      }
    }
  }
  close(fd);
}
