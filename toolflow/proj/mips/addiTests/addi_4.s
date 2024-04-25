.data
.text
.globl main
main:

# Start tests
addi $zero, $zero, 0x000F	# $zero not overwritten
addi $zero, $zero, 0x00EF	# $zero not overwritten
addi $zero, $zero, 0x0EEF	# $zero not overwritten

halt
