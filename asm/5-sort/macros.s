// prologue: save frame pointer and link register
.macro prologue
    stp     x29, x30, [sp, #-16]!          // Save frame pointer and link register
    mov     x29, sp                        // Set frame pointer to stack pointer
.endm

// epilogue: restore frame pointer and link register
.macro epilogue
    ldp     x29, x30, [sp], #16            // Restore frame pointer and link register
.endm

// push: store registers on the stack using pre-decrement addressing mode
.macro push reg1, reg2
    stp     \reg1, \reg2, [sp, #-16]!      // Pre-decrement sp and then store registers
.endm

// pop: restore registers from the stack using post-increment addressing mode
.macro pop reg1, reg2
    ldp     \reg1, \reg2, [sp], #16        // Load registers and post-increment sp by 16
.endm

// Macro to allocate space on the stack ensuring 16-byte alignment
.macro stack_alloc size
    sub     sp, sp, \size
.endm

// Macro to free space on the stack
.macro stack_free size
    add     sp, sp, \size
.endm

// constants
.equ    SPACE, 32
.equ    NEWLINE, '\n'
.equ    NULL_TERMINATOR, 0
.equ    ASCII_0, '0'
