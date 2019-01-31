#include <cmath>
#include <cstdio>
#include <cstdint>

#include <fcntl.h>
#include <unistd.h>

#include <sys/stat.h>
#include <sys/types.h>

#include <algorithm>
#include <iostream>
#include <numeric>
#include <vector>

constexpr float kCarrierFreq = 10e+3;
constexpr float kSampleRate = 100e+3;

template <typename F> int read_loop(int fd, F f) {
  unsigned char buf[2048];
  bool synced = false;
  int offset = 0;
  const unsigned char preamble[] = {0xff, 0x00};
  unsigned char status_byte = 0;
  unsigned char lb = 0, ub = 0;
  while (1) {
    int read_len = read(fd, buf, sizeof(buf));
    if (read_len == -1) {
      return -1;
    }

    for (int read_pos = 0; read_pos < read_len; read_pos++) {
      //std::cerr << std::hex << ((int)buf[read_pos]) << std::endl;
      if (!synced) {
        switch (offset) {
          case 0:
          case 1:
            if (buf[read_pos] == preamble[offset]) {
              ++offset;
            } else {
              fprintf(stderr, "skip pre\n");
              offset = 0;
            }
            break;
          case 2:
            status_byte = buf[read_pos];
            ++offset;
            break;
          case 3:
            if (buf[read_pos] != (unsigned char)(~status_byte)) {
              fprintf(stderr, "skip\n");
              offset = 0;
            } else {
              fprintf(stderr, "sync\n");
              fprintf(stderr, "status = %x\n", status_byte);
              ++offset;
              synced = true;
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
              if (buf[read_pos] != (unsigned char)(~status_byte)) {
                fail = 1;
              }
              break;
            default:
              fprintf(stderr, "bad state\n");
          }
          if (fail) {
            fprintf(stderr, "lost sync\n");
            offset = 0;
            synced = false;
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
          if ((offset % 2) == 0 && (offset != 2) && (offset != 4)) {
            f(((int16_t)ub << 8) | lb);
          }
        }
      }
    }
  }
}

template <typename T> struct RollingAverage {
  const T k;
  T v;

  RollingAverage(T k_): k(k_), v(0.0) {
    v = 0.0;
  }

  T run(T val) {
    v = (1.0 - k)*v + k*val;
    return v;
  }
};

template <typename T> struct SlidingWindow {
  std::vector<T> delays;
  size_t rezero = 0, pos = 0;
  T accum;

  SlidingWindow(int window_sz): delays(window_sz, 0.0), accum(0.0) {}

  T run(T val) {
    accum -= delays[pos];
    accum += val;

    delays[pos] = val;
    ++pos;

    if (pos == delays.size()) {
      pos = 0;
      ++rezero;
    }

    if (rezero == delays.size()) {
      accum = std::accumulate(delays.begin(), delays.end(), T(0));
      rezero = 0;
    }

    return accum;
  }
};

struct CostasLoop {
  SlidingWindow<float> i_lpf, q_lpf;
  RollingAverage<float> mean, rms;
  RollingAverage<float> phi_lpf;

  float t = 0.0f, t_int = 0.0;
  float phi_gain = 5e-3, int_gain = 1e-6;

  const float t0 = 2 * M_PI * kCarrierFreq / kSampleRate;

  struct Result {
    float i, q;
  };

  CostasLoop(): i_lpf(5), q_lpf(5), mean(0.05), rms(0.05), phi_lpf(0.05) {}

  Result run(int16_t input) {
    //std::cout << input << std::endl;
    const float in_raw = input;

    const float cur_mean = mean.run(in_raw);
    const float in_offset = input - cur_mean;

    const float cur_rms = rms.run(in_offset*in_offset);

    const float in = in_offset / std::sqrt(cur_rms);

    const float i = i_lpf.run(std::cos(t) * in);
    const float q = q_lpf.run(std::sin(t) * in);

    //write(1, &i, sizeof(i));
    //write(1, &q, sizeof(q));
    const float phi = phi_lpf.run(i * q);

    t += t0 + t_int - phi_gain * phi;
    t_int -= int_gain * phi;

    if (t > 2 * M_PI) {
      t -= 2 * M_PI;
    }

    return Result {
      i, q
    };
  }
};

struct SchmittTrigger {
  int cur_val = -1;
  static constexpr float kPositiveThreshold = 50.0f;
  static constexpr float kNegativeThreshold = -50.0f;
  int run(float val) {
    if (cur_val < 0) {
      if (val > kPositiveThreshold) {
        cur_val = 1;
      }
    } else {
      if (val < kNegativeThreshold) {
        cur_val = -1;
      }
    }
    return cur_val;
  }
};

struct Slicer {
  static const int sample_rate = 100000;
  static const int bitrate = 2000;
  static const int samples_per_bit = sample_rate / bitrate;
  int last_val = -1, cur_val = -1;
  int sample_count = 0, cur_bit = 0;
  unsigned char cur_byte = 0;

  bool timeout = false;
  int timeout_count = 0;

  template <typename F> void run(F f, int v) {
    if (timeout) {
      sample_count = 0;
      cur_byte = 0;
      cur_bit = 0;

      if (v != cur_val) {
        //std::cerr << "start edge" << std::endl;
        timeout = false;
        last_val = cur_val;
      }
    } else {
      if (sample_count == samples_per_bit/2) {
        if (v != last_val) {
          cur_byte = (cur_byte << 1) | 1;
          timeout_count = 0;
        } else {
          cur_byte = (cur_byte << 1) | 0;
          ++timeout_count;
          if (timeout_count > 50) {
            //std::cerr << "timeout" << std::endl;
            timeout = true;
          }
        }
        last_val = v;
        cur_val = v;
      }

      bool next_bit = false;
      if ((v != cur_val) && (sample_count > samples_per_bit/2)) {
        //std::cerr << "edge " << sample_count << std::endl;
        sample_count = 0;
        next_bit = true;
        cur_val = v;
      }

      ++sample_count;
      if (sample_count >= samples_per_bit) {
        sample_count = 0;
        next_bit = true;
      }

      if (next_bit) {
        ++cur_bit;
      }

      if (cur_bit == 8) {
        //std::cerr << std::hex << (unsigned int)cur_byte << std::endl;
        f(cur_byte);
        cur_byte = 0;
        cur_bit = 0;
      }
    }
  }
};

int main(int argc, char** argv) {
  if (argc < 2) {
    fprintf(stderr, "missing argument\n");
    return -1;
  }

  int fd = open(argv[1], O_RDONLY);
  CostasLoop costas_loop;
  SlidingWindow<float> i_lpf2(25);
  SchmittTrigger thresholder;
  Slicer slicer;

  int count = 0;

  read_loop(fd,
    [&](int16_t val) {
      const auto costas_r = costas_loop.run(val);
      const auto filtered_i = i_lpf2.run(costas_r.i);
      //std::cout << filtered_i << std::endl;
      const auto thresh = thresholder.run(filtered_i);
      slicer.run([&](uint8_t byte) {
          std::cout << std::hex << (unsigned int) byte << std::endl;
          }, thresh);
      ++count;
    });
  close(fd);

  return 0;
}
