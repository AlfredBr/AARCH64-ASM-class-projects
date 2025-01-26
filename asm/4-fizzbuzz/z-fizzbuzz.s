// Data section for storing constants and buffers
.section .data
	hello:	   	 .ascii "Hello, World!\n"  // Define the string "Hello, World!"
				 .byte 0x00				   // Null terminator
	hello_len =	 . - hello - 1     		   // Calculate length of the string "Hello, World!"
    fizz_str:    .ascii "Fizz"  // Define the string "Fizz"
    fizz_len:    .word 4        // Length of the string "Fizz"
    buzz_str:    .ascii "Buzz"  // Define the string "Buzz"
    buzz_len:    .word 4        // Length of the string "Buzz"
    newline:     .ascii "\n"    // Define the newline character
    newline_len: .word 1        // Length of the newline character
    number_buffer: .space 12    // Allocate 12 bytes for number string buffer

// Text section for code
.section .text
.global _start                  // Define the entry point

_start:
    mov x0, #0                  // Initialize counter to 0

loop:
    cmp x0, #32                 // Compare counter with 32
    bge exit                    // If counter >= 32, branch to exit

    ldr x0, =hello			   // Load address of hello into x0
	bl print_string
	b exit

    // Convert number to string
    mov x1, x0                  // Move counter value to x1
    ldr x2, =number_buffer      // Load address of number_buffer into x2
    bl int_to_string            // Call int_to_string function

    // Print the number
    ldr x0, =number_buffer      // Load address of number_buffer into x0
    bl print_string             // Call print_string function

    // Check divisibility by 3
    mov x1, x0                  // Move number to x1
    mov x2, #3                  // Move divisor 3 to x2
    bl is_divisible             // Call is_divisible function
    cmp x0, #1                  // Compare result with 1
    bne skip_fizz               // If not divisible, skip printing "Fizz"
    ldr x0, =fizz_str           // Load address of "Fizz" string into x0
    ldr x1, =fizz_len           // Load length of "Fizz" into x1
    bl print_fixed_string       // Call print_fixed_string function

skip_fizz:                      // Label to skip printing "Fizz"

    // Check divisibility by 5
    mov x1, x0                  // Move number to x1
    mov x2, #5                  // Move divisor 5 to x2
    bl is_divisible             // Call is_divisible function
    cmp x0, #1                  // Compare result with 1
    bne skip_buzz               // If not divisible, skip printing "Buzz"
    ldr x0, =buzz_str           // Load address of "Buzz" string into x0
    ldr x1, =buzz_len           // Load length of "Buzz" into x1
    bl print_fixed_string       // Call print_fixed_string function

skip_buzz:                      // Label to skip printing "Buzz"

    // Print newline
    ldr x0, =newline            // Load address of newline into x0
    ldr x1, =newline_len        // Load length of newline into x1
    bl print_fixed_string       // Call print_fixed_string function

    // Increment counter
    add x0, x0, #1              // Increment counter by 1
    b loop                      // Branch back to loop

exit:
    mov x0, #0                  // Set exit status to 0
    mov x8, #93                 // Set syscall number for exit
    svc 0                       // Make the syscall to exit

// Function to check divisibility
// Inputs:
//   x1 - number
//   x2 - divisor
// Returns:
//   x0 = 1 if divisible, else 0
is_divisible:
    udiv x3, x1, x2          	// Divide x1 by x2, store result in x3
    mul x4, x3, x2           	// Multiply x3 by x2, store result in x4
    cmp x4, x1               	// Compare x4 with original number
    mov x0, #0               	// Initialize result to 0
    cset x0, eq              	// Set x0 to 1 if equal (divisible)
    ret                      	// Return from function

// Function to convert integer to string
// Inputs:
//   x1 - number
//   x2 - buffer address
// Output:
//   Buffer contains null-terminated string
int_to_string:
    mov x3, x2               	// Move buffer address to x3
    mov x4, #10              	// Set base to 10
    mov x5, #0               	// Initialize temporary register x5

    cmp x1, #0               	// Compare number with 0
    bne convert_loop         	// If not zero, branch to convert_loop
    mov x5, #'0'             	// Move ASCII '0' to x5
    strb w5, [x3], #1        	// Store byte in buffer and increment pointer
    b convert_end            	// Branch to convert_end

convert_loop:
    mov x5, #0               	// Clear x5
    mov x6, x1               	// Move number to x6
    udiv x7, x6, x4           	// Divide x6 by 10, store quotient in x7
    msub x8, x7, x4, x6       	// Multiply x7 by 10 and subtract from x6 to get remainder
    add x8, x8, #'0'          	// Convert digit to ASCII
    strb w8, [x3], #1         	// Store byte in buffer and increment pointer
    mov x1, x7                	// Update number with quotient
    cmp x1, #0                	// Compare number with 0
    bne convert_loop            // If not zero, loop again

convert_end:
    mov x5, #0                  // Move null terminator to x5
    strb wzr, [x3]              // Store null byte in buffer

	// Reverse the string
    mov x1, x2                	// Move buffer address to x1
    sub x3, x3, x2            	// Calculate string length
    subs x3, x3, #1           	// Adjust length for zero indexing
    mov x4, #0                	// Initialize start index to 0

reverse_loop:
    cmp x4, x3                	// Compare start and end indices
    bge reverse_done          	// If start >= end, exit loop
    ldrb w5, [x1, x4]         	// Load byte from start
    ldrb w6, [x1, x3]         	// Load byte from end
    strb w6, [x1, x4]         	// Store end byte at start
    strb w5, [x1, x3]         	// Store start byte at end
    add x4, x4, #1            	// Increment start index
    sub x3, x3, #1            	// Decrement end index
    b reverse_loop            	// Repeat loop

reverse_done:
    ret                        	// Return from function

// Function to print a null-terminated string
// Input:
//   x0 - string address
print_string:
    mov x1, x0                  // Move string address to x1
    bl strlen                 	// Call strlen to get string length
    mov x2, x0                	// Move string address to x2
    mov x8, #64               	// Set syscall number for sys_write
    svc 0                     	// Make the syscall to write
    ret                        	// Return from function

// Function to print a fixed-length string
// Inputs:
//   x0 - string address
//   x1 - length
print_fixed_string:
    mov x2, x1                	// Move length to x2
    mov x1, x0                	// Move string address to x1
    mov x8, #64               	// Set syscall number for sys_write
    svc 0                     	// Make the syscall to write
    ret                        	// Return from function

// Function to calculate string length
// Input:
//   x1 - string address
// Returns:
//   x0 - length
strlen:
    mov x0, #0                	// Initialize length to 0
strlen_loop:
    ldrb w2, [x1, x0]         	// Load byte from string at [x1 + x0]
    cmp w2, #0                	// Compare byte with null terminator
    beq strlen_end            	// If null, branch to strlen_end
    add x0, x0, #1            	// Increment length
    b strlen_loop             	// Repeat loop
strlen_end:
    ret                        	// Return from function
