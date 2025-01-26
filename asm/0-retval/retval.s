.section .text                        // Text section for code
.global _start                        // Define the entry point

_start:
    mov x0, #42                       // Set x0 to 42
    mov x8, #93                       // Set x8 to 93 (sys_exit syscall number)
    svc 0                             // Make the syscall
