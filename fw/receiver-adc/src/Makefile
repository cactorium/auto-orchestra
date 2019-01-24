DEVICE = stm32f070f6p6
OPENCM3_DIR = ../libopencm3
OBJS += main.o

CPPFLAGS += -Os -Wall -Werror
LDFLAGS         += -static -nostartfiles
LDLIBS          += -Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group -Wl,--gc-sections

include $(OPENCM3_DIR)/mk/genlink-config.mk
include $(OPENCM3_DIR)/mk/gcc-config.mk

.PHONY: clean all

all: receiver.elf receiver.hex

clean:
	$(Q)$(RM) -rf receiver.* *.o

flash: sensor.hex
	openocd -f ../receiver.cfg "-c init; reset; halt; program receiver.hex verify; reset; resume; exit"

include $(OPENCM3_DIR)/mk/genlink-rules.mk
include $(OPENCM3_DIR)/mk/gcc-rules.mk
