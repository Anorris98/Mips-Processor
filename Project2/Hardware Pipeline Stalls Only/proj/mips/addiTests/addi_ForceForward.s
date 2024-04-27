# The objective of this stress test is to check that the register file and ALU work proporely and they can write immediate values to all registes.
# The result value of each register should be its number. 

.data
.text
.globl main

main:

    # Start Test
    addi $1, $0, 1      # verify that the value of reister $1 is 1 and $0 + immediate(1) works in the ALU   
    addi $1, $1, 1      # verify that the value of reister $1 is 1 and $1 + immediate(1) works in the ALU   
    addi $1, $1, 1      # verify that the value of reister $1 is 1 and $1 + immediate(1) works in the ALU   
    addi $1, $1, 1      # verify that the value of reister $1 is 1 and $1 + immediate(1) works in the ALU   
    addi $1, $1, 1      # verify that the value of reister $1 is 1 and $1 + immediate(1) works in the ALU   

    # End Test

    # Exit program
    halt
