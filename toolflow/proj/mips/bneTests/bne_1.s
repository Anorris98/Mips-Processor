#This test case checks for inequality branching. The following test case checks if $t0 and $t1 are not equal and branches to not_equal: branch where it sets $vo with the result.

#I have included this test case to check the original behaviour of the instruction using simple instructions.
.data
.text
.globl main

main:
    addi $t0, $zero, 100    # Initialize register $t0 with value 100
    addi $t1, $zero, 150    # Initialize register $t1 with value 150

    addi $t2, $zero, 1     # Initialize register $t2 for storing result
    bne $t0, $t1, not_equal    # Branch to not_equal if $t0 is not equal to $t1
    addi $t2, $zero, 0     # Set $t2 to 0 if equal

not_equal:
    # Exit program
    halt
