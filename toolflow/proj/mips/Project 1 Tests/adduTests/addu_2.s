# addu is add unsigned, meaning add two registers without overflow and place the result in another register.
# I can use addi, lui, and addiu.
# create overflow by adding the largest possible int, 4294967295, with 1. I expect 0, since this
# should overflow all the bits to 0 and have a carry-out bit of 1.
.data
.text
.globl main
main:
addi $t0, $zero, 4294967295
addi $t1, $zero, 1

addu $t2, $t0, $t1

halt
