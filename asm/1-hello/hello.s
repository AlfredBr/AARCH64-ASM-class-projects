.section .text                        // Text section for code
.global _start                        // Define the entry point

// Define the prologue macro
.macro prologue
    stp x29, x30, [sp, #-16]!    // Save x29 and x30 on the stack
    mov x29, sp                  // Set frame pointer
.endm

// Define the epilogue macro
.macro epilogue
    ldp x29, x30, [sp], #16      // Restore x29 and x30
.endm

_start:
    ldr x1, =msg                      // Load the address of msg into x1
    bl print_string                   // Call print_string

_exit:
    mov x0, #0                        // Set x0 to 0 (successful exit status)
    mov x8, #93                       // Set x8 to 93 (sys_exit syscall number)
    svc 0                             // Make the syscall

print_string:
    prologue
    mov x29, sp
    bl strlen                         // Call strlen to get the length of string pointed to by x1
                                      // strlen side-effect => length stored in x2
    mov x0, #1                        // Set x0 to 1 (file descriptor for stdout)
    mov x8, #64                       // Set x8 to 64 (sys_write syscall number)
    svc 0                             // Make the syscall
    epilogue
    ret                               // Return from function

strlen:
    prologue
    mov x29, sp
    mov x6, #0                        // Initialize x6 to 0
strlen_loop:
    ldrb w4, [x1, x6]                 // Load the byte at the address x1 + x6 into w4
    cmp w4, #0                        // Compare the byte in w4 with 0x0 null terminator
    beq strlen_end                    // If null detected, branch to strlen_end
    add x6, x6, #1                    // Otherwise, increment length in x6
    b strlen_loop                     // we're not done, go back to top of loop
strlen_end:
    mov x2, x6                        // Move the length from x6 to x2
    epilogue
    ret                               // Return from function

_end:

.section .data                        // Data section for storing constants
    msg:    .ascii "Hello, World!\n"  // Define the message string
            .byte 0                   // Null terminator
