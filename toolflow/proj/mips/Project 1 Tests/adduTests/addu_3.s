# addu is add unsigned, meaning add two registers without overflow and place the result in another register.
# I can use addi, lui, and addiu.
# Ensure this command does not write to the zero register
.data
.text
.globl main
main:

addi $t0, $zero, 27
addi $t1, $zero, 953
addu $zero, $t0, $t1

halt
