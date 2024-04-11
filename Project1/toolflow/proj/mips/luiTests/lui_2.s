# Test Case 2: Load a zero into the upper half.

# This tests the instruction's ability to clear a register.
lui $t0, 0x0000       # $t0 should be 0x00000000 after execution.

# Use addi to add 0 to $t0, if $t0 is not zero, this will be non-zero.
addi $t1, $t0, 0       # If $t0 was not cleared, this will not be zero.\

halt
