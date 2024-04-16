# addu is add unsigned, meaning add two registers without overflow and place the result in another register.
# I can use addi, lui, and addiu.
# This test: add two negative numbers. It should be -4. Unsigned addition of the 2's complements stored in the registers
# is the same thing an adder does when it adds immediate values.
.data
.text
.globl main
main:

# first, load two negative values into registers
addi $t0, $zero, -1
addi $t1, $zero, -3
addu $t2, $t0, $t1 # expect -4

halt
