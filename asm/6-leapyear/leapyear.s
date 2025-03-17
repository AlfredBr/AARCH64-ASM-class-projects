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
    bl      itoa            // itoa returns string in buffer_rev
    bl      print_string
    ldr     x1, =leap_suffix
    bl      print_string
    b       exit_success

not_leap:
    ldr     x1, =not_leap_prefix
    bl      print_string
    mov     x0, x19
    bl      itoa
    bl      print_string
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
    // Compute: x0 = x0 * 10 + (w2 - '0')
    mov     x9, #10
    mul     x0, x0, x9
    mov     w8, #48
    sub     w2, w2, w8
    add     x0, x0, w2, uxtw    // fixed: explicitly extend w2 to 64-bit
    b       atoi_loop
atoi_done:
    ret

// itoa: convert integer in x0 to a null-terminated ascii string.
// The converted string is built in a temporary buffer and then reversed.
// Returns pointer in x1 (points to buffer_rev).
itoa:
    ldr     x1, =buffer      // working buffer (unused final result)
    mov     x2, x0           // number to convert in x2
    cmp     x2, #0
    bne     itoa_convert
    ldr     x3, =buffer_rev
    mov     w9, #'0'
    strb    w9, [x3], #1
    b       itoa_finish
itoa_convert:
    // Build reversed number string in buffer_temp.
    ldr     x3, =buffer_temp
itoa_loop:
    mov     x9, #10
    udiv    x4, x2, x9       // quotient in x4
    mul     x5, x4, x9
    sub     x6, x2, x5       // remainder in x6
    add     x6, x6, #'0'
    strb    w6, [x3], #1     // store digit in buffer_temp (post-increment)
    mov     x2, x4
    cmp     x2, #0
    bne     itoa_loop
    // Calculate number of digits stored.
    ldr     x10, =buffer_temp
    sub     x11, x3, x10     // x11 = digit count
    ldr     x7, =buffer_rev  // destination pointer for final string
copy_loop:
    cmp     x11, #0         // done when count is zero
    beq     itoa_finish
    sub     x11, x11, #1    // decrement counter
    add     x12, x10, x11   // address of current digit in buffer_temp
    ldrb    w8, [x12]       // load digit
    strb    w8, [x7], #1    // store digit in buffer_rev and post-increment
    b       copy_loop
itoa_finish:
    mov     w9, #0
    strb    w9, [x7]        // null-terminate the string
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
    mov     x0, #0          // length counter
strlen_loop:
    ldrb    w2, [x1, x0]
    cmp     w2, #0          // compare with null terminator (0)
    beq     strlen_done
    add     x0, x0, #1
    b       strlen_loop
strlen_done:
    epilogue
    ret

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
