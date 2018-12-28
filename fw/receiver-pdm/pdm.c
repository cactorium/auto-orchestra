#include "io_attiny412.h"

int main() {
  VPORTA_DIR |= (1 << 6);
  VPORTA_OUT |= (1 << 6);
  while (1) {
    for (unsigned int i = 0; i < 10000; ++i) {
      asm volatile ("");
    }
    VPORTA_OUT ^= (1 << 6);
  }

  return 0;
}
