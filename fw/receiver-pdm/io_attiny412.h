#ifndef IO_ATTINY412_H_
#define IO_ATTINY412_H_

#include <avr/sfr_defs.h>

#define VPORTA_BASE     (0x0000)
#define GPIOR_BASE      (0x001C)
#define CPU_BASE        (0x0030)
#define RSTCTRL_BASE    (0x0040)
#define SLPCTRL_BASE    (0x0050)
#define CLKCTRL_BASE    (0x0060)
#define BOD_BASE        (0x0080)
#define VREF_BASE       (0x00A0)
#define WDT_BASE        (0x0100)
#define CPUINT_BASE     (0x0110)
#define CRCSCAN_BASE    (0x0120)
#define RTC_BASE        (0x0140)
#define EVSYS_BASE      (0x0180)
#define CCL_BASE        (0x01C0)
#define PORTMUX_BASE    (0x0200)
#define PORTA_BASE      (0x0400)
#define ADC0_BASE       (0x0600)
#define DAC0_BASE       (0x06A0)
#define AC0_BASE        (0x0680)
#define USART0_BASE     (0x0800)
#define TWI0_BASE       (0x0810)
#define SPI0_BASE       (0x0820)
#define TCA0_BASE       (0x0A00)
#define TCB0_BASE       (0x0A40)
#define TCD0_BASE       (0x0A80)
#define SYSCFG_BASE     (0x0F00)
#define NVMCTRL_BASE    (0x1000)
#define SIGROW_BASE     (0x1100)
#define FUSES_BASE      (0x1280)
#define USERROW_BASE    (0x1300)

// VPORTA registers
#define VPORTA_DIR      _SFR_MEM8(VPORTA_BASE + (0x00))
#define VPORTA_OUT      _SFR_MEM8(VPORTA_BASE + (0x01))
#define VPORTA_IN       _SFR_MEM8(VPORTA_BASE + (0x02))
#define VPORTA_INTFLAGS _SFR_MEM8(VPORTA_BASE + (0x03))

// TODO add registers for a lot of stuff

// TODO add interrupt defines

#endif
