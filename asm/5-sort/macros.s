// prologue: set up frame pointer and link register
.macro prologue
    stp     x29, x30, [sp, #-16]!          // Save frame pointer and link register
    mov     x29, sp                        // Set frame pointer to stack pointer
.endm

// epilogue: restore frame pointer and link register
.macro epilogue
    ldp     x29, x30, [sp], #16            // Restore frame pointer and link register
.endm

// push: store registers on the stack
.macro push reg1, reg2
    sub     sp, sp, #16                   // Allocate space for two registers
    stp     \reg1, \reg2, [sp]            // Store registers in memory
.endm

// pop: restore registers from the stack
.macro pop reg1, reg2
    ldp     \reg1, \reg2, [sp]            // Load registers from memory
    add     sp, sp, #16                   // Restore stack pointer
.endm

// constants
.equ    SPACE, 32
.equ    NEWLINE, '\n'
.equ    NULL_TERMINATOR, 0
.equ    ASCII_0, '0'
