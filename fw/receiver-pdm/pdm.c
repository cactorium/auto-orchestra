#include <avr/interrupt.h>

#include "io_attiny412.h"

#define SEI() asm volatile ("sei")
#define CLI() asm volatile ("cli")


static void clk_init() {
  // TODO disable the prescaler to get 6x clock rate
}


static void adc_init() {
  ADC0_CTRLA = 0; // no run on standby, 10-bit, no free running, don't enable yet
  ADC0_CTRLB = ADC_CTRLB_SAMPNUM_NONE;
  ADC0_CTRLC = ADC_CTRLC_SAMPCAP_BIG | ADC_CTRLC_REFSEL_VDD |
    ADC_CTRLC_PRESC_DIV4; // 4x prescale so that the 3.333 MHz clock is slowed down to below 1.5 MHz, max specified clock rate for the ADC
  ADC0_MUXPOS = ADC_MUXPOS_AIN7;

  // enable interrupt
  ADC0_INTCTRL |= ADC_INTCTRL_RESRDY;

  ADC0_CTRLA |= ADC_CTRLA_ENABLE;
}

static void adc_start_measurement() {
  if (!(ADC0_COMMAND & ADC_COMMAND_STCONV)) {
    ADC0_COMMAND = ADC_COMMAND_STCONV;
  }
}

volatile int adc_val = -1;
SIGNAL(ADC0_RESRDY_vect) {
  adc_val = ADC0_RES;
}


static void usart_init() {
  VPORTA_DIR |= (1 << 1);
  VPORTA_OUT |= (1 << 1);
  PORTMUX_CTRLB |= PORTMUX_CTRLB_USART0;

  USART0_BAUD = (64UL*3333333UL/115200UL/16UL);
  USART0_CTRLC = (USART_CTRLC_CMODE_ASYNCHRONOUS |
      USART_CTRLC_PMODE_DISABLED |
      USART_CTRLC_CHSIZE_8BIT);
  USART0_CTRLB |= USART_CTRLB_TXEN | USART_CTRLB_RXEN;
  USART0_CTRLA |= USART_CTRLA_RXCIE;
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
  if (!usart_cur_msg) {
    usart_cur_msg = msg;
    usart_pos = -1;
    USART0_CTRLA |= USART_CTRLA_DREIE;
    SEI();
    return;
  }

  CLI();
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

SIGNAL(USART0_RXC_vect) {
  unsigned char tmp = USART0_RXDATAL;
  adc_start_measurement();
}

int main() {
  clk_init();
  usart_init();
  adc_init();
  SEI();

  VPORTA_DIR |= (1 << 6);
  VPORTA_OUT |= (1 << 6);

  static char msg[] = {0xff, 0xff, 0x00, 0x00};
  static struct usart_msg test_msg = {
    .msg = msg,
    .len = 4,
    .next = 0
  };

  while (1) {
    if (adc_val != -1) {
      unsigned int new_val = adc_val;
      msg[0] = (new_val >> 8) & 0x0ff;
      msg[1] = new_val & 0x0ff;
      adc_val = -1;
    }
    //msg[0] = adc_val;
    usart_write(&test_msg);
    for (unsigned int i = 0; i < 10000; ++i) {
      asm volatile ("");
    }
    VPORTA_OUT ^= (1 << 6);
  }

  return 0;
}
