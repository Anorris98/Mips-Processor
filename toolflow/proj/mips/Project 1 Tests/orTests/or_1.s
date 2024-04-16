.data
.text
.globl main
main:
lui $8, 0xFF00 #initalize values to test with
addi $9, $0, 0xFFFFFF00 #initalize values to test with

or $10, $8, $9 #0x0000000F | 0xFFFFFFF0
#expected result 0xFFFFFF00 in $t2 
#this test should show that your or can do (0|1) , (0|0), and (1|1).
halt