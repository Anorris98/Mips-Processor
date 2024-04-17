.data
arr: .word 0 : 10
.text
lui $1, 0x0001001 #replaces la as psuedocode breaks the instruction.
nop
nop
nop
ori $16, $1, 0x00000000 
nop
nop ######la####

addTests:
addi $t0, $zero, 100	#$t0 = 100
addiu $t1, $zero, -1	#$t1 = 4,294,967,295

nop
nop		#line 7 produces t1, line 13 uses it. we need 3 instructions in between for it to work right.
nop

addu $t3, $t0, $t1
add $t2, $t0, $zero	#$t2 = $t0

#or test setup moved above and tets, loads values to be used by or tests early.
lw $t8, 0($s0)	
lui $t9, 0x1010 #psuedo instruction, inserts 3 additional nops.

andTests:
andi $t0, $t0, 66
nop
nop
nop
and $t1, $t3, $t0	#okay becasuse origionlly we wanted to use the old value of $t0 anyway. 20/21 were swapped.

loadTests1: #load and store tests were swapped. first before messing with after sw.
lw $t1, 0($s0)	
lui $t0, 0x1010

addi $t0, $zero, 0x00000001 #moved up here, is used for the shifts to allow sll to shift it, sw uses the old $t0 data, so before its written, which is done by design.
addi $t7, $zero, -3456		#used in shift tests 2
		
orTests:
nor $t2, $t9, $t8   #t8=t1,t9=t0

lui $1, 0x00001100##Mips assembles XORI into 3 psuedo instructions, so I was unable to test that here. becasue our system can do it in one single instruction.
nop
nop
nop
ori $1,$1, 0x00001100
nop
nop
nop
xor $12, $25, $1 ##xori###############################

or $t5, $t9, $t8
ori $t6, $t9, 0x4444
xor $t3, $t9, $t8

#load regs for sub tests
addi $t8, $zero, 10					#addi and sub require 4, if we insert 1 before addi t1, we can still keep things rolling. then we only have to have 2 below it.
addi $t9, $zero, 8 

shiftTests1:
sll $t0, $t0, 4
slt $t1, $t4, $t5
slti $t2, $t2, 55
nop

swTest:		#sw tests swapped with or test 2
sw $t0, 0($s0)

shiftTests2:		#multiple 3 nops here because of multiple consumer and producers used back to back.
srl $t0, $t0, 4
sra $t7, $t7, 4

subTests:		#t0 and t1 are reset here.##########					#addi and sub require 4, if we insert 1 before addi t1, we can still keep things rolling. then we only have to have 2 below it.
sub $t2, $t8, $t9
sub $t3, $t9, $t8
subu $t4, $t9, $t8

#shift variable setup
addi $t0, $zero, 0x00000001
addi $t7, $zero, 4

loadTests2:
lb $t8, 0($s0)
lh $t9, 4($s0)
lbu $t2, 8($s0)

addi $t0, $zero, -3456

nop

lhu $t3, 12($s0)

nop

shiftVariableTests:

sllv $t1, $t0, $t7 #we want the old value of $t0 in these, so I moved the addi to above it to allow less nops
srlv $t2, $t0, $t7
srav $t3, $t0, $t7 #we want the new value of $t0 here

halt
