# Test Case 1: Load the maximum unsigned 16-bit value (0xFFFF) into the upper half.

# This tests the instruction's ability to handle the largest possible immediate value.
lui $t0, 0xFFFF       # $t0 should be 0xFFFF0000 after execution.

# Use addi to check if the lower half is indeed zero by adding 1 and checking if the result is 0xFFFF0001.
addi $t1, $t0, 1       # If lower half was not zero, this will not be 0xFFFF0001.

halt
