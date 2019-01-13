#include <avr/interrupt.h>

#include "io_attiny412.h"

#define SEI() asm volatile ("sei")
#define CLI() asm volatile ("cli")

//#define F_CPU (3333333UL)
#define F_CPU   (20000000UL)

static void clk_init() {
  // unlock the clock prescaler register
  CPU_CCP = CPU_CCP_IOREG;
  // disable the prescaler to get 6x clock rate
  MCLKCTRLB = 0;
}


static void adc_init() {
  ADC0_CTRLA = ADC_CTRLA_FREERUN; // no run on standby, 10-bit, free running, don't enable yet
  ADC0_CTRLB = ADC_CTRLB_SAMPNUM_NONE;
  /*
  ADC0_CTRLC = ADC_CTRLC_SAMPCAP_BIG | ADC_CTRLC_REFSEL_VDD |
    ADC_CTRLC_PRESC_DIV4; // 4x prescale so that the 3.333 MHz clock is slowed down to below 1.5 MHz, max specified clock rate for the ADC
    */
  ADC0_CTRLC = ADC_CTRLC_SAMPCAP_BIG | ADC_CTRLC_REFSEL_VDD |
    //ADC_CTRLC_PRESC_DIV16; // 32x prescale so that the 20 MHz clock is slowed down to below 1.5 MHz, max specified clock rate for the ADC
    ADC_CTRLC_PRESC_DIV64; // 32x prescale so that the 20 MHz clock is slowed down to below 1.5 MHz, max specified clock rate for the ADC

  ADC0_MUXPOS = ADC_MUXPOS_AIN7;

  // enable interrupt
  ADC0_INTCTRL |= ADC_INTCTRL_RESRDY;

  ADC0_CTRLA |= ADC_CTRLA_ENABLE;

  //ADC0_COMMAND = ADC_COMMAND_STCONV;
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

  USART0_BAUD = (64UL*F_CPU/115200UL/16UL);
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

#define SEND_MSG(x) do { \
    static char msg_str[] = x; \
    static struct usart_msg msg = { \
      .msg = msg_str, \
      .len = sizeof(msg_str) - 1, \
      .next = 0 \
    }; \
    usart_write(&msg); \
  } while (0)


volatile int adc_target = 512;
SIGNAL(USART0_RXC_vect) {
  unsigned char tmp = USART0_RXDATAL;
  static unsigned int new_adc_target = 0;
  if (tmp & 0x80) {
    new_adc_target = new_adc_target << 4;
    new_adc_target |= (tmp & 0x000f);
  } else {
    static char str[8] = "xXXXX\x0a\x0d";
    static struct usart_msg cust_msg = {
      .msg = str,
      .len = 7,
      .next = 0
    };
    switch (tmp) {
      case 'g':
        VPORTA_OUT |= (1 << 3);
        SEND_MSG("en\x0a\x0d");
        break;
      case 'G':
        VPORTA_OUT &= ~(1 << 3);
        SEND_MSG("dis\x0a\x0d");
        break;
      case 'a':
        str[0] = 't';
        str[1] = ((new_adc_target >> 12) & 0x0f) + 'a';
        str[2] = ((new_adc_target >> 8) & 0x0f) + 'a';
        str[3] = ((new_adc_target >> 4) & 0x0f) + 'a';
        str[4] = ((new_adc_target >> 0) & 0x0f) + 'a';
        usart_write(&cust_msg);
        break;
      case 'A':
        {
          int target_tmp = adc_target;
          str[0] = 'T';
          str[1] = ((target_tmp >> 12) & 0x0f) + 'a';
          str[2] = ((target_tmp >> 8) & 0x0f) + 'a';
          str[3] = ((target_tmp >> 4) & 0x0f) + 'a';
          str[4] = ((target_tmp >> 0) & 0x0f) + 'a';
        }
        usart_write(&cust_msg);
        break;
      case 'w':
        adc_target = (new_adc_target & 0x03ff);
        {
          int target_tmp = adc_target;
          str[0] = 'w';
          str[1] = ((target_tmp >> 12) & 0x0f) + 'a';
          str[2] = ((target_tmp >> 8) & 0x0f) + 'a';
          str[3] = ((target_tmp >> 4) & 0x0f) + 'a';
          str[4] = ((target_tmp >> 0) & 0x0f) + 'a';
          usart_write(&cust_msg);
        }
        break;
      case 'q':
        {
          int adc_tmp = adc_val;
          str[0] = 'T';
          str[1] = ((adc_tmp >> 12) & 0x0f) + 'a';
          str[2] = ((adc_tmp >> 8) & 0x0f) + 'a';
          str[3] = ((adc_tmp >> 4) & 0x0f) + 'a';
          str[4] = ((adc_tmp >> 0) & 0x0f) + 'a';
          usart_write(&cust_msg);
        }
        break;
      default:
        SEND_MSG("err\x0a\x0d");
    }
  }
}

int main() {
  clk_init();
  usart_init();
  adc_init();
  SEI();

  VPORTA_DIR |= (1 << 6) | (1 << 3);
  VPORTA_OUT |= (1 << 6);
  VPORTA_OUT &= ~(1 << 3);

  adc_start_measurement();

  int error = 0;
  int pdm_target = 4*(adc_target - 512L);
  int last_adc = -1;
  while (1) {
    // ADC control loop
    if (adc_val != -1) {
      // effectively gain of s/4; pdm_target is scaled up by four above
      pdm_target -= (adc_val - adc_target)/2;
      pdm_target -= 128*(adc_val - last_adc);
      pdm_target -= 128*(adc_val - last_adc);
      last_adc = adc_val;
      // clamp to scaled -1 to 1
      if (pdm_target > 4*512L) {
        pdm_target = 4*512L;
      }
      if (pdm_target < -4*512L) {
        pdm_target = -4*512L;
      }
      adc_val = -1;
    }
    if (pdm_target >= error) {
      VPORTA_OUT |= (1 << 6);
      error += 4*512 - pdm_target;
    } else {
      VPORTA_OUT &= ~(1 << 6);
      error += -4*512 - pdm_target;
    }
  }

  return 0;
}
