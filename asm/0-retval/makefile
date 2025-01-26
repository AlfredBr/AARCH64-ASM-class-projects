ASM = as
LD = ld
TARGET = retval

all: $(TARGET)

%.o : %.s
	$(ASM) -g -o $@ $<

$(TARGET): $(TARGET).o
	$(LD) -g -o $@ $<

clean:
	rm -f $(TARGET) a.out *.o *.disasm

run: $(TARGET)
	./$(TARGET)

debug: $(TARGET)
	gdb -tui -q ./$(TARGET)

disasm:
	objdump -d $(TARGET) > $(TARGET).disasm