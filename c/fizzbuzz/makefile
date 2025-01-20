CC = gcc
CFLAGS = -Wall -Wextra -O2 -g
TARGET = fizzbuzz

all: $(TARGET)

run: $(TARGET)
	./$(TARGET)

$(TARGET): $(TARGET).c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f $(TARGET) a.out *.o *.disasm

disasm:
	objdump -d $(TARGET) > $(TARGET).disasm