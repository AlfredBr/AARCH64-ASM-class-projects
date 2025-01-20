CC = gcc
CFLAGS = -Wall -Wextra -O2
ASM = as
LD = ld

TARGET = afizzbuzz

all: $(TARGET)

run: $(TARGET)
	./$(TARGET)

%.o : %.s
	$(ASM) -g -o $@ $<

cfizzbuzz: fizzbuzz.c
	$(CC) $(CFLAGS) -o cfizzbuzz fizzbuzz.c

afizzbuzz: fizzbuzz.o
	$(LD) -g -o afizzbuzz fizzbuzz.o

clean:
	rm -f $(TARGET) a.out *.o *.disasm afizzbuzz cfizzbuzz

disasm:
	objdump -d $(TARGET) > $(TARGET).disasm