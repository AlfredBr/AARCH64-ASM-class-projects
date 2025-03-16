ASM = as
LD = ld
TARGET = leapyear
CC = gcc

all: $(TARGET)

%.o : %.s
	$(ASM) -g -o $@ $<

$(TARGET): $(TARGET).o
	$(CC) -nostartfiles -g -o $@ $<

clean:
	@rm -f $(TARGET) a.out *.o *.disasm

run: $(TARGET)
	./$(TARGET)

debug: $(TARGET)
	gdb -tui -q ./$(TARGET)

disasm:
	objdump -d $(TARGET) > $(TARGET).disasm