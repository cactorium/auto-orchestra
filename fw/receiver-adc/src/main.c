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

#include "usb.c"

static void timer3_setup() {
  rcc_periph_clock_enable(RCC_TIM3);
  nvic_enable_irq(NVIC_TIM3_IRQ);

  //timer_reset(TIM3);
  timer_set_mode(TIM3, TIM_CR1_CKD_CK_INT, TIM_CR1_CMS_EDGE, TIM_CR1_DIR_UP);
  // prescaled clock = 1 MHz, 1 us
  timer_set_prescaler(TIM3, 48);
  // slow down to 50 kHz for ADC sampling
  timer_set_period(TIM3, 25);
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

    spi_enable(SPI1);
    SPI1_DR = 0x0000;

    //static char buf[] = "test\r\n";
    //usbd_ep_write_packet(usbd_dev, 0x82, buf, sizeof(buf)-1);
  }
}

volatile int buf_full = 0;
#define kBufSz 8
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
      SPI_CR1_CPHA_CLK_TRANSITION_1, SPI_CR1_MSBFIRST);
  spi_set_data_size(SPI1, SPI_CR2_DS_16BIT);
  //spi_enable_software_slave_management(SPI1);
  //spi_set_nss_high(SPI1);
  spi_enable_ss_output(SPI1);
  spi_enable_rx_buffer_not_empty_interrupt(SPI1);
  nvic_enable_irq(NVIC_SPI1_IRQ);
}

int main(void) {

  /*
     rcc_clock_setup_in_hsi48_out_48mhz();
     crs_autotrim_usb_enable();
     rcc_set_usbclk_source(RCC_HSI48);
     */
  rcc_clock_setup_in_hse_8mhz_out_48mhz();

  timer3_setup();
  spi_setup();
  usb_setup();

  usbd_dev = usbd_init(&st_usbfs_v2_usb_driver, &dev, &config, usb_strings,
      3, usbd_control_buffer, sizeof(usbd_control_buffer));
  usbd_register_set_config_callback(usbd_dev, cdcacm_set_config);

  while (1) {
    if (buf_full) {
      buf_full = 0;
      uint16_t *buf;
      if (cur_buf == buf1) {
        buf = buf2;
      } else {
        buf = buf1;
      }
      static uint8_t packet[4 + sizeof(buf1)];
      packet[0] = 0xf0;
      packet[1] = 0x0f;
      packet[2] = 0x0f;
      packet[3] = 0xf0;
      memcpy(packet + 4, buf, sizeof(buf1));
 
      if (usb_rdy) {
        usbd_ep_write_packet(usbd_dev, 0x82, packet, sizeof(packet));
      }
    }
    usbd_poll(usbd_dev);
  }
}
