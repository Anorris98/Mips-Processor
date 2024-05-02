#
# Second part of the Project 3 test program
#

# data section
.data

# code/instruction section
.text	
start:
addi $t1, $0, 1
bne $t1, $0, notEqual
equal:

j end
function:
jr

notEqual:
addi $t1, $t1, -1
jal function
beq $t1, $0, equa


end:
halt
