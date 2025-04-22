// This program demonstrates sorting and printing arrays in ARM Assembly.
// It shows how to print arrays, copy arrays, and sort them step by step.
// Each function and instruction is explained for clarity.

.global _start                        // The entry point for the program
.align 2                              // Make sure instructions are aligned properly in memory

.section .text                        // Section for code (instructions)
.include "macros.s"                   // Include macros (shortcuts for common code)

_start:
    // Copy array1 into buffer for sorting
    ldr   x0, =array1                 // x0 = source address
    ldr   x1, =buffer                 // x1 = destination address
    mov   x2, #10                     // x2 = number of elements
    bl    copy_array                  // Copy array1 into buffer
    // Print the unsorted array
    ldr   x0, =buffer                 // x0 = address of buffer
    mov   x1, #10                     // x1 = number of elements
    bl    print_array                 // Print the buffer (unsorted)
    // Sort the buffer and print after every comparison
    ldr   x0, =buffer                 // x0 = address of buffer
    mov   x1, #10                     // x1 = number of elements
    bl    sort_array                  // Sort the buffer, printing after each comparison
	// Jump to end of program
    b     _end

sort:
    bl    sort_array                  // Call the sort_array function
    ldr   x0, =buffer                 // Load the address of the buffer into x0
    mov   x1, #10                     // Load the size of the array into x1
    bl    print_array                 // Call the print_array function
    b     _end                        // Jump to end

// print_array: Print the integer array
//   x0 = address of the array
//   x1 = length of array
// This function prints each number in the array, separated by spaces, then prints a newline.
print_array:
    prologue                         // Set up the stack frame for this function
    push  x0, x1                     // Save x0 (array address) and x1 (length) on the stack
    push  x2, x3                     // Save x2 (index) and x3 (offset) on the stack
    push  x4, x5                     // Save x4 (current item) and x5 (extra register) on the stack
    mov   x2, #0                     // x2 = index, start at 0
    mov   x3, #0                     // x3 = offset in bytes, start at 0
print_loop:
    ldr   x4, [x0, x3]               // Load the current array element into x4
    push  x0, x1                     // Save x0 and x1 before calling another function
    push  x2, x3                     // Save x2 and x3 before calling another function
    mov   w0, w4                     // Move the integer to print into w0
    bl    print_int                  // Print the integer in w0
    mov   w0, SPACE                  // Move the space character into w0
    bl    print_char                 // Print the space
    pop   x2, x3                     // Restore x2 and x3
    pop   x0, x1                     // Restore x0 and x1
    add   x2, x2, #1                 // Increase index by 1
    add   x3, x3, #4                 // Move to the next element (4 bytes per int)
    cmp   x2, x1                     // Check if we've printed all elements
    b.ge  print_done                 // If yes, exit the loop
    b     print_loop                 // Otherwise, print the next element
print_done:
    mov   w0, NEWLINE                // Move the newline character into w0
    bl    print_char                 // Print the newline
    pop   x4, x5                     // Restore x4 and x5
    pop   x2, x3                     // Restore x2 and x3
    pop   x0, x1                     // Restore x0 and x1
print_end:
    epilogue                         // Restore the stack frame
    ret                              // Return from the function

// Function to sort the array
//   x0 = address of the array
//   x1 = size of the array
// This function sorts the array using a simple sorting algorithm (like selection sort).
// It prints the array after every comparison, so you can see how it changes step by step.
sort_array:
    prologue
    mov   x20, x0                  // x20 = base address of array
    mov   x21, x1                  // x21 = size (n)
    mov   x22, #0                  // x22 = i (outer loop index)
sort_outer_loop:
    cmp   x22, x21                 // if i >= n, done
    b.ge  sort_done
    mov   x23, x22                 // x23 = j (inner loop index)
    add   x23, x23, #1             // j = i + 1
sort_inner_loop:
    cmp   x23, x21                 // if j >= n, end inner loop
    b.ge  sort_outer_next
    // Load a[i] and a[j]
    mov   x24, x22
    lsl   x24, x24, #2             // offset = i * 4 (4 bytes per int)
    ldr   w25, [x20, x24]          // w25 = a[i]
    mov   x26, x23
    lsl   x26, x26, #2             // offset = j * 4
    ldr   w27, [x20, x26]          // w27 = a[j]
    // Compare and swap if needed
    cmp   w27, w25                 // Compare a[j] and a[i]
    b.ge  sort_print               // If a[j] >= a[i], no swap needed
    // swap a[i] and a[j]
    str   w27, [x20, x24]          // Store a[j] at a[i]
    str   w25, [x20, x26]          // Store a[i] at a[j]
sort_print:
    // Print array after every comparison (so you can see the sorting progress)
    mov   x0, x20                  // x0 = array address
    mov   x1, x21                  // x1 = array size
    bl    print_array
    add   x23, x23, #1             // j++
    b     sort_inner_loop
sort_outer_next:
    add   x22, x22, #1             // i++
    b     sort_outer_loop
sort_done:
    epilogue
    ret

// swap_int: Swap two integers
//   x0 = address of the first integer
//   x1 = address of the second integer
// This function swaps the values at two memory locations.
swap_int:
    prologue
    ldr   x2, [x19]                   // Load first integer into x2
    ldr   x3, [x20]                   // Load second integer into x3
    str   x3, [x19]                   // Store second integer at address of first
    str   x2, [x20]                   // Store first integer at address of second
    epilogue
    ret

// print_int: Print an integer
//   x0 = integer to print
// This function prints an integer by converting it to a string first.
print_int:
    prologue
    bl    itoa                        // Convert integer (x0) to ASCII in buffer
    bl    print_string                // Print the string at buffer
    epilogue
    ret

// print_char: Print a single character
//   x0 = character to print
// This function prints a single character to the screen.
print_char:
    prologue
    push  x0, x1
    push  x2, x3
    strb  w0, [sp, #-1]!              // Put the character on the stack
    mov   x1, sp                      // x1 = address of the character
    mov   x2, #1                      // x2 = length (1 character)
    mov   x8, #64                     // x8 = syscall number for write
    mov   x0, #1                      // x0 = file descriptor for stdout
    svc   0                           // Make the syscall (print)
    add   sp, sp, #1                  // Remove the character from the stack
    pop   x2, x3
    pop   x0, x1
    epilogue
    ret

// print_string: Print a null-terminated string
//   x1 = address of the string
//   x2 = length (returned by strlen)
// This function prints a string (sequence of characters) to the screen.
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
// This function converts an integer to a string (so it can be printed).
itoa:
    prologue
    ldr   x1, =itoa_buf               // x1 = buffer address
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
    mov   x14, NULL                   // Load null terminator
    strb  w14, [x1]                   // Store null terminator at buffer end
    ldr   x1, =itoa_buf               // x1 = buffer address
    epilogue
    ret

// strlen: Calculate length of a null-terminated string
//   x1 = address of the string; returns length in x0
// This function counts how many characters are in a string (until it finds a 0/null).
strlen:
    prologue
    mov   x0, #0                      // Initialize length counter in x0
strlen_loop:
    ldrb  w2, [x1, x0]                // Load byte at x1 + x0
    cmp   w2, NULL                    // Compare to null terminator
    beq   strlen_done                 // If found, finish
    add   x0, x0, #1                  // Increment length counter
    b     strlen_loop
strlen_done:
    epilogue
    ret                               // Return with length in x0

// Function: copy_array
//   x0 = source address (e.g., address of the array)
//   x1 = destination address (e.g., address of the buffer)
//   x2 = number of 32-bit words to copy
// This function copies an array from one place in memory to another.
copy_array:
    prologue
    push  x0, x1
    push  x2, x3
    cmp   x2, #0                      // Check if there is anything to copy
    beq   copy_done                   // If x2 is 0, exit the function
copy_loop:
    ldr   w3, [x0], #4                // Load a 32-bit word from source and move to next
    str   w3, [x1], #4                // Store the word into destination and move to next
    sub   x2, x2, #1                  // Decrease the count
    cmp   x2, #0                      // Check if all words have been copied
    b.ne  copy_loop                   // If not, continue looping
copy_done:
    pop   x2, x3
    pop   x0, x1
    epilogue
    ret

_end:
    mov     x0, #0                    // Set x0 to 0 (exit status)
    mov     x8, #93                   // Syscall: exit (93)
    svc     0                         // Make the syscall (end the program)


.section .data                                  // Data section for constants
    array1: .word 5, 4, 3, 2, 1, 9, 8, 7, 6, 0  // The unsorted array (single digit numbers)
    array2: .word 51, 14, 31, 2, 11, 16         // Another unsorted array (multi-digit numbers)

.section .bss                     // Uninitialized data section
    .align 3                      // Align to 8-byte boundary
    buffer: .skip 40              // Reserve 40 bytes for copying arrays (10 ints)
    itoa_buf: .skip 40            // Reserve 40 bytes for converting ints to strings
