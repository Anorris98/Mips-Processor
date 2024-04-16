# The objective of this test is to check that the overflow detection when the resulted positive number 
# exceeds the maximum positive number that can be represnted 32-bit 2's complement number.

.data
.text
.globl main

main:

    # Start Test
    
    # Starting value of $1 = 0x7FFF0000
    lui $1, 0x7FFF 
    # value of $1 = 0x7FFF7FFF	
    addi $1, $1, 0x7FFF
    # Starting value of $1 = 0x7FFFFFFE 
    addi $1, $1, 0x7FFF
    # Starting value of $1 = 0x7FFFFFFF (The largest postive number that can be represented in 32-bit 2's complement number)     
    addi $1, $1, 1     	  
    # Adding 1 should cause an arithmetic overflow
    addi $1, $1, 1        

    # Exit program
    halt
