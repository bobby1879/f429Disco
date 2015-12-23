TARGET=test.hex
EXECUTABLE=test.elf

PWD := $(shell pwd)

SOURCEDIR = $(PWD)

LOCATION := ~/gcc-arm-none-eabi-4_9-2015q3/bin

CC=$(LOCATION)/arm-none-eabi-gcc
#LD=arm-none-eabi-ld 
LD=$(LOCATION)/arm-none-eabi-gcc
AR=$(LOCATION)/arm-none-eabi-ar
AS=$(LOCATION)/arm-none-eabi-as
CP=$(LOCATION)/arm-none-eabi-objcopy
OD=$(LOCATION)/arm-none-eabi-objdump

BIN=$(CP) -O ihex

DEFS = -DUSE_STDPERIPH_DRIVER -DSTM32F429_439xx
#-DSTM32F410xx

MCU = cortex-m4
MCFLAGS = -mcpu=$(MCU) -mthumb -mlittle-endian -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb-interwork  
#-mfpu=fpa -mfloat-abi=hard -mthumb-interwork  

STM32_INCLUDES = -I $(PWD)/Libraries/Peripherals/Includes \
	-I $(PWD)/Libraries/Cpu/Includes \
	-I $(PWD)/Libraries/Cmsis/Includes \
	-I $(PWD)

#STM32_INCLUDES = -I $(PWD)/Libraries/stdInc \
#	-I $(PWD)/Libraries/cmsisInc \
#	-I$(PWD)

OPTIMIZE       = -Os

CFLAGS	= --specs=nosys.specs -g $(MCFLAGS)  $(OPTIMIZE)  $(DEFS) -I./ -I./ $(STM32_INCLUDES)  -Wl,-T,STM32F429ZI_FLASH.ld 
AFLAGS	= $(MCFLAGS) 

SRC := $(shell find $(SOURCEDIR) -name '*.c')

STARTUP = startup_stm32f4xx.S

OBJDIR = .
OBJ = $(SRC:%.c=$(OBJDIR)/%.o) 
OBJ += Startup.o



all: $(TARGET)

$(TARGET): $(EXECUTABLE)
	$(CP) -O ihex $^ $@
	$(OD) -D $(EXECUTABLE) > listing.lst

$(EXECUTABLE): $(SRC) $(STARTUP)
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -f Startup.lst  $(TARGET)  $(EXECUTABLE) *.lst $(OBJ) $(AUTOGEN)  *.out *.map \
	 *.dmp
