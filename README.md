# AARCH64-ASM-class-projects
### Six one hour lessons on the basics of ARM Assembly on the Raspberry Pi (appropriate for high-school students).
---

### Hour 0 - Return values
#### First we start with a very simple C program...
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
> |Topics Covered|
> |---|
> |Entry Points, Registers, Syscalls, Assembly Syntax, File Sections, Directives, Return values, Data Types|

### Hour 1 - Hello, World!
> In `Hour 1` we write Hello, World! in ARM Assembly and introduce loops and function calls.  (Note: we print "Hello, World!" one character at at time.)
> |Topics Covered|
> |---|
> |Loops, Functions, Strings, ASCII, Registers, Branching, Conditionals, Stack, Pointers, Memory, Data Types|
### Hour 2 - ABCDEFGHIJKLMNOPQRZTUVWXYZ
> In `Hour 2` we write a program that prints the alphabet in ARM Assembly.  We also introduce ASCII encoding and the concepts of branching and conditionals.
> |Topics Covered|
> |---|
> |Branching, Conditionals, Loops, Strings, ASCII, Data Types|
### Hour 3 - 0 -> 99
> In `Hour 3` we write a program that prints the numbers 0 to 99 in ARM Assembly.  Here we discuss the difference between the value of a number and the printed representation of a number.
### Hour 4 - FizzBuzz
> In `Hour 4` we write a program that implements the famous FizzBuzz algorithm from 1 to 100.  This lesson is a bit more challenging than the previous lessons, but it is a great way to learn about branching and conditionals.
### Bonus 5 - Sorting
> In the bonus hour we write a program that sorts and prints an array of integers in ARM Assembly.

# Useful Links
- [ARM Assembly Language Reference](https://developer.arm.com/documentation/100076/0100)
- [LINUX SysCall info](https://arm64.syscall.sh/)
- [ASCII Table](https://www.asciitable.com/)
- [GDB TUI Documentation](https://sourceware.org/gdb/current/onlinedocs/gdb.html/TUI-Commands.html)
