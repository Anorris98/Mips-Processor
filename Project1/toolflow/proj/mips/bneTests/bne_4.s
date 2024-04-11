#This test case adds the values in the two registers, multiplies it by 2 and checks if the value in the register is equal to immediate value. If equal the program executes normally, if not equal the program branches.

#Using the values set in this test case we will exit the program without branching. While writing the test case I tried editing the values and when the result is not equal branching takes place.
.data
.text
.globl main

main:
    # Initialize registers with values
    addi $t0, $zero, 10    # $t0 = 10
    addi $t1, $zero, 20    # $t1 = 20

    # Add two numbers
    add $t2, $t0, $t1      # $t2 = $t0 + $t1

    # Shift the result left by 1 bit
    sll $t2, $t2, 1        # $t2 = $t2 << 1

    # Compare the shifted result with 60
    addi $t3, $zero, 60    # $t3 = 60
    bne $t2, $t3, not_equal    # Branch to not_equal if $t2 != 60

    # If $t2 is equal to 60, set $v0 to 0 (success)
    addi $v0, $zero, 0

    # Exit program
    halt

not_equal:
    # If $t2 is not equal to 60, set $v0 to 1 (failure)
    addi $v0, $zero, 1

    # Exit program
    halt
