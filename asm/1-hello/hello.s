.section .text                        // Text section for code
.global _start                        // Define the entry point
.include "macros.s"                   // Include the macros file

_start:
    ldr x1, =msg                     // Load the address of msg into x1
    bl print_string                  // Call print_string
_exit:
    mov x0, #0                       // Set x0 to 0 (successful exit status)
    mov x8, #93                      // Set x8 to 93 (sys_exit syscall number)
    svc 0                            // Make the syscall

// Function: print_string
// Expects in x1 a pointer to a null-terminated string.
// Uses strlen to determine the length, then calls sys_write.
// Returns via sys_write; no function return value needed.
print_string:
    prologue
    mov x3, x1                       // Preserve the pointer in x1 by saving it in x3
    bl strlen                        // Call strlen; returns string length in x0
    mov x2, x0                       // Move the length into x2 (for sys_write)
    mov x0, #1                       // Set x0 to 1 (file descriptor for stdout)
    mov x1, x3                       // Restore the string pointer into x1
    mov x8, #64                      // Set x8 to 64 (sys_write syscall number)
    svc 0                            // Make the syscall to write the string
    epilogue
    ret                              // Return from function

// Function: strlen
// Expects in x1 a pointer to a null-terminated string.
// Returns the length of the string in x0.
strlen:
    prologue
    mov x6, #0                       // Initialize counter to 0
strlen_loop:
    ldrb w4, [x1, x6]                // Load byte from [x1 + x6] into w4
    cmp w4, #0                       // Compare byte with null terminator
    beq strlen_end                   // If null, branch to strlen_end
    add x6, x6, #1                   // Increment the counter
    b strlen_loop                    // Repeat the loop
strlen_end:
    mov x0, x6                       // Move the length (counter) into x0 (return value)
    epilogue
    ret                              // Return from function

_end:

.section .data                        // Data section for storing constants
    msg:    .ascii "Hello, World!\n" // Define the message string
            .byte 0                  // Null terminator
