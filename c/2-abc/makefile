CC = gcc
CFLAGS = -Wall -Wextra -O2 -g
TARGET = abc

$(TARGET): $(TARGET).c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f $(TARGET) a.out

run: $(TARGET)
	./$(TARGET)

debug: $(TARGET)
	gdb -tui -q ./$(TARGET)