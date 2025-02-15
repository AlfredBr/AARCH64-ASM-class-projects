// This program generates a string of 26 characters
// from 'A' to 'Z' and prints it to the console.
// Syscall info: https://arm64.syscall.sh/
// Procedure call standard: https://developer.arm.com/documentation/dui0041/c/ARM-Procedure-Call-Standard/About-the-ARM-Procedure-Call-Standard?lang=en
// ASCII Table: https://www.asciitable.com/

.section .text
.global _start
.balign 4

.include "macros.s"

_start:
	ldr x6, =buffer   // Load the address of buffer into x6
	mov w0, #65       // Move ASCII code for 'A' to w0
	mov x7, #26       // Move the max length of the string to x7
	mov x2, #0        // Initialize the w2 index to 0

_loop_start:
	strb w0, [x6]     // Store 'A' in buffer
	add x6, x6, #1    // Increment the address in x6
	add w0, w0, #1    // Move to the next ASCII code
	add x2, x2, #1    // Increment the index
	cmp x2, x7        // Compare the index with the length
	b.lt _loop_start  // If index < length, loop back
	mov w0, #10       // Move ASCII code for '\n' to w0
	strb w0, [x6]	  // Store the ASCII code for '\n' in buffer
	add x2, x2, #1    // Increment the length
	ldr x1, =buffer   // Load the address of buffer into x1
	bl print_string   // Call print_string

_exit:
    mov x0, #0        // Set x0 to 0 (successful exit status)
    mov x8, #93       // Set x8 to 93 (sys_exit syscall number)
    svc 0             // Make the syscall


// Function to print a string
print_string:
    prologue          // Function prologue
    mov x0, #1        // File descriptor for stdout
    mov x8, #64       // Syscall number for write
    svc 0             // Make the syscall
    epilogue          // Function epilogue
	ret

_end:

.section .data
    buffer:    .space 64
