.data
arr: .word 0 : 10
.text
la $s0, arr
addTests:
addi $t0, $zero, 100	#$t0 = 100
addiu $t1, $zero, -1	#$t1 = 4,294,967,295

nop
nop		#line 7 produces t1, line 13 uses it. we need 3 instructions in between for it to work right.
nop

addu $t3, $t0, $t1
add $t2, $t0, $zero	#$t2 = $t0

Loadtestcopy: # moved above and tets, loads values to be used by or tests early.
lw $t8, 0($s0)	
lui $t9, 0x1010 #psuedo instruction, inserts 3 additional nops.

andTests:
andi $t0, $t0, 66
and $t1, $t3, $t0	#okay becasuse origionlly we wanted to use the old value of $t0 anyway. 20/21 were swapped.

loadTests1: #load and store tests were swapped. first before messing with after sw.
lw $t1, 0($s0)	
lasw $t0, 0x1010 #psuedo instruction, inserts 3 additional nops.

addi $t0, $zero, 0x00000001 #moved up here, is used for the shifts to allow sll to shift it, sw uses the old $t0 data, so before its written, which is done by design.
addi $t7, $zero, -3456		#used in shift tests 2
		
orTests:
nor $t2, $9, $t8   #t8=t1,t9=t0
xori $t4, $t9, 0x11001100
or $t5, $t9, $t8
ori $t6, $t9, 0x4444
xor $t3, $t9, $t8


shiftTests1:
sll $t0, $t0, 4
slt $t1, $t4, $t5
slti $t2, $t2, 55

swTest:		#sw tests swapped with or test 2
sw $t0, 0($s0)

shiftTests2:		#multiple 3 nops here because of multiple consumer and producers used back to back.
srl $t0, $t0, 4
sra $t7, $t7, 4

subTests:		#t0 and t1 are reset here.##########
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
nop	#Required 3 becasue of consumer and producer t7 being so close. this fix also fixes t0 issue.
nop
nop
sllv $t1, $t0, $t7
srlv $t2, $t0, $t7
addi $t0, $zero, -3456
nop
nop	#same issue as above.
nop
srav $t3, $t0, $t7
nop	#for halt
nop
nop
halt
