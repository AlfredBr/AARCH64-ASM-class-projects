ASM = as
LD = ld
TARGET = afizzbuzz

all: $(TARGET)

run: $(TARGET)
	./$(TARGET)

%.o : %.s
	$(ASM) -g -o $@ $<

$(TARGET): $(TARGET).o
	$(LD) -g -o $@ $<

clean:
	rm -f $(TARGET) a.out *.o *.disasm

disasm:
	objdump -d $(TARGET) > $(TARGET).disasm