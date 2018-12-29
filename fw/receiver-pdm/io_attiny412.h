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

// CLKCTRL registers
#define MCLKCTRLA       _SFR_MEM8(CLKCTRL_BASE + (0x00))
#define MCLKCTRLB       _SFR_MEM8(CLKCTRL_BASE + (0x01))
#define MCLKLOCK        _SFR_MEM8(CLKCTRL_BASE + (0x02))
#define MCLKSTATUS      _SFR_MEM8(CLKCTRL_BASE + (0x03))
#define OSC20MCTRLA     _SFR_MEM8(CLKCTRL_BASE + (0x10))
#define OSC20MCALIBA    _SFR_MEM8(CLKCTRL_BASE + (0x11))
#define OSC20MCALIBB    _SFR_MEM8(CLKCTRL_BASE + (0x12))
#define OSC32KCTRLA     _SFR_MEM8(CLKCTRL_BASE + (0x18))
#define XOSC32KCTRLA    _SFR_MEM8(CLKCTRL_BASE + (0x1C))

// CLKCTRL constants
//#define MCLKCTRLA_CLKSEL0 (0x01)
//#define MCLKCTRLA_CLKSEL1 (0x02)
#define MCLKCTRLA_CLKOUT  (0x80)

#define MCLKCTRLA_CLKSEL_OSC20M     (0x00)
#define MCLKCTRLA_CLKSEL_OSCULP32K  (0x01)
#define MCLKCTRLA_CLKSEL_XOSC32K    (0x02)
#define MCLKCTRLA_CLKSEL_EXTCLK     (0x03)

#define MCLKCTRLB_PEN     (0x01)
//#define MCLKCTRLB_PDIV0   (0x02)
//#define MCLKCTRLB_PDIV1   (0x04)
//#define MCLKCTRLB_PDIV2   (0x08)
//#define MCLKCTRLB_PDIV3   (0x10)

#define MCLKCTRLB_PDIV2     (0x00)    // NOTE: first bit is prescaler enable, so
#define MCLKCTRLB_PDIV4     (0x02)    // these all are shifted up 1 bit
#define MCLKCTRLB_PDIV8     (0x04)
#define MCLKCTRLB_PDIV16    (0x06)
#define MCLKCTRLB_PDIV32    (0x08)
#define MCLKCTRLB_PDIV64    (0x0A)
#define MCLKCTRLB_PDIV6     (0x10)
#define MCLKCTRLB_PDIV10    (0x12)
#define MCLKCTRLB_PDIV12    (0x14)
#define MCLKCTRLB_PDIV24    (0x16)
#define MCLKCTRLB_PDIV48    (0x18)

#define MCLKLOCK_LOCKEN   (0x01)

#define MCLKSTATUS_SOSC     (0x01)
#define MCLKSTATUS_OSC20MS  (0x10)
#define MCLKSTATUS_OSC32KS  (0x20)
#define MCLKSTATUS_XOSC32KS (0x40)
#define MCLKSTATUS_EXTS     (0x80)

#define OSC20MCTRLA_RUNSTDBY  (0x02)

#define OSC20MCALIBB_LOCK     (0x80)

#define OSC32KCTRLA_RUNSTDBY  (0x02)

#define XOSC32KCTRLA_ENABLE   (0x01)
#define XOSC32KCTRLA_RUNSTDBY (0x02)
#define XOSC32KCTRLA_SEL      (0x04)
//#define XOSC32KCTRLA_CSUT0    (0x10)
//#define XOSC32KCTRLA_CSUT1    (0x20)
#define XOSC32KCTRLA_CSUT_1K    (0x00)
#define XOSC32KCTRLA_CSUT_16K   (0x10)
#define XOSC32KCTRLA_CSUT_32K   (0x20)
#define XOSC32KCTRLA_CSUT_64K   (0x30)

#define XOSC32KCTRLA_SEL_XTAL   (0x00)
#define XOSC32KCTRLA_SEL_XOSC   (0x04)

// PORTMUX registers
#define PORTMUX_CTRLA   _SFR_MEM8(PORTMUX_BASE + (0x00))
#define PORTMUX_CTRLB   _SFR_MEM8(PORTMUX_BASE + (0x01))

// PORTMUX constants
#define PORTMUX_CTRLA_EVOUT0  (0x01)
#define PORTMUX_CTRLB_SPI0    (0x04)
#define PORTMUX_CTRLB_USART0  (0x01)

// ADC0 registers
#define ADC0_CTRLA            _SFR_MEM8(ADC0_BASE + (0x00))
#define ADC0_CTRLB            _SFR_MEM8(ADC0_BASE + (0x01))
#define ADC0_CTRLC            _SFR_MEM8(ADC0_BASE + (0x02))
#define ADC0_CTRLD            _SFR_MEM8(ADC0_BASE + (0x03))
#define ADC0_CTRLE            _SFR_MEM8(ADC0_BASE + (0x04))
#define ADC0_SAMPLECTRL       _SFR_MEM8(ADC0_BASE + (0x05))
#define ADC0_MUXPOS           _SFR_MEM8(ADC0_BASE + (0x06))
#define ADC0_COMMAND          _SFR_MEM8(ADC0_BASE + (0x08))
#define ADC0_EVCTRL           _SFR_MEM8(ADC0_BASE + (0x09))
#define ADC0_INTCTRL          _SFR_MEM8(ADC0_BASE + (0x0A))
#define ADC0_INTFLAGS         _SFR_MEM8(ADC0_BASE + (0x0B))
#define ADC0_DBGCTRL          _SFR_MEM8(ADC0_BASE + (0x0C))
#define ADC0_TEMP             _SFR_MEM8(ADC0_BASE + (0x0D))
#define ADC0_RES              _SFR_MEM16(ADC0_BASE + (0x10))
#define ADC0_RESL             _SFR_MEM8(ADC0_BASE + (0x10))
#define ADC0_RESH             _SFR_MEM8(ADC0_BASE + (0x11))
#define ADC0_WINLT            _SFR_MEM16(ADC0_BASE + (0x12))
#define ADC0_WINLTL           _SFR_MEM8(ADC0_BASE + (0x12))
#define ADC0_WINLTH           _SFR_MEM8(ADC0_BASE + (0x13))
#define ADC0_WINHT            _SFR_MEM16(ADC0_BASE + (0x14))
#define ADC0_WINHTL           _SFR_MEM8(ADC0_BASE + (0x14))
#define ADC0_WINHTH           _SFR_MEM8(ADC0_BASE + (0x15))

// ADC constants
#define ADC_CTRLA_RUNSTBY     (0x80)
#define ADC_CTRLA_RESSEL      (0x04)
#define ADC_CTRLA_FREERUN     (0x02)
#define ADC_CTRLA_ENABLE      (0x01)

#define ADC_CTRLB_SAMPNUM_NONE    (0x00)
#define ADC_CTRLB_SAMPNUM_ACC2    (0x01)
#define ADC_CTRLB_SAMPNUM_ACC4    (0x02)
#define ADC_CTRLB_SAMPNUM_ACC8    (0x03)
#define ADC_CTRLB_SAMPNUM_ACC16   (0x04)
#define ADC_CTRLB_SAMPNUM_ACC32   (0x05)
#define ADC_CTRLB_SAMPNUM_ACC64   (0x06)

#define ADC_CTRLC_SAMPCAP_BIG     (0x00)
#define ADC_CTRLC_SAMPCAP_SMALL   (0x40)

#define ADC_CTRLC_REFSEL_INTERNAL (0x00)
#define ADC_CTRLC_REFSEL_VDD      (0x10)

#define ADC_CTRLC_PRESC_DIV2      (0x00)
#define ADC_CTRLC_PRESC_DIV4      (0x01)
#define ADC_CTRLC_PRESC_DIV8      (0x02)
#define ADC_CTRLC_PRESC_DIV16     (0x03)
#define ADC_CTRLC_PRESC_DIV32     (0x04)
#define ADC_CTRLC_PRESC_DIV64     (0x05)
#define ADC_CTRLC_PRESC_DIV128    (0x06)
#define ADC_CTRLC_PRESC_DIV256    (0x07)

#define ADC_CTRLD_INITDLK_DLY0    (0x00)
#define ADC_CTRLD_INITDLK_DLY16   (0x20)
#define ADC_CTRLD_INITDLK_DLY32   (0x40)
#define ADC_CTRLD_INITDLK_DLY64   (0x60)
#define ADC_CTRLD_INITDLK_DLY128  (0x80)
#define ADC_CTRLD_INITDLK_DLY256  (0xA0)

#define ADC_CTRLD_ASDV            (0x10)

#define ADC_CTRLE_WINCM_NONE      (0x00)
#define ADC_CTRLE_WINCM_BELOW     (0x01)
#define ADC_CTRLE_WINCM_ABOVE     (0x02)
#define ADC_CTRLE_WINCM_INSIDE    (0x03)
#define ADC_CTRLE_WINCM_OUTSIDE   (0x04)

#define ADC_MUXPOS_AIN0           (0x00)
#define ADC_MUXPOS_AIN1           (0x01)
#define ADC_MUXPOS_AIN2           (0x02)
#define ADC_MUXPOS_AIN3           (0x03)
#define ADC_MUXPOS_AIN4           (0x04)
#define ADC_MUXPOS_AIN5           (0x05)
#define ADC_MUXPOS_AIN6           (0x06)
#define ADC_MUXPOS_AIN7           (0x07)
#define ADC_MUXPOS_AIN8           (0x08)
#define ADC_MUXPOS_AIN9           (0x09)
#define ADC_MUXPOS_AIN10          (0x0A)
#define ADC_MUXPOS_AIN11          (0x0B)
#define ADC_MUXPOS_DAC0           (0x1C)
#define ADC_MUXPOS_INTREF         (0x1D)
#define ADC_MUXPOS_TEMPSENSE      (0x1E)
#define ADC_MUXPOS_GND            (0x1F)

#define ADC_COMMAND_STCONV        (0x01)

#define ADC_EVCTRL_STARTEI        (0x01)

#define ADC_INTCTRL_WCOMP         (0x02)
#define ADC_INTCTRL_RESRDY        (0x01)

#define ADC_INTFLAGS_WCOMP        (0x02)
#define ADC_INTFLAGS_RESRDY       (0x01)

#define ADC_DBGCTRL_DBGRUN        (0x01)

// USART0 registers
// TODO see if the 16 bit registers work correctly
#define USART0_RXDATA       _SFR_MEM16(USART0_BASE + (0x00))
#define USART0_RXDATAL      _SFR_MEM8(USART0_BASE + (0x00))
#define USART0_RXDATAH      _SFR_MEM8(USART0_BASE + (0x01))
#define USART0_TXDATA       _SFR_MEM16(USART0_BASE + (0x02))
#define USART0_TXDATAL      _SFR_MEM8(USART0_BASE + (0x02))
#define USART0_TXDATAH      _SFR_MEM8(USART0_BASE + (0x03))
#define USART0_STATUS       _SFR_MEM8(USART0_BASE + (0x04))

#define USART0_CTRLA        _SFR_MEM8(USART0_BASE + (0x05))
#define USART0_CTRLB        _SFR_MEM8(USART0_BASE + (0x06))
#define USART0_CTRLC        _SFR_MEM8(USART0_BASE + (0x07))
#define USART0_BAUD         _SFR_MEM16(USART0_BASE + (0x08))
#define USART0_DBGCTRL      _SFR_MEM8(USART0_BASE + (0x0B))
#define USART0_EVCTRL       _SFR_MEM8(USART0_BASE + (0x0C))
#define USART0_TXPLCTRL     _SFR_MEM8(USART0_BASE + (0x0D))
#define USART0_RXPLCTRL     _SFR_MEM8(USART0_BASE + (0x0E))

#define USART_PERR        (0x02)
#define USART_FERR        (0x04)
#define USART_BUFOVF      (0x40)
#define USART_RXCIF       (0x80)

#define USART_STATUS_WFB      (0x01)
#define USART_STATUS_BDF      (0x02)
#define USART_STATUS_ISFIF    (0x08)
#define USART_STATUS_RXSIF    (0x10)
#define USART_STATUS_DREIF    (0x20)
#define USART_STATUS_TXCIF    (0x40)
#define USART_STATUS_RXCIF    (0x80)

#define USART_CTRLA_RXCIE     (0x80)
#define USART_CTRLA_TXCIE     (0x40)
#define USART_CTRLA_DREIE     (0x20)
#define USART_CTRLA_RXSIE     (0x10)
#define USART_CTRLA_LBME      (0x80)
#define USART_CTRLA_ABIE      (0x40)

#define USART_CTRLA_RS485_OFF (0x00)
#define USART_CTRLA_RS485_EXT (0x01)
#define USART_CTRLA_RS485_INT (0x02)

#define USART_CTRLB_RXEN            (0x80)
#define USART_CTRLB_TXEN            (0x40)
#define USART_CTRLB_SFDEN           (0x10)
#define USART_CTRLB_ODME            (0x08)
#define USART_CTRLB_MPCM            (0x01)

#define USART_CTRLB_RXMODE_NORMAL   (0x00)
#define USART_CTRLB_RXMODE_CLK2X    (0x02)
#define USART_CTRLB_RXMODE_GENAUTO  (0x04)
#define USART_CTRLB_RXMODE_LINAUTO  (0x06)

#define USART_CTRLC_CMODE_ASYNCHRONOUS    (0x00)
#define USART_CTRLC_CMODE_SYNCHRONOUS     (0x40)
#define USART_CTRLC_CMODE_IRCOM           (0x80)
#define USART_CTRLC_CMODE_MSPI            (0xC0)

#define USART_CTRLC_PMODE_DISABLED        (0x00)
#define USART_CTRLC_PMODE_EVEN            (0x20)
#define USART_CTRLC_PMODE_ODD             (0x40)

#define USART_CTRLC_SBMODE_1BIT           (0x00)
#define USART_CTRLC_SBMODE_2BIT           (0x08)

#define USART_CTRLC_CHSIZE_5BIT           (0x00)
#define USART_CTRLC_CHSIZE_6BIT           (0x01)
#define USART_CTRLC_CHSIZE_7BIT           (0x02)
#define USART_CTRLC_CHSIZE_8BIT           (0x03)
#define USART_CTRLC_CHSIZE_9BIT_LOW       (0x06)
#define USART_CTRLC_CHSIZE_9BIT_HIGH      (0x07)

#define USART_DBGCTRL_DBGRUN              (0x01)

#define USART_EVCTRL_IREI                 (0x01)

// TODO more registers

#define CRCSCAN_NMI_vect                _VECTOR(1)
#define BOD_VLM_vect                    _VECTOR(2)
#define PORTA_PORT_vect                 _VECTOR(3)
#define RTC_CNT_vect                    _VECTOR(6)
#define RTC_PIT_vect                    _VECTOR(7)
#define TCA0_OVF_vect                   _VECTOR(8)
#define TCA0_HUNF_vect                  _VECTOR(9)
#define TCA0_CMP0_vect                  _VECTOR(10)
#define TCA0_CMP1_vect                  _VECTOR(11)
#define TCA0_CMP2_vect                  _VECTOR(12)
#define TCB0_INT_vect                   _VECTOR(13)
#define TCD0_OVF_vect                   _VECTOR(14)
#define TCD0_TRIG_vect                  _VECTOR(15)
#define AC0_AC_vect                     _VECTOR(16)
#define ADC0_RESRDY_vect                _VECTOR(17)
#define ADC0_WCOMP_vect                 _VECTOR(18)
#define TWI0_TWIS_vect                  _VECTOR(19)
#define TWI0_TWIM_vect                  _VECTOR(20)
#define SPI0_INT_vect                   _VECTOR(21)
#define USART0_RXC_vect                 _VECTOR(22)
#define USART0_DRE_vect                 _VECTOR(23)
#define USART0_TXC_vect                 _VECTOR(24)
#define NVMCTRL_EE_vect                 _VECTOR(25)

#endif
