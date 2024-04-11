.data
.text
.globl main
main:


addiu $t0, $t0, 0x00000000 # check if it still works for unsinged numbers the out put should be 0x00000000
addiu $t1, $t1, 0xffffffff 
and $t2, $t0,$t1 

addiu $t3, $t3, 0x11111111 # check if it still works for unsiged numbers the out put should be 0x11111111
addiu $t4, $t4, 0xffffffff 
and $t5, $t3,$t4 

lui $zero, 0xffff
lui $t7, 0x0000 #check if lui the upper half words in $zero with and. the output should be 0x00000000
and $t6, $zero, $t5 

 #end program
   halt