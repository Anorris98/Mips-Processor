.data
arr: .word 0 : 10
.text
la $s0, arr

branchTests:
addi $t0, $zero, 2
addi $t1, $zero, 0
loop1:
addi $t1, $t1, 1
bne $t0, $t1, loop1
addi $t0, $zero, 0
loop2:
addi $t1, $t1, -1
bne $t0, $t1, loop2
jumpTests:
jump0:
j jump1
jump2:
jr $ra
jump1:
jal jump2

halt
