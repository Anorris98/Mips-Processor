.data 
array1: .word 0

.text 
la $t0, array1 #to get base memory address

#Test Case 2:
#This tests overwriting a memory address. In this case we saved 0xFFFF0000 into the base memory address of data (offset of 4).
#Next we save a new value of 0x0000FFFF in the same memory address, after doing this we see that the previous value of 0xFFFF0000
#was erased and saved with 0x0000FFFF.

addi $t1, $zero, 4294901760
sw $t1, 4($t0)
addi $t1, $zero, 65535
sw $t1, 4($t0)

halt
