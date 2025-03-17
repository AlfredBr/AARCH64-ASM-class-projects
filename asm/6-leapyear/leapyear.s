.global _start
.align 2

.section .text
.include "macros.s"      // Include macros file

_start:
    // Prompt for input
    ldr     x1, =prompt         // Prompt string address
    bl      print_string        // Print prompt
    // Read input from stdin
    mov     x0, #0              // FD 0 (stdin)
    mov     x8, #63             // syscall: read
    ldr     x1, =buffer         // Buffer address
    mov     x2, #100            // Max bytes to read
    svc     #0
    // Validate input length
    ldr     x1, =buffer
    bl      strlen              // Return length in x0
    cmp     x0, #1              // Compare length with newline only
    bgt     convert_input_to_year
    b       print_usage_and_exit

convert_input_to_year:
    ldr     x1, =buffer
    bl      atoi                // Convert input string to integer in x0
    mov     x19, x0             // Year stored in x19
    // Check leap year:
    // if (year % 4 != 0) => not leap
    mov     x2, x19
    mov     x3, #4
    udiv    x4, x2, x3
    mul     x4, x4, x3
    sub     x4, x2, x4          // remainder: year mod 4
    cmp     x4, #0
    bne     not_leap
    // if (year % 100 != 0) => leap
    mov     x2, x19
    mov     x3, #100
    udiv    x5, x2, x3
    mul     x5, x5, x3
    sub     x5, x2, x5          // remainder: year mod 100
    cmp     x5, #0
    bne     leap_true
    // else if (year % 400 == 0) => leap
    mov     x2, x19
    mov     x3, #400
    udiv    x6, x2, x3
    mul     x6, x6, x3
    sub     x6, x2, x6          // remainder: year mod 400
    cmp     x6, #0
    beq     leap_true
    b       not_leap

leap_true:
    ldr     x1, =leap_prefix
    bl      print_string
    mov     x0, x19
    bl      itoa                // itoa returns pointer to buffer_rev in x1
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
    mov     x8, #93             // syscall: exit
    svc     #0

// atoi: convert null-terminated string (in x1) to integer (returned in x0)
atoi:
    prologue
    mov     x0, #0              // accumulator = 0
atoi_loop:
    ldrb    w2, [x1], #1
    cmp     w2, #0
    beq     atoi_done
    cmp     w2, #'0'
    blt     atoi_loop
    cmp     w2, #'9'
    bgt     atoi_loop
    mov     x9, #10
    mul     x0, x0, x9
    mov     w8, #48
    sub     w2, w2, w8
    add     x0, x0, w2, uxtw   // add digit (extended to 64-bit)
    b       atoi_loop
atoi_done:
    epilogue
    ret

// itoa: convert integer in x0 to a null-terminated ASCII string.
// The result is built in buffer_rev and pointer is returned in x1.
itoa:
    prologue
    ldr     x1, =buffer         // working buffer (unused)
    mov     x2, x0              // number to convert
    cmp     x2, #0
    bne     itoa_convert
    ldr     x3, =buffer_rev
    mov     w9, #'0'
    strb    w9, [x3], #1
    b       itoa_finish
itoa_convert:
    // Build reversed string in buffer_temp.
    ldr     x3, =buffer_temp
itoa_loop:
    mov     x9, #10
    udiv    x4, x2, x9         // quotient
    mul     x5, x4, x9
    sub     x6, x2, x5         // remainder
    add     x6, x6, #'0'
    strb    w6, [x3], #1       // store digit and increment pointer
    mov     x2, x4
    cmp     x2, #0
    bne     itoa_loop
    // Reverse digits from buffer_temp into buffer_rev.
    ldr     x10, =buffer_temp
    sub     x11, x3, x10       // x11 = number of digits
    ldr     x7, =buffer_rev    // destination pointer
copy_loop:
    cmp     x11, #0
    beq     itoa_finish
    sub     x11, x11, #1
    add     x12, x10, x11
    ldrb    w8, [x12]
    strb    w8, [x7], #1
    b       copy_loop
itoa_finish:
    mov     w9, #0
    strb    w9, [x7]           // null-terminate string
    ldr     x1, =buffer_rev
    epilogue
    ret

// print_string: prints a null-terminated string pointed by x1 to stdout.
print_string:
	prologue
    mov     x2, #0             // initialize length counter
print_string_loop:
    ldrb    w3, [x1, x2]
    cmp     w3, #0
    beq     ps_call
    add     x2, x2, #1
    b       print_string_loop
ps_call:
    mov     x0, #1             // FD 1 (stdout)
    mov     x8, #64            // syscall: write
    svc     #0
	epilogue
    ret

// strlen: calculates the length of a null-terminated string (input: x1; output: x0)
strlen:
    prologue
    mov     x0, #0             // length counter
strlen_loop:
    ldrb    w2, [x1, x0]
    cmp     w2, #0
    beq     strlen_done
    add     x0, x0, #1
    b       strlen_loop
strlen_done:
    epilogue
    ret

print_usage_and_exit:
    ldr     x1, =usage_msg
    mov     x0, #2             // FD 2 (stderr)
    mov     x2, #23            // usage message length
    mov     x8, #64            // syscall: write
    svc     #0
    mov     x0, #1             // exit failure code
    mov     x8, #93            // syscall: exit
    svc     #0

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
