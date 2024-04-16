# Test Case 1: Basic Jump Functionality

.text
.globl main
main:
    la $t0, jump_target    # Load the address of jump_target into $t0
    jr $t0                 # Jump to jump_target
    nop                    # This instruction is skipped if jr works

jump_target:
    halt
