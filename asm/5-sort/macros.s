// Define the prologue macro
.macro prologue
    stp x29, x30, [sp, #-16]!    // Save x29 and x30
    mov x29, sp                  // Set frame pointer
.endm

// Define the epilogue macro
.macro epilogue
    ldp x29, x30, [sp], #16      // Restore x29 and x30
.endm

// Constants
.equ NEWLINE, 10
.equ NULL_TERMINATOR, 0
.equ ASCII_0, 48
