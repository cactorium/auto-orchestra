#include <avr/interrupt.h>

#include "io_attiny412.h"

#define SEI() asm volatile ("sei")
#define CLI() asm volatile ("cli")


static void usart_init() {
  VPORTA_DIR |= (1 << 1);
  VPORTA_OUT |= (1 << 1);
  PORTMUX_CTRLB |= PORTMUX_CTRLB_USART0;

  USART0_BAUD = (64UL*3333333UL/115200UL/16UL);
  USART0_CTRLC = (USART_CTRLC_CMODE_ASYNCHRONOUS |
      USART_CTRLC_PMODE_DISABLED |
      USART_CTRLC_CHSIZE_8BIT);
  USART0_CTRLB |= USART_CTRLB_TXEN;
}

static void clk_init() {
  // TODO disable the prescaler to get 6x clock rate
}

struct usart_msg {
  char* msg;
  int len;
  struct usart_msg* next;
};
volatile struct usart_msg* usart_cur_msg = 0;
volatile int usart_pos = -1;

static void usart_write(struct usart_msg* msg) {
  msg->next = 0;
  CLI();
  if (!usart_cur_msg) {
    usart_cur_msg = msg;
    usart_pos = -1;
    USART0_CTRLA |= USART_CTRLA_DREIE;
    SEI();
    return;
  }

  struct usart_msg* next_msg = (struct usart_msg*) usart_cur_msg;
  struct usart_msg* last_msg = 0;
  while (next_msg) {
    if (next_msg == msg) {
      SEI();
      return;
    }
    last_msg = next_msg;
    next_msg = last_msg->next;
  }
  last_msg->next = msg;
  USART0_CTRLA |= USART_CTRLA_DREIE;
  SEI();
}

SIGNAL(USART0_DRE_vect) {
  if (usart_cur_msg) {
    ++usart_pos;
    if (usart_pos >= usart_cur_msg->len) {
      usart_cur_msg = usart_cur_msg->next;
      usart_pos = 0;
    }
  }
    
  if (usart_cur_msg) {
    USART0_TXDATAL = usart_cur_msg->msg[usart_pos];
    //USART0_TXDATAL = usart_pos;
  } else {
    USART0_CTRLA &= ~USART_CTRLA_DREIE;
    usart_pos = -1;
  }
}

static void adc_init() {
  // TODO
}

int main() {
  clk_init();
  usart_init();
  SEI();

  VPORTA_DIR |= (1 << 6);
  VPORTA_OUT |= (1 << 6);
  while (1) {
    static char msg[] = "test";
    static struct usart_msg test_msg = {
      .msg = msg,
      .len = 4,
      .next = 0
    };
    usart_write(&test_msg);
    for (unsigned int i = 0; i < 10000; ++i) {
      asm volatile ("");
    }
    VPORTA_OUT ^= (1 << 6);
  }

  return 0;
}
