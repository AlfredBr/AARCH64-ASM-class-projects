.global _start                        // Define the entry point
.align 2                              // Align to 8-byte boundary

.section .text                        // Text section for code
.include "macros.s"                   // Include the macros file

_start:
	bl test_print_string
	bl test_print_char
	bl test_print_int
	b _exit						      // Branch to exit

    ldr x0, =array                    // Load the address of the array into x0
    mov x1, #10                       // Load the size of the array into x1
    bl sort                           // Call the sort function
    bl print_array                    // Call the print_array function
	b _exit                           // Branch to exit

test_print_string:
	prologue
	ldr x1, =hello
	bl print_string
	epilogue
	ret

test_print_char:
	prologue
	mov x0, #65
	bl print_char
	mov x0, #10
	bl print_char
	epilogue
	ret

test_print_int:
	prologue
	mov x0, #1
	bl print_int
	mov x0, #10
	bl print_char
	epilogue
	ret

_exit:
    mov x0, #0                        // Set x0 to 0 (successful exit status)
    mov x8, #93                       // Set x8 to 93 (sys_exit syscall number)
    svc 0                             // Make the syscall

// Function to sort the array
// x0 = address of the array
// x1 = size of the array
sort:
    prologue
    mov x2, #0                        // Initialize i to 0
sort_outer_loop:
    cmp x2, x1                        // Compare i with size
    b.ge sort_done                    // If i >= size, we're done
    add x3, x2, #1                    // Initialize j to i + 1
sort_inner_loop:
    cmp x3, x1                        // Compare j with size
    b.ge sort_outer_next              // If j >= size, go to next iteration of outer loop
    ldr w4, [x0, x2, lsl #2]          // Load a[i] into w4
    ldr w5, [x0, x3, lsl #2]          // Load a[j] into w5
    cmp w4, w5                        // Compare a[i] with a[j]
    b.le sort_inner_next              // If a[i] <= a[j], go to next iteration of inner loop
    mov x6, x0                        // Move the address of the array to x6
    add x6, x6, x2, lsl #2            // Calculate the address of a[i]
    add x7, x0, x3, lsl #2            // Calculate the address of a[j]
    bl swap                           // Call the swap function
sort_inner_next:
    add x3, x3, #1                    // Increment j
    b sort_inner_loop                 // Repeat the inner loop
sort_outer_next:
    add x2, x2, #1                    // Increment i
    b sort_outer_loop                 // Repeat the outer loop
sort_done:
    epilogue
    ret

// Function to swap two integers
// x0 = address of the first integer
// x1 = address of the second integer
swap:
    prologue
    ldr w2, [x0]                      // Load the first integer into w2
    ldr w3, [x1]                      // Load the second integer into w3
    str w3, [x0]                      // Store the second integer at the address of the first integer
    str w2, [x1]                      // Store the first integer at the address of the second integer
    epilogue
    ret

// Function to print the array
// x0 = address of the array
print_array:
    prologue
    mov x1, #0                        // Initialize index to 0
print_loop:
    cmp x1, #10                       // Compare index with size
    b.ge print_done                   // If index >= size, we're done
    ldr w2, [x0, x1, lsl #2]          // Load the array element into w2
    bl print_int                      // Call the print_int function
    mov w2, NEWLINE                   // Load newline character
    bl print_char                     // Call the print_char function
    add x1, x1, #1                    // Increment index
    b print_loop                      // Repeat the loop
print_done:
    epilogue
    ret

// Function to print a character
// x0 = character to print
print_char:
    prologue
    strb w0, [sp, #-1]!               // Store the character on the stack
    mov x1, sp                        // Set x1 to the address of the character
    mov x2, #1                        // Set x2 to the length of the string (1)
    mov x8, #64                       // Set x8 to 64 (sys_write syscall number)
    mov x0, #1                        // Set x0 to 1 (file descriptor for stdout)
    svc 0                             // Make the syscall
    add sp, sp, #1                    // Deallocate space on stack
    epilogue
    ret

// Function to print an integer
// x0 = integer to print
print_int:
    prologue
    mov x1, sp                        // Use stack as buffer / save sp in x1
    sub sp, sp, #16                   // Allocate space on stack
    bl itoa                           // Convert integer to ASCII
    mov x1, sp                        // Restore buffer address
    bl print_string                   // Print the string
    add sp, sp, #16                   // Deallocate space on stack
    epilogue
    ret

// Function to convert an integer to an ASCII string
// x0 = integer to convert
// x1 = address of the buffer to store the ASCII string
itoa:
    prologue
    mov  x10, x0                      // Copy the number from x0 to x10
    mov  x11, x1                      // Copy the buffer address from x1 to x11
    mov  x2, #0                       // Initialize digit count
    mov  x3, #10                      // Load #10 into x3
itoa_loop:
    udiv x4, x10, x3                  // Divide x10 by #10, store quotient in x4
    mul  x5, x4, x3                   // Multiply quotient by #10, store in x5
    sub  x5, x10, x5                  // Subtract the product from x10, store remainder in x5
    and  x5, x5, #0xff                // Clear upper bits
    add  x5, x5, ASCII_0              // Convert remainder to ASCII ('0' + remainder)
    strb w5, [x1]                     // Store the ASCII character in the buffer pointed to by x1
    add  x1, x1, #1                   // Increment the buffer pointer
    add  x2, x2, #1                   // Increment digit count
    mov  x10, x4                      // Update x10 with the quotient
    cbnz x10, itoa_loop               // Continue if quotient is not zero
reverse:
    mov  x1, x11                      // Start pointer
    add  x2, x11, x2                  // End pointer
    //sub  x2, x2, #1                   // Adjust end pointer to the last byte
reverse_loop:
    cmp  x1, x2                       // Compare start(x1) and end(x2) pointers
    b.ge reverse_done                 // If start >= end, we're done
    ldrb w6, [x1]                     // Load byte from start pointer
    ldrb w7, [x2]                     // Load byte from end pointer
    strb w7, [x1]                     // Store byte from end to start
    strb w6, [x2]                     // Store byte from start to end
    add  x1, x1, #1                   // Move start pointer forward
    sub  x2, x2, #1                   // Move end pointer backward
    b    reverse_loop                 // Repeat the loop
reverse_done:
    mov  x5, NULL_TERMINATOR          // Null terminator
    strb w5, [x1]                     // Store the null terminator
    epilogue
    ret

// Function to print a string
// x1 = address of the string
print_string:
    prologue
    bl   strlen                       // Call strlen to get the length of string pointed to by x1
    mov  x2, x0                       // Copy x0 (the return value from strlen) length to x2
    mov  x0, #1                       // Set x0 to 1 (file descriptor for stdout)
    mov  x8, #64                      // Set x8 to 64 (sys_write syscall number)
    svc  0                            // Make the syscall
    epilogue
    ret

strlen:                               // strlen assumes x1 points to the string
    prologue
    mov  x0, #0                       // Initialize length counter to 0
strlen_loop:                          // Loop to calculate the length of the string
    ldrb w2, [x1, x0]                 // Load the byte at the address x1 + x0 into w2
    cmp  w2, NULL_TERMINATOR          // Compare the byte in w2 with 0x0 null terminator
    beq  strlen_done                  // If null detected, we know length, branch to strlen_done
    add  x0, x0, #1                   // Otherwise, increment length in x0
    b    strlen_loop                  // We're not done, go back to top of loop
strlen_done:
    epilogue
    ret                               // Return with length in x0

clear_buffer:
	prologue

	epilogue
	ret

_end:

.section .data                        // Data section for storing constants
	hello: .asciz "Hello, World!\n"  // Define a null-terminated string
    array: .word 5, 4, 3, 2, 1, 9, 8, 7, 6, 0  // Define the array
.section .bss
    .align 3                          // Align to 8-byte boundary
    buffer: .skip 16                 // Reserve space for the buffer
