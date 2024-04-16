# The objective of this test is to check that the overflow detection when the resulted negative number 
# exceeds the maximum negative number that can be represnted 32-bit 2's complement number.

.data
.text
.globl main

main:
    
    # Start Test
    
    # Starting value of $1 = 0x80000000 (largest negative number that can be represented in 32-bit 2's complement number)
    lui $1, 0x8000
    
    # Adding -1 should cause an arithmetic overflow
    addi $1, $1, -1
    
    # End Test

    # Exit program
    halt
