.data
.text
.globl main
main:
	#Start Test of max values, faulting sign detection computations 
	addi $5, $0, 5
	lui $1, 0xFFFF	 
	ori $1, 0xFFFF     #place all F's in a register
	slt $2, $1, $5	 #faults sign detection with the max negative number
	slt $2, $5, $1   #faults sign detection with the max negative number(alternate case)
	lui $1, 0x7FFF
	ori $1, 0xFFFF
	slt $2, $1, $5   #faults sign detection with the max positive number
	slt $2, $1, $5   #faults sign detection with the max positive number (alternate case)

	#End Test
   	# Exit program
    	halt
