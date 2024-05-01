#
# First part of the Project 3 test program
#

# data section
.data
res:
	.word -1 8 -64 9
# code/instruction section
.text	
addi  $1, $0,  10	
la $fp, res	

sw $1, 0($fp)
lw $2, 0($fp)
lui $3, 1010
addiu $3, $3, 1

lw $4, 0($fp)
sw $4, 0($fp)
lh $4, 4($fp)
sw $4, 4($fp)
lhu $4, 8($fp)
sw $4, 8($fp)

addi $5, $zero, 64
add $6, $5, $zero
add $7, $6, $6
add $8, $7, $6


halt
