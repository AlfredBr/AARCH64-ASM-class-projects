// Define the prologue macro
.macro prologue
    stp     x29, x30, [sp, #-16]!    // Save frame pointer and link register
    mov     x29, sp                  // Set frame pointer to stack pointer
.endm

// Define the epilogue macro
.macro epilogue
    ldp     x29, x30, [sp], #16      // Restore frame pointer and link register
.endm

// Constants
.equ    SPACE, 32
.equ    NEWLINE, '\n'
.equ    NULL_TERMINATOR, 0
.equ    ASCII_0, '0'
