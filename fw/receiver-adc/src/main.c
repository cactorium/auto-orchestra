/*
 * This file is part of the libopencm3 project.
 *
 * Copyright (C) 2010 Gareth McMullin <gareth@blacksphere.co.nz>
 *
 * This library is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <stdlib.h>
#include <string.h>

#include <libopencm3/cm3/nvic.h>

#include <libopencm3/stm32/crs.h>
#include <libopencm3/stm32/gpio.h>
#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/spi.h>
#include <libopencm3/stm32/syscfg.h>
#include <libopencm3/stm32/timer.h>
#include <libopencm3/stm32/usart.h>

volatile uint8_t status_byte = 0;
#define STATUS_USB_RDY       (1 << 0)
#define STATUS_ANALOG_EN     (1 << 1)
#define STATUS_ADC_EN        (1 << 2)
#define STATUS_GAIN33X_EN    (1 << 3)
#define STATUS_USART_ERR     (1 << 4)

#include "usb.c"

static void timer3_setup() {
  rcc_periph_clock_enable(RCC_TIM3);
  nvic_enable_irq(NVIC_TIM3_IRQ);

  //timer_reset(TIM3);
  timer_set_mode(TIM3, TIM_CR1_CKD_CK_INT, TIM_CR1_CMS_EDGE, TIM_CR1_DIR_UP);
  // prescaled clock = 1 MHz, 1 us
  timer_set_prescaler(TIM3, 48);
  // slow down to 50 kHz for ADC sampling
  timer_set_period(TIM3, 20);
  timer_disable_oc_output(TIM3, TIM_OC1 | TIM_OC2 | TIM_OC3 | TIM_OC4);
  timer_disable_oc_clear(TIM3, TIM_OC1);
  timer_disable_oc_preload(TIM3, TIM_OC1);
  timer_set_oc_slow_mode(TIM3, TIM_OC1);
  timer_set_oc_mode(TIM3, TIM_OC1, TIM_OCM_FROZEN);
  timer_set_oc_value(TIM3, TIM_OC1, 0);

  timer_continuous_mode(TIM3);
  timer_disable_preload(TIM3);
  timer_enable_counter(TIM3);
  timer_enable_irq(TIM3, TIM_DIER_CC1IE);
}

usbd_device *usbd_dev;

void tim3_isr() {
  if (timer_get_flag(TIM3, TIM_SR_CC1IF)) {
    timer_clear_flag(TIM3, TIM_SR_CC1IF);

    if (status_byte & STATUS_ADC_EN) {
      spi_enable(SPI1);
      SPI1_DR = 0x0000;
    }

    //static char buf[] = "test\r\n";
    //usbd_ep_write_packet(usbd_dev, 0x82, buf, sizeof(buf)-1);
  }
}

volatile int buf_full = 0;
#define kBufSz 30
uint16_t buf1[kBufSz];
uint16_t buf2[kBufSz];
volatile uint16_t *cur_buf = buf1;

volatile int pos = 0;

void spi1_isr() {
  // NOTE: this is much simpler than the correct procedure
  // nonetheless, this is how I'm gonna do it
  if (SPI1_SR & SPI_SR_RXNE) {
    uint16_t data = SPI1_DR;
    cur_buf[pos] = data;
    ++pos;
    if (pos == kBufSz) {
      pos = 0;
      if (cur_buf == buf1) {
        cur_buf = buf2;
      } else {
        cur_buf = buf1;
      }
      buf_full = 1;
    }
    spi_disable(SPI1);
  }
}

static void spi_setup() {
  rcc_periph_clock_enable(RCC_GPIOA);
  //rcc_periph_clock_enable(RCC_AFIO);
  rcc_periph_clock_enable(RCC_SPI1);

  gpio_mode_setup(GPIOA, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO4 | GPIO5 | GPIO6 | GPIO7);
  gpio_set_af(GPIOA, GPIO_AF0, GPIO4 | GPIO5 | GPIO6 | GPIO7);
  spi_reset(SPI1);
  // clock rate = 1.5 MHz,
  // receive time = 10.6 us
  spi_init_master(SPI1, SPI_CR1_BR_FPCLK_DIV_64, SPI_CR1_CPOL_CLK_TO_1_WHEN_IDLE, 
      SPI_CR1_CPHA_CLK_TRANSITION_2, SPI_CR1_MSBFIRST);
  spi_set_data_size(SPI1, SPI_CR2_DS_16BIT);
  //spi_enable_software_slave_management(SPI1);
  //spi_set_nss_high(SPI1);
  spi_enable_ss_output(SPI1);
  spi_enable_rx_buffer_not_empty_interrupt(SPI1);
  nvic_enable_irq(NVIC_SPI1_IRQ);
}

static void usart_setup() {
  rcc_periph_clock_enable(RCC_GPIOA);
  rcc_periph_clock_enable(RCC_USART2);

  gpio_mode_setup(GPIOA, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO2 | GPIO3);
  gpio_set_af(GPIOA, GPIO_AF1, GPIO2 | GPIO3);

  usart_set_baudrate(USART2, 115200);
  usart_set_databits(USART2, 8);
  usart_set_parity(USART2, USART_PARITY_NONE);
  usart_set_stopbits(USART2, USART_CR2_STOPBITS_1);
  usart_set_mode(USART2, USART_MODE_TX_RX);
  usart_set_flow_control(USART2, USART_FLOWCONTROL_NONE);

  usart_enable(USART2);
}

struct usart_msg {
  char* str;
  int len;
  struct usart_msg* next;
};

struct usart_msg* cur_msg = 0;
volatile int usart_pos = 0;

static void usart2_rx(uint8_t c);

void usart2_process() {
  // check rx
  if (usart_get_flag(USART2, USART_ISR_RXNE)) {
    uint8_t c = usart_recv(USART2);
    usart2_rx(c);
  }
  // check tx
  if (usart_get_flag(USART2, USART_ISR_TXE)) {
    if (cur_msg) {
      usart_send(USART2, cur_msg->str[usart_pos]);
      ++usart_pos;

      if (usart_pos >= cur_msg->len) {
        cur_msg = cur_msg->next;
      }
    }
  }
}

static void usart2_tx_msg(struct usart_msg* msg) {
  msg->next = 0;
  if (!cur_msg) {
    cur_msg = msg;
    usart_pos = 0;
    return;
  }
  struct usart_msg* m = cur_msg;
  struct usart_msg* n = m->next;
  while (n) {
    m = n;
    n = m->next;
  }
  m->next = msg;
}

static void usart2_rx(uint8_t c) {
  (void) c;
  // TODO check responses from MCU
}

int main(void) {

  /*
     rcc_clock_setup_in_hsi48_out_48mhz();
     crs_autotrim_usb_enable();
     rcc_set_usbclk_source(RCC_HSI48);
     */
  rcc_clock_setup_in_hse_8mhz_out_48mhz();

  timer3_setup();
  usart_setup();
  spi_setup();
  usb_setup();

  usbd_dev = usbd_init(&st_usbfs_v2_usb_driver, &dev, &config, usb_strings,
      3, usbd_control_buffer, sizeof(usbd_control_buffer));
  usbd_register_set_config_callback(usbd_dev, cdcacm_set_config);

  uint8_t old_analog_en = 0;
  uint8_t old_gain_en = 0;

  while (1) {
    usart2_process();
    if ((status_byte & STATUS_ANALOG_EN) != old_analog_en) {
      old_analog_en = (status_byte & STATUS_ANALOG_EN);
      // TODO set analog enable gpio pin based on status byte
    }
    if ((status_byte & STATUS_GAIN33X_EN) != old_gain_en) {
      old_gain_en = (status_byte & STATUS_GAIN33X_EN);

      // send a byte to the MCU
      static char gain_str[1] = { 'g' };
      gain_str[0] = old_gain_en ? 'g' : 'G';
      static struct usart_msg gain_msg = {
        .str = gain_str,
        .len = sizeof(gain_str),
        .next = 0,
      };
      usart2_tx_msg(&gain_msg);
    }
    if (buf_full) {
      buf_full = 0;
      uint16_t *buf;
      if (cur_buf == buf1) {
        buf = buf2;
      } else {
        buf = buf1;
      }
      if (status_byte & STATUS_USB_RDY) {
        static uint8_t packet1[4 + 2*kBufSz];
        static uint8_t packet2[4 + 2*kBufSz];
        static uint8_t* packet = packet1;

        packet[0] = 0xff;
        packet[1] = 0x00;
        packet[2] = status_byte;
        packet[3] = ~status_byte;
        memcpy(packet + 4, buf, 2*kBufSz);
 
        usbd_ep_write_packet(usbd_dev, 0x82, packet, 4 + 2*kBufSz);
        if (packet == packet1) {
          packet = packet2;
        } else {
          packet = packet1;
        }
      }
    }
    if (commit_gain) {
      int gain_set = new_gain_set;
      commit_gain = 0;
      // TODO send message to MCU
      (void) gain_set;
    }
    usbd_poll(usbd_dev);
  }
}
