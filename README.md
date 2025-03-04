# AARCH64-ASM-class-projects
### Five one hour lessons on the basics of ARM Assembly on the Raspberry Pi (appropriate for high-school students)

### Hour 0 - Return values
#### First we start with a C program
``` C
int main()
{
   return 42;
}
```
#### And we turn that into an ARM Assembly program
``` asm
.section .text                        // Text section for code
.global _start                        // Define the entry point

_start:
   mov x0, #42                       // Set x0 to 42
   mov x8, #93                       // Set x8 to 93 (sys_exit syscall number)
   svc 0                             // Make the syscall
```
#### After we get the programming environment set up and discuss some theory, that's it for the first hour.

### Hour 1 - Hello, World!
### Hour 2 - ABCDEFGHIJKLMNOPQRZTUVWXYZ
### Hour 3 - 0 -> 99
### Hour 4 - FizzBuzz
### Bonus - Sorting
