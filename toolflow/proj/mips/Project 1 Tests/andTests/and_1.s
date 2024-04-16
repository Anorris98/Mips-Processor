.data
.text
.globl main
main:
addi $0, $0, 0xAAAAAAAA # makesure register zero is still zero when and
addi $s1, $s1, 0x55555555
and $t0, $0, $s1

addi $s2, $s2, 0xAAAAAAAA # basic test for anding 1 and 0  for and out put should be 0x000000000
addi $s3, $s3, 0x55555555
and $s0, $s2,$s3


addi $s4, $s4, 0xAAAAAAAA # basic test for andin  1 and 1 out put should be 0xaaaaaaaa
addi $s5, $s5, 0xAAAAAAAA
and $s0, $s4,$s5

 #end program
   halt
