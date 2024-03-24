.data
output: .asciiz "Value : "
op1: .word -999999999 #Largest Operand Value
.text
.global main

main:

lw $t0, op1

#sll $t1, $t0, 30 #output was -1073741824
#sll $t1, $t0, 29 #output was -536870912
#output for 16 is 906035200
#output for 15 is -1694466048
#output for 1 is -1999999998
sll $t1, $t0, 16
li $t2, 0
addiu $t2, $t2, 4

#print value to see what it is 

li $v0, 4
la $a0, output
syscall

li $v0, 1
addu $a0,$zero, $t1
syscall

li $v0, 10
syscall

halt
