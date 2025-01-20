CC = gcc
CFLAGS = -Wall -Wextra -O2
ASM = as
LD = ld

TARGET = numbers

all: $(TARGET)

%.o : %.s
	$(ASM) -g -o $@ $<

$(TARGET): $(TARGET).o
	$(LD) -g -o $@ $<

clean:
	rm -f $(TARGET) a.out *.o *.disasm

disasm:
	objdump -d $(TARGET) > $(TARGET).disasm