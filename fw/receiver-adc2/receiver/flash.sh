#!/bin/sh

arm-none-eabi-objcopy -Oihex build/receiver.elf build/receiver.hex
openocd -f receiver.cfg "-c init; reset; halt; program build/receiver.hex verify; reset; resume; exit"
