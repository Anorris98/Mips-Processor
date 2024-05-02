.data
output: .asciiz "Value : "
op1: .word -1
.text
.global main

main:

lw $t0, op1

#sll $t1, $t0, 30 #output was -2147483648
#sll $t1, $t0, 29 #output was -1073741824
sll $t1, $t0, 15
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
