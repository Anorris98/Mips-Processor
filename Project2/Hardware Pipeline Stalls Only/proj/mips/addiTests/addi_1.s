# The objective of this stress test is to check that the register file and ALU work proporely and they can write immediate values to all registes.
# The result value of each register should be its number. 

.data
.text
.globl main

main:

    # Start Test
    addi $1, $0, 1      # verify that the value of reister $1 is 1 and $0 + immediate(1) works in the ALU   
    addi $2, $0, 2      # verify that the value of reister $2 is 2 and $0 + immediate(2) works in the ALU   
    addi $3, $0, 3      # verify that the value of reister $3 is 3 and $0 + immediate(3) works in the ALU 
    addi $4, $0, 4      # verify that the value of reister $4 is 4 and $0 + immediate(4) works in the ALU  
    addi $5, $0, 5    	# verify that the value of reister $5 is 5 and $0 + immediate(5) works in the ALU    
    addi $6, $0, 6    	# verify that the value of reister $6 is 6 and $0 + immediate(6) works in the ALU  
    addi $7, $0, 7    	# verify that the value of reister $7 is 7 and $0 + immediate(7) works in the ALU  
    addi $8, $0, 8    	# verify that the value of reister $8 is 8 and $0 + immediate(8) works in the ALU   
    addi $9, $0, 9    	# verify that the value of reister $9 is 9 and $0 + immediate(9) works in the ALU 
    addi $10, $0, 10    # verify that the value of reister $10 is 10 and $0 + immediate(10) works in the ALU   
    addi $11, $0, 11    # verify that the value of reister $11 is 11 and $0 + immediate(11) works in the ALU   
    addi $12, $0, 12    # verify that the value of reister $12 is 12 and $0 + immediate(12) works in the ALU   
    addi $13, $0, 13    # verify that the value of reister $13 is 13 and $0 + immediate(13) works in the ALU   
    addi $14, $0, 14    # verify that the value of reister $14 is 14 and $0 + immediate(14) works in the ALU   
    addi $15, $0, 15    # verify that the value of reister $15 is 15 and $0 + immediate(15) works in the ALU   
    addi $16, $0, 16    # verify that the value of reister $16 is 16 and $0 + immediate(16) works in the ALU   
    addi $17, $0, 17    # verify that the value of reister $17 is 17 and $0 + immediate(17) works in the ALU   
    addi $18, $0, 18    # verify that the value of reister $18 is 18 and $0 + immediate(18) works in the ALU   
    addi $19, $0, 19    # verify that the value of reister $19 is 19 and $0 + immediate(19) works in the ALU   
    addi $20, $0, 20    # verify that the value of reister $20 is 20 and $0 + immediate(20) works in the ALU   
    addi $21, $0, 21    # verify that the value of reister $21 is 21 and $0 + immediate(21) works in the ALU  
    addi $22, $0, 22    # verify that the value of reister $22 is 22 and $0 + immediate(22) works in the ALU   
    addi $23, $0, 23    # verify that the value of reister $23 is 23 and $0 + immediate(23) works in the ALU   
    addi $24, $0, 24    # verify that the value of reister $24 is 24 and $0 + immediate(24) works in the ALU   
    addi $25, $0, 25    # verify that the value of reister $25 is 25 and $0 + immediate(25) works in the ALU  
    addi $26, $0, 26    # verify that the value of reister $26 is 26 and $0 + immediate(26) works in the ALU   
    addi $27, $0, 27    # verify that the value of reister $27 is 27 and $0 + immediate(27) works in the ALU   
    addi $28, $0, 28    # verify that the value of reister $28 is 28 and $0 + immediate(28) works in the ALU   
    addi $29, $0, 29    # verify that the value of reister $29 is 29 and $0 + immediate(29) works in the ALU   
    addi $30, $0, 30    # verify that the value of reister $30 is 30 and $0 + immediate(30) works in the ALU   
    addi $31, $0, 31    # verify that the value of reister $31 is 31 and $0 + immediate(31) works in the ALU

    # End Test

    # Exit program
    halt
