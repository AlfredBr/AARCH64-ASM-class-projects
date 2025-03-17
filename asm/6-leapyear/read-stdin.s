.global _start          // Define the entry point
.align 2                // Align to 8-byte boundary

.section .text          // Text section for code
.include "macros.s"     // Include the macros file

_start:
    // demonstration - read from stdin and write to stdout
    mov x0, #0          // file descriptor 0 (stdin)
    mov x8, #63         // syscall number 63 (read)
    ldr x1, =buffer     // buffer
    mov x2, #100        // max bytes to read
    svc #0              // syscall

    mov x0, #1          // file descriptor 1 (stdout)
    mov x8, #64         // syscall number 64 (write)
    ldr x1, =buffer     // buffer
    mov x2, #100        // max bytes to write
    svc #0              // syscall

    mov x0, #0          // exit status
    mov x8, #93         // syscall number 93 (exit)
    svc #0              // syscall

.section .bss
buffer: .skip 32
