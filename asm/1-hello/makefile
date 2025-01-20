CC = gcc
CFLAGS = -Wall -Wextra -O2
ASM = as
LD = ld

TARGET = hello

all: $(TARGET)

%.o : %.s
	$(ASM) -g -o $@ $<

hello: hello.o
	$(LD) -g -o hello hello.o

clean:
	rm -f $(TARGET) a.out *.o *.disasm hello

disasm:
	objdump -d $(TARGET) > $(TARGET).disasm