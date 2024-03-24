#This test case consders branching using immediate values instead of the values stored in the registers. We have two conditions that check for two different register values. The first test case uses value that is not equal thus branching but the second command uses the value stored in the register tus exiting the program.

#I have included this test case to check for if the immediate value are compared correctly, and to check the behaviour when the the value is equal will the case branch or not.
.data
.text
.globl main

main:
    # Initialize registers with immediate values
    addi $t0, $zero, 100    # $t0 = 100
    addi $t1, $zero, 200    # $t1 = 200
    addi $t2, $zero, 300    # $t2 = 300
    addi $t3, $zero, 100    # $t3 = 100

    # Branch if $t0 is not equal to immediate value
    bne $t0, 175, not_equal1    # Branch to not_equal1 if $t0 != 175

    # Branch if $t2 is not equal to immediate value
    bne $t2, 300, not_equal2    # Branch to not_equal2 if $t2 != 300

    # Exit program if both conditions satisfied
    addi $t0 $0 1
    halt

not_equal1:
    # Exit program if first condition is met
    addi $t0 $0 2
    halt

not_equal2:
    # Exit program if second condition is met
    addi $t0 $0 3
    halt
