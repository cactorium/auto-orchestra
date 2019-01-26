/* --COPYRIGHT--,BSD
 * Copyright (c) 2017, Texas Instruments Incorporated
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * *  Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * *  Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * *  Neither the name of Texas Instruments Incorporated nor the names of
 *    its contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * --/COPYRIGHT--*/
//*****************************************************************************
// Development main.c for MSP430FR2522 and MSP430FR2512 CapTIvate devices.
//
// This starter application initializes the CapTIvate touch library
// for the touch panel specified by CAPT_UserConfig.c/.h via a call to
// CAPT_appStart(), which initializes and calibrates all sensors in the
// application, and starts the CapTIvate interval timer.
//
// Then, the capacitive touch interface is driven by calling the CapTIvate
// application handler, CAPT_appHandler().  The application handler manages
// whether the user interface (UI) is running in full active scan mode, or
// in a low-power wake-on-proximity mode.
//
// \version 1.60.00.03
// Released on November 22, 2017
//
//*****************************************************************************

#include <msp430.h>                      // Generic MSP430 Device Include
#include "driverlib.h"                   // MSPWare Driver Library
#include "captivate.h"                   // CapTIvate Touch Software Library
#include "CAPT_App.h"                    // CapTIvate Application Code
#include "CAPT_BSP.h"                    // CapTIvate EVM Board Support Package

#define GYRO_ADDR       (0x68)
#define GYRO_WHO_AM_I   (0xD5)
#define GYRO_CMD_POWERON    (0x15)

#define GYRO_CHIP_ID    (0x00)
#define GYRO_DATA       (0x12)
#define GYRO_RANGE      (0x43)
#define GYRO_INT_OUT_CTRL   (0x53)
#define GYRO_INT_MAP    (0x56)
#define GYRO_CMD        (0x7E)

#define ACCEL_ADDR      (0x19)
#define ACCEL_WHO_AM_I  (0x33)
#define ACCEL_CTRL_REG1_LPEN    (1 << 3)
#define ACCEL_CTRL_REG1_ZEN     (1 << 2)
#define ACCEL_CTRL_REG1_YEN     (1 << 1)
#define ACCEL_CTRL_REG1_XEN     (1 << 0)
#define ACCEL_CTRL_REG1_ODR100HZ    (0x3 << 4)

#define ACCEL_CTRL_REG1_ENABLEALL (ACCEL_CTRL_REG1_LPEN | ACCEL_CTRL_REG1_ZEN | ACCEL_CTRL_REG1_YEN | ACCEL_CTRL_REG1_XEN)

//#define ACCEL_CTRL_REG4_BDU     (1 << 7)
#define ACCEL_CTRL_REG4_2G      (0 << 4)

#define ACCEL_CHIP_ID   (0x0F)
#define ACCEL_CTRL_REG1 (0x20)
#define ACCEL_CTRL_REG4 (0x23)

#define ACCEL_REG_OUT_XH    (0x29)
#define ACCEL_REG_OUT_YH    (0x2B)
#define ACCEL_REG_OUT_ZH    (0x2D)

#define LED_EN_PIN  (1 << 2)
#define BOOT_EN_PIN (1 << 3)

#define AO_STATE_SLEEP      0
#define AO_STATE_STARTUP    1
#define AO_STATE_SETUP      2
#define AO_STATE_TX         3
volatile int state = AO_STATE_SLEEP;

static void unsetup_uart();
static void i2c_unsetup();

#define CARRIER_COUNT           (SMCLK_FREQ/10000UL/2UL - 4UL) // 10 kHz
#define LOW_COUNT               (SMCLK_FREQ/6250UL/2UL - 4UL) // 6.25 kHz
#define HIGH_COUNT              (SMCLK_FREQ/14285UL/2UL - 4UL) // 14.285 kHz

volatile unsigned int led_count_next = 0;
volatile unsigned int setup = 0;
static void setup_timer() {
    // stop the timer
    TA0CTL &= ~MC;
    // set TA0CLR
    TA0CTL |= TACLR;
    // set up TA0CCR0
    TA0CCTL0 &= ~CAP;
    TA0CCR0 = SMCLK_FREQ/1000UL/8UL*2; // dunno why that *2 needs to be there
    // write to TA0IV, TA0DEX, and TA0CCTL0
    TA0EX0 = 0x03; // divide by 8
    TA0CCTL0 = CCIE; // enable interrupt
    // write to TA0CTL
    TA0CTL = TASSEL__SMCLK | ID__1 | MC__UP; // SMCLK, divide by 1, up mode, enable interrupts

    led_count_next = CARRIER_COUNT;
    TA1CTL &= ~MC;
    // set TA1CLR
    TA1CTL |= TACLR;
    // set up TA1CCR0
    TA1CCTL0 &= ~CAP;
    TA1CCR0 = led_count_next; // 10 kHz carrier frequency
    // write to TA1IV, TA1DEX, and TA1CCTL1
    TA1EX0 = 0x00; // divide by 1
    TA1CCTL0 = CCIE; // enable interrupt
    // write to TA1CTL
    TA1CTL = TASSEL__SMCLK | ID__1 | MC__UP; // SMCLK, divide by 1, up mode, enable interrupts
}

static void unsetup_timer() {
    TA0CTL &= ~MC;
    TA1CTL &= ~MC;
}

#if 0
volatile int test_last_high = 0;
#endif
volatile int tick_count = 0;
volatile int read_sensors = 0;

volatile unsigned char led_message[] = "xxyyzz?";
volatile int led_pos = 0;
volatile char led_tx_done = 1;
// values plus xor checksum at the end

// TODO Timer0 interrupt; used to set frequency the LED flashes at
#pragma vector=TIMER0_A0_VECTOR
__interrupt void timer_symbol_isr() {
    if (state == AO_STATE_STARTUP) {
        led_count_next = CARRIER_COUNT;
#if 0
        if (test_last_high) {
            led_count_next = LOW_COUNT;
        } else {
            led_count_next = HIGH_COUNT;
        }
        test_last_high = !test_last_high;
#endif
        ++tick_count;
        // wait 20 ticks (20 ms?) for the accelerometer and whatever to be set up
        if (tick_count > 20) {
            state = AO_STATE_SETUP;
            tick_count = 0;
        }
    } else if (state == AO_STATE_SETUP) {
        // wait for I2C to be setup and the state to transition to STATE_TX
        led_count_next = CARRIER_COUNT;
    } else if (state == AO_STATE_TX) {
        // set led_count_next based on the next bit to transmit
        if (!led_tx_done) {
            char cur_byte = led_message[led_pos >> 3];
            led_count_next = (cur_byte & (1 << (7-(led_pos & 7)))) ? HIGH_COUNT : LOW_COUNT;
            // transmitted MSB first
            ++led_pos;
            if (led_pos > 8*(sizeof(led_message)-1)) {
                led_tx_done = 1;
                led_pos = 0;
            }
        } else {
            led_count_next = CARRIER_COUNT;
        }

        ++tick_count;
        // start I2C communications stuff every 10 ms (TODO check to make sure it's actually every 10 ms)
        if (tick_count > 10) {
            read_sensors = 1;
            tick_count = 0;
        }
    }
}

// TODO test out Manchester encoding instead of FSK; would 5x bitrate

// Timer1 interrupt; used to flip the LED on and off
#pragma vector=TIMER1_A0_VECTOR
__interrupt void timer_flip_isr() {
    P2OUT ^= LED_EN_PIN;
    TA1CTL &= ~MC;
    TA1CCR0 = led_count_next; // 10 kHz carrier frequency
    TA1CTL |= MC__UP;
}

volatile int off_count = 0;
void btn_callback(tSensor* pSensor) {
    // switch to proximity maybe
    if (pSensor->bSensorTouch == true) {
        if (state == AO_STATE_SLEEP) {
            P2OUT &= ~LED_EN_PIN;
            P2OUT |= BOOT_EN_PIN;
            state = AO_STATE_STARTUP;
            tick_count = 0;
        }
        off_count = 0;
    } else {
        if (state != AO_STATE_SLEEP) {
            ++off_count;
            if (off_count > 200) {
                state = AO_STATE_SLEEP;
                P2OUT &= ~(BOOT_EN_PIN | LED_EN_PIN);

                unsetup_timer();
                unsetup_uart();
                i2c_unsetup();
                setup = 0;
            }
        }
    }
}

// NOTE maybe use driverlib implementation instead
static void setup_uart() {
    // reset UART
    UCA0CTL1 |= UCSWRST;
    // setup all registers
    // baud rate = 115200, clk = 2 MHz (SMCLK)
    // N = clk/baud rate = 17.361
    // OS16=1, UCBRx = 1, UCBRFx = 1, UCBRSx = 0x4A, about 2% error
    // NOTE switch to lower baud rate if this isn't reliable enough
    UCA0CTL0 = 0;     // no parity, LSB, 8 bit, 1 stop bit, UART, async
    UCA0CTL1 |= UCSSEL__SMCLK; // SMCLK clock source

    UCA0BRW = 1;
    UCA0MCTLW = (0x004A << 8) | UCBRF_1 | UCOS16;

    // configure ports
    P1SEL0 |= ((1 << 5) | (1 << 4));
    P1SEL1 &= ~((1 << 5) | (1 << 4));
    SYSCFG2 |= USCIBRMP;

    // clear UCSWRST
    UCA0CTL1 &= ~UCSWRST;

    // enable interrupts
    UCA0IE |= UCTXIE;
}

//volatile int uart_busy = 0;
static void unsetup_uart() {
    // disable interrupts
    UCA0IE &= ~UCTXIE;
    // reset UART
    UCA0CTL1 |= UCSWRST;
}

struct uart_msg {
    char* str;
    unsigned int len;
    struct uart_msg* next;
};

volatile struct uart_msg* uart_cur_msg = 0;
volatile unsigned int uart_pos = 0;

#pragma vector=EUSCI_A0_VECTOR
__interrupt void uart_isr() {
    switch(__even_in_range(UCA0IV, 18)) {
    case 0x00:
        // nothing
        break;
    case 0x02:
        // UCRXIFG; shouldn't happen?
        break;
    case 0x04:
        // set UCTXIFG in case we don't write it here
        UCA0IFG |= UCTXIFG;
        // UCTXIFG
        if (uart_cur_msg != 0) {
            UCA0TXBUF = uart_cur_msg->str[uart_pos];
            ++uart_pos;
            if (uart_pos >= uart_cur_msg->len) {
                uart_pos = 0;
                uart_cur_msg = uart_cur_msg->next;
            }
        } else {
            uart_pos = 0;
            //uart_busy = 0;
            UCA0IE &= ~UCTXIE;
        }
        break;
    default:
        // do nothing
        ;
    }
}

void tx_uart(struct uart_msg *msg) {
    __bic_SR_register(GIE);

    msg->next = 0;
    // NOTE: race condition with UART interrupt; cur_msg can be set to null
    // after this check
    if (!uart_cur_msg) {
        uart_cur_msg = msg;
        //uart_busy = 1;
        UCA0IE |= UCTXIE;
        __bis_SR_register(GIE);

        return;
    }
    struct uart_msg* m = (struct uart_msg*) uart_cur_msg;
    struct uart_msg* next = m->next;
    while (next) {
        m = next;
        next = m->next;
    }
    m->next = msg;
    //uart_busy = 1;
    UCA0IE |= UCTXIE;
    __bis_SR_register(GIE);

}


#define SEND_MSG(x) { \
    static struct uart_msg msg = {.str = x, .len = sizeof(x) - 1, .next = 0 }; \
    tx_uart(&msg); \
}

static void i2c_setup() {
    // set UCSWRST
    UCB0CTL1 |= UCSWRST;
    // TODO initialize registers
    UCB0CTL0 |= UCMST_H | UCMODE_3_H; // 7-bit own, 7-bit slave, non multi-master, I2C mode, UCSYNC=1
    UCB0CTL1 |= UCSSEL__SMCLK | UCTR__TX; // SMCLK clock select, transmitter mode, manual stop bit
    UCB0BRW = (SMCLK_FREQ/100000UL); // 100 kHz clock
    // TODO configure ports

    P2SEL0 &= ~((1 << 5) | (1 << 6));
    P2SEL1 |= (1 << 5) | (1 << 5);
    // P2SEL
}

static void i2c_unsetup() {
    UCB0CTL1 |= UCSWRST;
}

// TODO refactor the preambles of read/write into a separate function
static int i2c_write(unsigned char addr, unsigned char reg, unsigned char data) {
    UCB0CTL1 |= UCSWRST;

    // clear flags
    UCB0IFG = 0;

    // set the address and send the address byte
    UCB0I2CSA = addr;
    UCB0CTL1 &= ~UCSWRST;
    UCB0CTL1 |= UCTR__TX;
    UCB0CTL1 |= UCTXSTT;

    while (!(UCB0IFG & UCTXIFG));
    UCB0IFG = 0;
    // transmit the register address
    UCB0TXBUF = reg;

    // wait for the address to be transmitted
    while (UCB0CTL1 & UCTXSTT);

    if (UCB0IFG & UCNACKIFG) {
        UCB0CTL1 |= UCTXSTP;
        while (UCB0CTL1 & UCTXSTP);
        return -1;
    }

    // wait for it to be ready to transmit and the slave to acknowledge the register byte
    while (!(UCB0IFG & (UCTXIFG | UCNACKIFG)));

    if (UCB0IFG & UCNACKIFG) {
        UCB0CTL1 |= UCTXSTP;
        while (UCB0CTL1 & UCTXSTP);
        return -1;
    }

    UCB0TXBUF = data;
    while (!(UCB0IFG & UCTXIFG));
    UCB0CTL1 |= UCTXSTP;

    while (UCB0CTL1 & UCTXSTP);

    if (UCB0IFG & UCNACKIFG) {
        return -1;
    } else {
        return 0;
    }
}

static int i2c_read(unsigned char addr, unsigned char reg, unsigned char* data, int len) {
    UCB0CTL1 |= UCSWRST;
    // clear flags
    UCB0IFG = 0;

    // set the address and send the address byte
    UCB0I2CSA = addr;
    UCB0CTL1 &= ~UCSWRST;
    UCB0CTL1 |= UCTR__TX;
    UCB0CTL1 |= UCTXSTT;

    while (!(UCB0IFG & UCTXIFG));
    // transmit the register address
    UCB0TXBUF = reg;

    // wait for the address to be transmitted
    while (UCB0CTL1 & UCTXSTT);

    if (UCB0IFG & UCNACKIFG) {
        UCB0CTL1 |= UCTXSTP;
        while (UCB0CTL1 & UCTXSTP);
        return -1;
    }

    // wait for it to be ready to transmit and the slave to acknowledge the register byte
    while (!(UCB0IFG & (UCTXIFG | UCNACKIFG)));

    if (UCB0IFG & UCNACKIFG) {
        UCB0CTL1 |= UCTXSTP;
        while (UCB0CTL1 & UCTXSTP);
        return -1;
    }

    // switch to receiver mode and send a new start bit
    UCB0CTL1 &= ~UCTR__TX;
    UCB0CTL1 |= UCTXSTT;

    int i = 0;
    for (i = 0; i < len; i++) {
        while (!(UCB0IFG & (UCNACKIFG | UCRXIFG)));

        if (UCB0IFG & UCNACKIFG) {
            UCB0CTL1 |= UCTXSTP;
            while (UCB0CTL1 & UCTXSTP);
            return -2;
        }
        data[i] = UCB0RXBUF;
    }

    UCB0CTL1 |= UCTXSTP;
    while (UCB0CTL1 & UCTXSTP);

    return 0;
}

static void tohex(char c, char* out) {
    const char hex[] = "0123456789abcdef";
    out[0] = hex[(c >> 4) & 0x0f];
    out[1] = hex[c & 0x0f];
}
void main(void) {
	//
	// Initialize the MCU
	// BSP_configureMCU() sets up the device IO and clocking
	// The global interrupt enable is set to allow peripherals
	// to wake the MCU.
	//
	WDTCTL = WDTPW | WDTHOLD;
	BSP_configureMCU();

    P2OUT &= ~((1 << 2) | (1 << 3));
	P2DIR |= (1 << 2) | (1 << 3);
	//P2OUT |= (1 << 2);

	__bis_SR_register(GIE);

	//
	// Start the CapTIvate application
	//
	CAPT_appStart();
	MAP_CAPT_registerCallback(&BTN00, btn_callback);

    P1DIR &= ~(GPIO_PIN6 | GPIO_PIN7);
    P2DIR &= ~GPIO_PIN4;

    long int x_acc = 0, y_acc = 0, z_acc = 0;
    int acc_count = 0;

	/*
	while (1) {
        P2OUT ^= (1 << 2);
	}
	*/
	//
	// Background Loop
	//
	while(1) {
		//
		// Run the captivate application handler.
		//
		CAPT_appHandler();

		//
		// This is a great place to add in any 
		// background application code.
		//
		//__no_operation();
		switch (state) {
		case AO_STATE_SLEEP:
		    if (setup) {
                unsetup_timer();
		        unsetup_uart();
		        i2c_unsetup();

		        setup = 0;
		    }
	        //
	        // End of background loop iteration
	        // Go to sleep if there is nothing left to do
	        //
	        CAPT_appSleep();
		    break;
		case AO_STATE_STARTUP:
		    if (!setup) {
		        setup_uart();
		        i2c_setup();
                setup_timer();

		        setup = 1;
		    }
		    break;
		case AO_STATE_SETUP:
		    // TODO set up accelerometer/gyroscope
		    {
                SEND_MSG("setup\r\n");

		        /*
		        static struct uart_msg test_msg = {
		                                           .str = "test\r\n",
		                                           .len = sizeof("test\r\n") - 1,
		                                           .next = 0
		        };
		        tx_uart(&test_msg);
		        */
                int i = 0;
#if 0
                int j = 0;
                for (j = 0; j < 128; j++) {
                    uint8_t tmp;
                    if (i2c_read(j, 0x0F, &tmp, 1) >= 0) {
                        static char chip_enum[] = "chip at XX\r\n";
                        tohex(j, chip_enum + 8);
                        static struct uart_msg enum_msg = {
                                                              .str = chip_enum,
                                                              .len = sizeof(chip_enum) - 1,
                                                              .next = 0
                        };
                        tx_uart(&enum_msg);
                        for (i = 0; i < 20000; i++) {
                            asm volatile(" nop ");
                        }
                    }

                }
#endif

		        unsigned char whoami = 0;
		        if (i2c_read(GYRO_ADDR, GYRO_CHIP_ID, &whoami, 1) < 0) { // 0x00 = CHIP_ID
		            SEND_MSG("could not find gyro\r\n");
		            break;
		        }
		        if (whoami != GYRO_WHO_AM_I) {
		            SEND_MSG("gyro id failed\r\n");
		            break;
		        }
                SEND_MSG("gyro detected\r\n");
                if (i2c_write(GYRO_ADDR, GYRO_RANGE, 0x03) < 0) { // lower range to +- 250deg/s
                    SEND_MSG("gyro range write failed\r\n");
                    break;
                }
                if (i2c_write(GYRO_ADDR, GYRO_INT_OUT_CTRL, 0x08) < 0) { // enable INT1, active low
                    SEND_MSG("gyro interrupt0 write failed\r\n");
                    break;
                }
                if (i2c_write(GYRO_ADDR, GYRO_INT_MAP, 0x80) < 0) { // map data ready to INT1
                    SEND_MSG("gyro interrupt1 write failed\r\n");
                    break;
                }
                //int i = 0;
                for (i = 0; i < 20000; i++) {
                    asm volatile(" nop ");
                }
                if (i2c_write(GYRO_ADDR, GYRO_CMD, 0x15) < 0) { // power on the gyroscope
                    SEND_MSG("gyro power on write failed\r\n");
                    break;
                }
                SEND_MSG("gyro setup finished\r\n");

#if 0
                if (i2c_read(ACCEL_ADDR, ACCEL_CHIP_ID, &whoami, 1) < 0) {
                    SEND_MSG("accel read id failed\r\n");
                    break;
                }
                if (whoami != ACCEL_WHO_AM_I) {
                    SEND_MSG("accel chip id invalid\r\n");
                    break;
                }
                if (i2c_write(ACCEL_ADDR, ACCEL_CTRL_REG1, ACCEL_CTRL_REG1_ENABLEALL | ACCEL_CTRL_REG1_ODR100HZ) < 0) {
                    SEND_MSG("accel enable write failed\r\n");
                    break;
                }
                if (i2c_write(ACCEL_ADDR, ACCEL_CTRL_REG4, ACCEL_CTRL_REG4_2G) < 0) {
                    SEND_MSG("accel scale write failed\r\n");
                    break;
                }
                SEND_MSG("accel setup finished\r\n");
#endif

                for (i = 0; i < 30000; i++) {
                    asm volatile(" nop ");
                }
                state = AO_STATE_TX;
		    }
		    break;
		case AO_STATE_TX:
		    /*
		    if (read_sensors) {
		        // TODO read from accelerometer and gyroscope
		        read_sensors = 0;
		    }
		    */
		    // TODO do this based on a flag set in a pin interrupt instead of polling it
		    if (read_sensors) {
		    //if (read_sensors) {
		        //static int tick = 0;
		        read_sensors = 0;
		        unsigned char vals[6];
		        if (i2c_read(GYRO_ADDR, GYRO_DATA, vals, 6) < 0) {
		            SEND_MSG("gyro read failed\r\n");
		        } else {
		            int x = 0, y = 0, z = 0;
		            x = (((unsigned int)vals[1]) << 8) | vals[0];
		            y = (((unsigned int)vals[3]) << 8) | vals[2];
		            z = (((unsigned int)vals[5]) << 8) | vals[4];

		            x_acc += x;
		            y_acc += y;
		            z_acc += z;

		            ++acc_count;
		            if (acc_count >= 8) {
		                acc_count = 0;
		                int out_x = x_acc/8;
		                int out_y = y_acc/8;
		                int out_z = z_acc/8;
		                unsigned char sum = 0;
		                sum ^= out_x;
		                sum ^= out_x >> 8;
                        sum ^= out_y;
                        sum ^= out_y >> 8;
                        sum ^= out_z;
                        sum ^= out_z >> 8;
		                __bic_SR_register(GIE);
		                led_message[0] = out_x >> 8;
		                led_message[1] = out_x;
		                led_message[2] = out_y >> 8;
		                led_message[3] = out_y;
		                led_message[4] = out_z >> 8;
		                led_message[5] = out_z;
		                led_message[6] = sum;
		                led_tx_done = 0;
		                __bis_SR_register(GIE);
		                static struct uart_msg led_msg = {
		                                                  .str = led_message,
		                                                  .len = sizeof(led_message) - 1,
		                                                  .next = 0
		                };
	                    tx_uart(&led_msg);
	                    x_acc = 0;
	                    y_acc = 0;
	                    z_acc = 0;
		            }
		            //++tick;
		            //if (tick < 10) break;
		            //tick = 0;
		            static char gyro_msg[] = "xxxx xxxx xxxx\r\n";
		            tohex(vals[1], gyro_msg + 0);
		            tohex(vals[0], gyro_msg + 2);
		            tohex(vals[3], gyro_msg + 5);
		            tohex(vals[2], gyro_msg + 7);
		            tohex(vals[5], gyro_msg + 10);
		            tohex(vals[4], gyro_msg + 12);
		            /*
		            static struct uart_msg gyro_uart_msg = {
		                                                    .str = gyro_msg,
		                                                    .len = sizeof(gyro_msg) - 1,
		                                                    .next = 0
		            };
		            */
		            //tx_uart(&gyro_uart_msg);
		        }
		    }
		    break;
		}
	} // End background loop
} // End main()
