.data 
array1: .word 0

.text 
la $t0, array1 #to get base memory address

#Test Case 3:
#(1) Save a value in an address with an offset, then save another value inside of a another address.(2) Replace the orignial registers with
# the value from the other memory address.(3) Now save again to the orignial address in the first part. This test case shows that 
#you can swap memory locations of different values using a technique such as this.


addi $t1, $zero, 4208906240
addi $t2, $zero, 3737841664

#(1)
sw $t1, 32($t0)
sw $t2, 64($t0)

#(2)
lw $t1, 64($t0)
lw $t2, 32($t0)

#(3)
sw $t1, 32($t0)
sw $t2, 64($t0)

halt
