.data
.text
.globl main
main:

addi $t0, $t0,0x7fffffff #check for overflow output should be 0x00000000
addi $t1,$t1, 0x80000000 
and $t9, $t0, $t1

addi $t3, $t3,0x12345678 #check for differnt  patterns. the output should be 0x02044678
addi $t2,$t2, 0xABCDEFFF
and $t9, $t3, $t2

addi $t4 , $t4, 0xffffffff # ceck for negative and the output should be 0x80000000
addi $t5, $t5 , 0x80000000
and $t7, $t4, $t5

halt
