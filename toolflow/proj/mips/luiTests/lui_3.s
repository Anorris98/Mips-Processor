# Test Case 3: Load a negative number (which gets sign-extended) into the upper half.

# This tests the instruction's behavior with sign extension.
lui $t0, 0x8001       # $t0 should be 0x80010000 after execution.

# Use addi to add a small positive number to check if the upper half is indeed 0x8001.
addi $t1, $t0, 1       # If the upper half was not 0x8001, this will not be 0x80010001.

halt
