TARGET = stm7-zig-hello

BUILD_DIR = build

CPU = -mcpu=cortex_m7
FPU = -mfpu=fpv5-d16
FLOAT-ABI = -mfloat-abi=hard

MCU = -target arm-freestanding-eabi $(CPU) -mthumb $(FPU) $(FLOAT-ABI)
#-ffreestanding

OPT = -Og
AS_INCLUDES =
AS_DEFS =
ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall

CC = zig c++

OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

all: $(BUILD_DIR)/$(TARGET).elf

test: $(BUILD_DIR)/startup_stm32f767xx.o

$(BUILD_DIR)/%.o: %.s | $(BUILD_DIR)
	$(CC) -c $(ASFLAGS) -Wa -o $@ $< #,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

startup:
	$(CC) -c $(ASFLAGS) -Wa -o startup_stm32f767xx.o src/startup_stm32f767xx.s #,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

clean:
	rm -fR *.o

$(BUILD_DIR):
	mkdir $@

PHONY: test startup
