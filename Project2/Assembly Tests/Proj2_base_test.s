.data
arr: .word 0 : 10
.text
la $s0, arr
addTests:
addi $t0, $zero, 100	#$t0 = 100
addiu $t1, $zero, -1	#$t1 = 4,294,967,295
nop
nop		#line 6 produces t0, line 11 uses it. we need 4 instructions in between for it to work right.
nop
add $t2, $t0, $zero	#$t2 = $t0
addu $t3, $t0, $t1
nop
nop		#consumer and producer back to back
nop
nop
andTests:
and $t1, $t3, $t0
andi $t0, $t0, 66
nop
nop		#consumer and producer back to back
nop
nop
swTest:
sw $t0, 0($s0)
loadTests1:
lui $t0, 0x1010
lasw $t1, 0($s0)	#psuedo instruction, inserts 3 additional nops.
orTests:
nor $t2, $t0, $t1
xor $t3, $t0, $t1
xori $t4, $t0, 0x11001100
nop
or $t5, $t0, $t1
nop
ori $t6, $t0, 0x4444
nop
shiftTests:
slt $t1, $t4, $t5
slti $t2, $t2, 55
addi $t0, $zero, 0x00000001
nop
nop			#packaged with below statement
nop
nop
sll $t0, $t0, 4
nop
nop
nop
nop			#multiple 4 nops here because of multiple consumer and producers used back to back.
srl $t0, $t0, 4
addi $t0, $zero, -3456
nop
nop			#Packaged with above statement.
nop	
nop
sra $t0, $t0, 4
subTests:
addi $t0, $zero, 10			
nop			#addi and sub require 4, if we insert 1 before addi t1, we can still keep things rolling. then we only have to have 2 below it.
addi $t1, $zero, 8 
nop
nop
sub $t2, $t0, $t1
sub $t3, $t1, $t0
subu $t4, $t1, $t0
loadTests2:
lb $t0, 0($s0)
lh $t1, 4($s0)
lbu $t2, 8($s0)
lhu $t3, 12($s0)
shiftVariableTests:
addi $t0, $zero, 0x00000001
addi $t7, $zero, 4
nop
nop	#Required 4 becasue of consumer and producer t7 being so close. this fix also fixes t0 issue.
nop
nop
sllv $t1, $t0, $t7
srlv $t2, $t0, $t7
addi $t0, $zero, -3456
nop
nop
nop	#same issue as above.
nop
srav $t3, $t0, $t7
nop	#for halt
nop
nop
nop
halt
