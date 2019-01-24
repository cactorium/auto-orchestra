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

#include <libopencm3/cm3/nvic.h>

#include <libopencm3/stm32/crs.h>
#include <libopencm3/stm32/gpio.h>
#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/syscfg.h>
#include <libopencm3/stm32/timer.h>

#include "usb.c"

static void timer3_setup() {
  rcc_periph_clock_enable(RCC_TIM3);
  nvic_enable_irq(NVIC_TIM3_IRQ);

  //timer_reset(TIM3);
  timer_set_mode(TIM3, TIM_CR1_CKD_CK_INT, TIM_CR1_CMS_EDGE, TIM_CR1_DIR_UP);
  // prescaled clock = 100 kHz, 10 us
  timer_set_prescaler(TIM3, 480);
  // slow down to 10 Hz for now
  timer_set_period(TIM3, 10000);
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

    static char buf[] = "test\r\n";
    usbd_ep_write_packet(usbd_dev, 0x82, buf, sizeof(buf)-1);
  }
}

int main(void) {

  /*
     rcc_clock_setup_in_hsi48_out_48mhz();
     crs_autotrim_usb_enable();
     rcc_set_usbclk_source(RCC_HSI48);
     */
  rcc_clock_setup_in_hse_8mhz_out_48mhz();

  timer3_setup();
  usb_setup();

  usbd_dev = usbd_init(&st_usbfs_v2_usb_driver, &dev, &config, usb_strings,
      3, usbd_control_buffer, sizeof(usbd_control_buffer));
  usbd_register_set_config_callback(usbd_dev, cdcacm_set_config);

  while (1) {
    usbd_poll(usbd_dev);
  }
}
