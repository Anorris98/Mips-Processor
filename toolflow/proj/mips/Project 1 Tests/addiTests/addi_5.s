.data
.text
.globl main
main:

# Testing if addi works for every bit 
addi $4, $zero, 0		# Test for 0 + 0 = 0 
addi $5, $zero, 1		# Test for 0 + 1 = 0b1 
addi $6, $zero, 3		# Test for 0 + 3 = 0b11 
addi $7, $zero, 7		# Test for 0 + 7 = 0b111
addi $8, $zero, 15		# Test for 0 + 15 = 0b1111
addi $9, $zero, 31		# Test for 0 + 31 = 0b1_1111
addi $10, $zero, 63		# Test for 0 + 63 = 0b11_1111
addi $11, $zero, 127		# Test for 0 + 127 = 0b111_1111	
addi $12, $zero, 255		# Test for 0 + 255 = 0b1111_1111
addi $13, $zero, 511		# Test for 0 + 511 = 0b1_1111_1111
addi $14, $zero, 1023		# Test for 0 + 1023 = 0b11_1111_1111 
addi $15, $zero, 2047		# Test for 0 + 2047 = 0b111_1111_1111 
addi $16, $zero, 4095		# Test for 0 + 4095 = 0b1111_1111_1111
addi $17, $zero, 8191		# Test for 0 + 8191 = 0b1_1111_1111_1111
addi $18, $zero, 16383		# Test for 0 + 16383 = 0b11_1111_1111_1111
addi $19, $zero, 32767		# Test for 0 + 32767 = 0b111_1111_1111_1111

halt
