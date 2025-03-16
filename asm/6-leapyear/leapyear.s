.global _start
.align 2

.section .text
.include "macros.s"      // Include the macros file

_start:
	// Prompt user for input
	ldr x1, =prompt      // load address of prompt into x1
	bl print_string      // call print_string to print the prompt
	// Read input from user
    mov x0, #0           // file descriptor 0 (stdin)
    mov x8, #63          // syscall number 63 (read)
    ldr x1, =buffer      // buffer
    mov x2, #100         // max bytes to read
	svc #0               // syscall
    // Check if input is valid
	ldr x1, =buffer      // load address of buffer into x1
	bl strlen            // x0 = length of string
	cmp x0, #1           // compare length to #1 (i.e just a newline)
	bgt convert_input_to_year
	b print_usage_and_exit // if just a newline, print usage message and exit

convert_input_to_year:
	ldr x1, =buffer      // load address of buffer into x1
    bl      atoi         // atoi conversion store result in x0
    mov     x19, x0      // store year in x19
    // Test leap: if (year %4==0) then check (year%100 !=0) OR (year %400==0)
    // Compute year % 4
    mov     x2, x19
    mov     x3, #4
    udiv    x4, x2, x3
    mul     x4, x4, x3
    sub     x4, x2, x4      // remainder4 = x4
    cmp     x4, #0
    bne     not_leap        // if not divisible by 4 -> not leap

    // Check (year % 100 != 0)
    mov     x2, x19
    mov     x3, #100
    udiv    x5, x2, x3
    mul     x5, x5, x3
    sub     x5, x2, x5      // remainder100 = x5
    cmp     x5, #0
    bne     leap_true       // if not divisible by 100 -> leap

    // Else, check (year % 400 == 0)
    mov     x2, x19
    mov     x3, #400
    udiv    x6, x2, x3
    mul     x6, x6, x3
    sub     x6, x2, x6      // remainder400 = x6
    cmp     x6, #0
    beq     leap_true
    b       not_leap

leap_true:
    ldr     x1, =leap_prefix
    bl      print_string
    mov     x0, x19
    //bl      itoa            // itoa returns string in buffer_rev
    //bl      print_string
    ldr     x1, =leap_suffix
    bl      print_string
    b       exit_success

not_leap:
    ldr     x1, =not_leap_prefix
    bl      print_string
    mov     x0, x19
    //bl      itoa
    //bl      print_string
    ldr     x1, =not_leap_suffix
    bl      print_string

exit_success:
    mov     x0, #0
    mov     x8, #93         // sys_exit
    svc     0

// atoi: convert null-terminated string (in x1) to integer (in x0)
atoi:
    mov     x0, #0          // accumulator = 0
atoi_loop:
    ldrb    w2, [x1], #1
    cmp     w2, #0
    beq     atoi_done
    cmp     w2, #'0'
    blt     atoi_loop
    cmp     w2, #'9'
    bgt     atoi_loop
    // x0 = x0 *10 + (w2 - '0')
    mov     x9, #10           // Load constant 10 into x9
    mul     x0, x0, x9        // Multiply x0 by x9
    mov     w8, #48           // Load constant 48 into w8
    sub     w2, w2, w8        // Subtract 48 from w2 (result in w2)
    add     x0, x0, x2
    b       atoi_loop
atoi_done:
    ret

// itoa: convert integer in x0 to a null-terminated ascii string.
// The converted string is built in a temporary buffer and then reversed.
// Returns pointer in x1 (points to buffer_rev).
itoa:
    ldr     x1, =buffer      // working buffer (unused final result)
    mov     x2, x0         // copy number to x2
    // Special case for 0
    cmp     x2, #0
    bne     itoa_convert
    ldr     x3, =buffer_rev
    mov     w9, #'0'
    strb    w9, [x3], #1
    b       itoa_finish
itoa_convert:
    // Use buffer_temp to store digits in reverse order.
    ldr     x3, =buffer_temp
itoa_loop:
    mov     x9, #10           // Ensure x9 has constant 10
    udiv    x4, x2, x9        // Divide x2 by x9
    mul     x5, x4, x9        // Multiply x4 by x9
    sub     x6, x2, x5      // remainder = x2 - (quotient*10)
    add     x6, x6, #'0'
    strb    w6, [x3], #1
    mov     x2, x4
    cmp     x2, #0
    bne     itoa_loop
    // x3 now points past the last digit in temp buffer; reverse the string into buffer_rev.
    sub     x3, x3, #1      // point to last digit
    ldr     x10, =buffer_temp // Load the address of buffer_temp into x10
    cmp     x3, x10           // Compare x3 with x10
itoa_copy_loop:
    blt     itoa_finish
    ldrb    w8, [x3]
    strb    w8, [x7], #1
    subs    x3, x3, #1
    b       itoa_copy_loop
itoa_finish:
    // Null-terminate the reversed string.
    mov     w9, #0
    strb    w9, [x7]
    ldr     x1, =buffer_rev
    ret

// print_string: prints null-terminated string pointed by x1 to stdout.
print_string:
    // Compute length in x2.
    mov     x2, #0
print_string_loop:
    ldrb    w3, [x1, x2]
    cmp     w3, #0
    beq     ps_call
    add     x2, x2, #1
    b       print_string_loop
ps_call:
    mov     x0, #1          // stdout FD
    mov     x8, #64         // sys_write
    svc     0
    ret

// strlen: Calculate length of a null-terminated string
//   x1 = address of the string; returns length in x0
strlen:
    prologue
    mov     x0, #0              // Initialize length counter in x0
strlen_loop:
    ldrb    w2, [x1, x0]        // Load byte at x1 + x0
    cmp     w2, NULL_TERMINATOR // Compare to null terminator
    beq     strlen_done         // If found, finish
    add     x0, x0, #1          // Increment length counter
    b       strlen_loop
strlen_done:
    epilogue
    ret                         // Return with length in x0

print_usage_and_exit:
    ldr     x1, =usage_msg
    mov     x0, #2          // stderr FD
    mov     x2, #23         // usage message length
    mov     x8, #64         // sys_write
    svc     0
    // exit with failure code 1
    mov     x0, #1
    mov     x8, #93         // sys_exit
    svc     0

.section .data
prompt:           .asciz "Enter a year: "
leap_prefix:      .asciz "✅ "
leap_suffix:      .asciz " is a leap year\n"
not_leap_prefix:  .asciz "🛑 "
not_leap_suffix:  .asciz " is NOT a leap year\n"
usage_msg:        .asciz "Usage: leapyear <year>\n"

.section .bss
.lcomm buffer, 32
.lcomm buffer_temp, 32
.lcomm buffer_rev, 32
