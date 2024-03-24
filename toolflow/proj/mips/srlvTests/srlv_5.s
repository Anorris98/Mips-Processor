# Test 1: shifting right by a variable amount when the amount is 31 bits.
# This test would need to show that the most significant bit can be shifted down to the least significant bit of the register (the maximum shift amount)


.data
.text
.globl main
main:
    # Start Test

    addi $5, $0, 31
    addi $20, $0, 2147483648
    
    srlv $20, $20, $5 
         
    # End Test

    # Exit program
    halt
