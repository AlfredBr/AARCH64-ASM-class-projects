CC = gcc
CFLAGS = -Wall -Wextra -O2 -g
TARGET = sort

all: $(TARGET)

$(TARGET): $(TARGET).c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f $(TARGET) a.out *.o *.disasm

run: $(TARGET)
	./$(TARGET)

debug: $(TARGET)
	gdb -tui -q ./$(TARGET)

disasm:
	objdump -d $(TARGET) > $(TARGET).disasm