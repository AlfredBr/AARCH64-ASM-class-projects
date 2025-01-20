CC = gcc
CFLAGS = -Wall -Wextra -g
TARGET = fizzbuzz

all: $(TARGET)

run: $(TARGET)
	./$(TARGET)

$(TARGET): $(TARGET).c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f $(TARGET) a.out *.o *.disasm fizzbuzz

disasm:
	objdump -d $(TARGET) > $(TARGET).disasm