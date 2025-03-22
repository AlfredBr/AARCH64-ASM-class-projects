.global _start                        // Define the entry point
.align 2                              // Align to 8-byte boundary

.section .text                        // Text section for code
.include "macros.s"                   // Include the macros file

_start:
    // (a) print the original array1 of single digit integers
    mov   x0, 'a'                     // Load the character 'a' into x1
    bl    print_char                  // Call the print_char function
    mov   x0, SPACE                   // Load the SPACE character into x0
    bl    print_char                  // Call the print_char function
    ldr   x0, =array1                 // Load the address of the array into x0
    mov   x1, #10                     // Load the size of the array into x1
    bl    print_array                 // Call the print_array function
    // (b) copy from array1 into buffer and print the buffer
    mov   x0, 'b'                     // Load the character 'a' into x1
    bl    print_char                  // Call the print_char function
    mov   x0, SPACE                   // Load the SPACE character into x0
    bl    print_char                  // Call the print_char function
    ldr   x0, =array1                 // Load the address of the array into x0
    ldr   x1, =buffer                 // Load the address of the buffer into x1
    mov   x2, #10                     // Load the size of the array into x2
    bl    copy_array                  // Call the copy_array function
    ldr   x0, =buffer                 // Load the address of the buffer into x0
    mov   x1, #10                     // Load the size of the array into x1
    bl    print_array                 // Call the print_array function
    // (c) print the original array2 of multi digit integers
    mov   x0, 'c'                     // Load the character 'a' into x1
    bl    print_char                  // Call the print_char function
    mov   x0, SPACE                   // Load the SPACE character into x0
    bl    print_char                  // Call the print_char function
    ldr   x0, =array2                 // Load the address of the array into x0
    mov   x1, #6                      // Load the size of the array into x1
    bl    print_array                 // Call the print_array function
    // (d) copy from array2 into buffer and print the buffer
    mov   x0, 'd'                     // Load the character 'a' into x1
    bl    print_char                  // Call the print_char function
    mov   x0, SPACE                   // Load the SPACE character into x0
    bl    print_char                  // Call the print_char function
    ldr   x0, =array2                 // Load the address of the array into x0
    ldr   x1, =buffer                 // Load the address of the buffer into x1
    mov   x2, #6                      // Load the size of the array into x2
    bl    copy_array                  // Call the copy_array function
    ldr   x0, =buffer                 // Load the address of the buffer into x0
    mov   x1, #6                      // Load the size of the array into x1
    bl    print_array                 // Call the print_array function
    // sort the single digit integers - copy from array1 into buffer
    ldr   x0, =array1                 // Load the address of the array into x0
    ldr   x1, =buffer                 // Load the address of the buffer into x1
    mov   x2, #10                     // Load the size of the array into x2
    bl    copy_array                  // Call the copy_array function
    ldr   x0, =buffer                 // Load the address of the buffer into x0
    mov   x1, #10                     // Load the size of the array into x1
    b exit
sort:
    bl    sort_array                  // Call the sort_array function
    ldr   x0, =buffer                 // Load the address of the buffer into x0
    mov   x1, #10                     // Load the size of the array into x1
    bl    print_array                 // Call the print_array function
    b     exit

    ldr   x0, =array2                 // Load the address of the array into x0
    mov   x1, #6                      // Load the size of the array into x1
    bl    print_array                 // Call the print_array function
    ldr   x0, =array2                 // Load the address of the array into x0
    ldr   x1, =buffer                 // Load the address of the buffer into x1
    mov   x2, #6                      // Load the size of the array into x2
    bl    copy_array
    ldr   x0, =buffer
    mov   x1, #6
    bl    print_array                 // Call the print_array function

    b     exit

    ldr   x0, =array2                 // Load the address of the array into x0
    mov   x1, #6                      // Load the size of the array into x1
    bl    sort_array                  // Call the sort function
    bl    print_array                 // Call the print_array function

    //bl  sort_array                  // Call the sort function
    bl    print_array                 // Call the print_array function
    epilogue
    ret

exit:
    mov     x0, #0                    // Set x0 to 0 (exit status)
    mov     x8, #93                   // Syscall: exit (93)
    svc     0                         // Make the syscall

// Function to sort the array
//   x0 = address of the array
//   x1 = size of the array
sort_array:
    prologue
    mov   x26, #0                     // Initialize loop index i to 0
    mov   x27, #4
sort_outer_loop:
    cmp   x1, #0                      // If i >= size, sorting is done
    beq   sort_done
    ldr   w2, [x0, x26]               // Load array[i] into x2
    ldr   w3, [x0, x27]               // Load array[i+1] into x3
    cmp   w2, w3                      // Compare array[i] and array[i+1]
    b.le  sort_no_swap                // If array[i] <= array[i+1], no swap needed
    mov   w4, w2
    mov   w2, w3
	mov   w3, w4
	str   w2, [x0, x26]
	str   w3, [x0, x27]
sort_no_swap:
	add   x26, x26, #4                // Increment index
	add   x27, x27, #4                // Increment index
	sub   x1, x1, #1                  // Decrement size
    b     sort_outer_loop
sort_done:
    epilogue
    ret

// swap_int: Swap two integers
//   x0 = address of the first integer
//   x1 = address of the second integer
swap_int:
    prologue
    ldr   x2, [x19]                   // Load first integer into x2
    ldr   x3, [x20]                   // Load second integer into x3
    str   x3, [x19]                   // Store second integer at address of first
    str   x2, [x20]                   // Store first integer at address of second
    epilogue
    ret

// print_array: Print the integer array
//   x0 = address of the array
//   x1 = length of array
print_array:
    prologue
    push  x0, x1                      // x0 = addr of array, x1 = length of array
    push  x2, x3                      // x2 = loop index, x3 = array offset
    push  x4, x5                      // x4 = current item, x5 = ???
    mov   x2, #0                      // Initialize index to 0
    mov   x3, #0                      // Initialize offset to 0
print_loop:
    ldr   x4, [x0, x3]                // Load array element into x4
    push  x0, x1
    push  x2, x3
    mov   w0, w4                      // Move the integer from w4 into w0
    bl    print_int                   // Print the integer at w0
    mov   w0, SPACE                   // Move the SPACE character into w0
    bl    print_char                  // Print the character at w0
    pop   x2, x3
    pop   x0, x1
    add   x2, x2, #1                  // Increment index
    add   x3, x3, #4                  // Increment offset
    cmp   x2, x1                      // If index >= size, we are done
    b.ge  print_done
    b     print_loop                  // Otherwise, continue looping
print_done:
    mov   w0, NEWLINE                 // Load newline character
    bl    print_char                  // Print the newline
    pop   x4, x5
    pop   x2, x3
    pop   x0, x1
    epilogue
    ret

// print_int: Print an integer
//   x0 = integer to print
print_int:
    prologue
    bl    itoa                        // Convert integer (x0) to ASCII in buffer
    bl    print_string                // Print the string at buffer
    epilogue
    ret

// print_char: Print a single character
//   x0 = character to print
print_char:
    prologue
    push  x0, x1
    push  x2, x3
    strb  w0, [sp, #-1]!              // Push character onto stack
    mov   x1, sp                      // Set x1 to address of the character
    mov   x2, #1                      // Length = 1 for one character
    mov   x8, #64                     // Syscall number for write
    mov   x0, #1                      // File descriptor stdout
    svc   0                           // Make syscall
    add   sp, sp, #1                  // Pop the character from the stack
    pop   x2, x3
    pop   x0, x1
    epilogue
    ret

// print_string: Print a null-terminated string
//   x1 = address of the string
//   x2 = length (returned by strlen)
print_string:
    prologue
    bl    strlen                      // x0 = length of string at x1
    mov   x2, x0                      // Copy length into x2
    mov   x0, #1                      // File descriptor stdout
    mov   x8, #64                     // Syscall number for write
    svc   0                           // Make syscall
    epilogue
    ret

// itoa: Convert integer to ASCII string
//   x0 = integer to convert
//   x1 = address of buffer to store string
itoa:
    prologue
    ldr   x1, =buffer                 // x1 = buffer address
    mov   x2, x0                      // x2 = integer value
    mov   x3, x1                      // x3 = preserve starting buffer address
    mov   x4, #0                      // x4 = digit count = 0
    mov   x6, #10                     // x6 = divisor (10)
itoa_loop:
    udiv  x10, x2, x6                 // x10 = x2 / 10 (quotient)
    mul   x12, x10, x6                // x12 = quotient * 10
    sub   x14, x2, x12                // x14 = remainder = x2 - (quotient * 10)
    and   x14, x14, #0xff             // Clear any upper bits
    add   x14, x14, ASCII_0           // Convert to ASCII digit
    strb  w14, [x1]                   // Store digit in buffer pointed to by x1
    add   x1, x1, #1                  // Advance buffer pointer
    add   x4, x4, #1                  // Increment digit count
    mov   x2, x10                     // x2 = quotient
    cbnz  x2, itoa_loop               // Loop if quotient != 0
reverse:
    mov   x5, x3                      // x5 = start pointer = original buffer address
    mov   x7, x1                      // x7 = end pointer = current x1
    sub   x7, x7, #1                  // Adjust x7 to last valid character
reverse_loop:
    cmp   x5, x7                      // Compare start and end pointers
    b.ge  reverse_done                // Finished if start >= end
    ldrb  w6, [x5]                    // Load byte from start pointer
    ldrb  w8, [x7]                    // Load byte from end pointer
    strb  w8, [x5]                    // Swap: store byte from end at start
    strb  w6, [x7]                    // Swap: store byte from start at end
    add   x5, x5, #1                  // Advance start pointer
    sub   x7, x7, #1                  // Decrement end pointer
    b     reverse_loop
reverse_done:
    mov   x14, NULL_TERMINATOR        // Load null terminator
    strb  w14, [x1]                   // Store null terminator at buffer end
    ldr   x1, =buffer                 // x1 = buffer address
    epilogue
    ret

// strlen: Calculate length of a null-terminated string
//   x1 = address of the string; returns length in x0
strlen:
    prologue
    mov   x0, #0                      // Initialize length counter in x0
strlen_loop:
    ldrb  w2, [x1, x0]                // Load byte at x1 + x0
    cmp   w2, NULL_TERMINATOR         // Compare to null terminator
    beq   strlen_done                 // If found, finish
    add   x0, x0, #1                  // Increment length counter
    b     strlen_loop
strlen_done:
    epilogue
    ret                               // Return with length in x0

// clear_buffer: Function to clear the buffer
//   x0 = address of the buffer
//   x1 = size of the buffer
clear_buffer:
    prologue
    push  x0, x1
    push  x2, x3
    mov   x2, #0                      // Initialize the value to clear with (0)
clear_loop:
    cmp   x1, #0                      // Compare size with 0
    beq   clear_done                  // If size is 0, we're done
    strb  w0, [x1], #0                // Store 0 at the buffer address and increment the address
    sub   x1, x1, #1                  // Decrement the size
    b     clear_loop                  // Repeat the loop
clear_done:
    pop   x2, x3
    pop   x0, x1
    epilogue
    ret

// Function: copy_array
//   x0 = source address (e.g., address of the array)
//   x1 = destination address (e.g., address of the buffer)
//   x2 = number of 32-bit words to copy
copy_array:
    prologue
    push  x0, x1
    push  x2, x3
    cmp   x2, #0                      // Check if there is anything to copy
    beq   copy_done                   // If x2 is 0, exit the function
copy_loop:
    ldr   w3, [x0], #4                // Load a 32-bit word from source and post-increment x0 by 4
    str   w3, [x1], #4                // Store the 32-bit word into destination and post-increment x1 by 4
    sub   x2, x2, #1                  // Decrement the count
    cmp   x2, #0                      // Check if all words have been copied
    bne   copy_loop                   // If not, continue looping
copy_done:
    pop   x2, x3
    pop   x0, x1
    epilogue
    ret

_end:

.section .data                                  // Data section for constants
    hello: .asciz "Hello, World!\n"             // Define a null-terminated string
    array1: .word 5, 4, 3, 2, 1, 9, 8, 7, 6, 0  // The unsorted array
    array2: .word 51, 14, 31, 2, 11, 16         // The unsorted array

.section .bss                     // Uninitialized data section
    .align 3                      // Align to 8-byte boundary
    buffer: .skip 16              // Reserve 16 bytes for int-to-ASCII conversion
