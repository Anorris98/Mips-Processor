#This test case checks for the range of operand values by considering the end values. In our case we consider 2^31 - 1 and 2^-31.
.data
.text
.globl main

main:
    addi $t0, $zero, -2147483648    # Set $t0 to the smallest value (-2^31)
    addi $t1, $zero, 2147483647     # Set $t1 to the largest value (2^31 - 1)

    addi $t2, $zero, 1     # Initialize register $t2 for storing result
    bne $t0, $t1, not_equal    # Branch to not_equal if $t0 is not equal to $t1
    addi $t2, $zero, 0     # Set $t2 to 0 if equal

not_equal:
    # Exit program
    halt
