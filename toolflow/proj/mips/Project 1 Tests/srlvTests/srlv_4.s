# Test 1: shifting right by a variable amount described in a source register rs
# This test tests the common case/function of the srlv instruction


.data
.text
.globl main
main:
    # Start Test

    addi $5, $0, 4
    addi $9, $0, 3855
    addi $15, $0, 211       
    addi $21, $0, 164        

    srlv $9, $9, $5     #0b0000000011110000
    srlv $15, $15, $5   #0b00001101
    srlv $21, $21, $5   #0b1010
         
    # End Test

    # Exit program
    halt
