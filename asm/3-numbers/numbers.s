.global _start                        // Define the entry point
.align 2                              // Align to 8-byte boundary

.section .text                        // Text section for code
.include "macros.s"                   // Include the macros file

_start:
    ldr x1, =msg                      // Load the address of msg into x1
    bl print_string                   // Call print_string
init:
    mov x20, #0                       // Initialize x20 to 0
counter:
    mov x0, x20                       // Load the integer x20 into x0
    ldr x1, =buffer                   // Load the address of buffer into x1
    bl itoa                           // Convert the integer to ASCII
    bl print_string                   // Call print_string
    add x20, x20, #1                  // Increment x20
    cmp x20, #100                     // Compare x20 with #100
    b.lt counter                      // If x20 < 100, continue the loop
_exit:
    mov x0, #0                        // Set x0 to 0 (successful exit status)
    mov x8, #93                       // Set x8 to 93 (sys_exit syscall number)
    svc 0                             // Make the syscall

// Function to convert an integer to an ASCII string
// x0 = integer to convert
// x1 = address of the buffer to store the ASCII string
itoa:
    prologue
    mov  x10, x0                     // Copy the number from x0 to x10
    mov  x11, x1                     // Copy the buffer address from x1 to x11
    mov  x3, #0                      // Initialize digit count
    mov  x6, #10                     // Load #10 into x6
itoa_loop:
    udiv x4, x10, x6                 // Divide x10 by #10, store quotient in x4
    mul  x5, x4, x6                  // Multiply quotient by #10, store in x5
    sub  x5, x10, x5                 // Subtract the product from x10, store remainder in x5
    and  x5, x5, #0xff               // Clear upper bits
    add  x5, x5, #48                 // Convert remainder to ASCII ('0' + remainder)
    strb w5, [x1]                    // Store the ASCII character in the buffer pointed to by x1
    add  x1, x1, #1                  // Increment the buffer pointer
    add  x3, x3, #1                  // Increment digit count
    mov  x10, x4                     // Update x10 with the quotient
    cbnz x10, itoa_loop              // Continue if quotient is not zero
reverse:
    mov x12, x11                     // Start pointer
    add x13, x11, x3                 // End pointer
    sub x13, x13, #1                 // Adjust end pointer to the last byte
reverse_loop:
    cmp x12, x13                     // Compare start and end pointers
    b.ge reverse_done                // If start >= end, we're done
    ldrb w14, [x12]                  // Load byte from start pointer
    ldrb w15, [x13]                  // Load byte from end pointer
    strb w15, [x12]                  // Store byte from end to start
    strb w14, [x13]                  // Store byte from start to end
    add x12, x12, #1                 // Move start pointer forward
    sub x13, x13, #1                 // Move end pointer backward
    b reverse_loop                   // Repeat the loop
reverse_done:
    mov  x5, NEWLINE                 // Load newline character
    strb w5, [x1]                    // Store the newline
    add  x1, x1, #1                  // Increment the buffer pointer
    mov  x5, NULL_TERMINATOR         // Null terminator
    strb w5, [x1]                    // Store the null terminator
    mov  x1, x11                     // Restore the buffer address from x11 to x1
    epilogue
    ret

print_string:
    prologue
    mov x0, #1                        // Set x0 to 1 (file descriptor for stdout)
    bl strlen                         // Call strlen to get the length of string pointed to by x1
    nop                               // strlen side-effect => length stored in x2
    mov x8, #64                       // Set x8 to 64 (sys_write syscall number)
    svc 0                             // Make the syscall
    epilogue
    ret

strlen:
    prologue
    mov x6, #0                        // Initialize x6 to 0
strlen_loop:
    ldrb w4, [x1, x6]                 // Load the byte at the address x1 + x6 into w4
    cmp w4, #0                        // Compare the byte in w4 with 0x0 null terminator
    beq strlen_done                   // If null detected, branch to strlen_done
    add x6, x6, #1                    // Otherwise, increment length in x6
    b strlen_loop                     // We're not done, go back to top of loop
strlen_done:
    mov x2, x6                        // Move the length from x6 to x2
    epilogue
    ret

_end:

.section .data                        // Data section for storing constants
    msg:    .ascii "Numbers\n"        // Define the message string
            .byte 0                   // Null terminator

.section .bss
    .align 3                          // Align to 8-byte boundary
    buffer: .skip 32                  // Reserve space for the buffer
