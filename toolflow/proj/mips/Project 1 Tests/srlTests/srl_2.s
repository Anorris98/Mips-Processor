# Testing what happens if you shift each of the registers by various amounts
#This test case is just to make sure that the registers shift approriatly with various common shift values.

# Start Test
# Load arbitray values
addi $1, $1, 0x12345678 # Set the value of $1 to negative 1
addi $2, $2, 0x12345678 # Set the value of $2 to negative 1
addi $3, $3, 0x12345678 # Set the value of $3 to negative 1
addi $4, $4, 0x12345678 # Set the value of $4 to negative 1
addi $5, $5, 0x12345678 # Set the value of $5 to negative 1
addi $6, $6, 0x12345678 # Set the value of $6 to negative 1
addi $7, $7, 0x12345678 # Set the value of $7 to negative 1
addi $8, $8, 0x12345678 # Set the value of $8 to negative 1
addi $9, $9, 0x12345678 # Set the value of $9 to negative 1
addi $10, $10, 0x12345678 # Set the value of $10 to negative 1
addi $11, $11, 0x12345678 # Set the value of $11 to negative 1
addi $12, $12, 0x12345678 # Set the value of $12 to negative 1
addi $13, $13, 0x12345678 # Set the value of $13 to negative 1
addi $14, $14, 0x12345678 # Set the value of $14 to negative 1
addi $15, $15, 0x12345678 # Set the value of $15 to negative 1
addi $16, $16, 0x12345678 # Set the value of $16 to negative 1
addi $17, $17, 0x12345678 # Set the value of $17 to negative 1
addi $18, $18, 0x12345678 # Set the value of $18 to negative 1
addi $19, $19, 0x12345678 # Set the value of $19 to negative 1
addi $20, $20, 0x12345678 # Set the value of $20 to negative 1
addi $21, $21, 0x12345678 # Set the value of $21 to negative 1
addi $22, $22, 0x12345678 # Set the value of $22 to negative 1
addi $23, $23, 0x12345678 # Set the value of $23 to negative 1
addi $24, $24, 0x12345678 # Set the value of $24 to negative 1
addi $25, $25, 0x12345678 # Set the value of $25 to negative 1
addi $26, $26, 0x12345678 # Set the value of $26 to negative 1
addi $27, $27, 0x12345678 # Set the value of $26 to negative 1


#Shift registers by various amounts
srl $1, $1, 1		#shift by 1 bit
srl $1, $1, 2		#shift by 2 bits
srl $1, $1, 4		#shift by 4 bits
srl $1, $1, 8		#shift by 8 bits
srl $1, $1, 16		#shift by 16 bits

srl $2, $2, 1		#shift by 1 bit
srl $2, $2, 2		#shift by 2 bits
srl $2, $2, 4		#shift by 4 bits
srl $2, $2, 8		#shift by 8 bits
srl $2, $2, 16		#shift by 16 bits

srl $3, $3, 1		#shift by 1 bit
srl $3, $3, 2		#shift by 2 bits
srl $3, $3, 4		#shift by 4 bits
srl $3, $3, 8		#shift by 8 bits
srl $3, $3, 16		#shift by 16 bits

srl $4, $4, 1		#shift by 1 bit
srl $4, $4, 2		#shift by 2 bits
srl $4, $4, 4		#shift by 4 bits
srl $4, $4, 8		#shift by 8 bits
srl $4, $4, 16		#shift by 16 bits

srl $5, $5, 1		#shift by 1 bit
srl $5, $5, 2		#shift by 2 bits
srl $5, $5, 4		#shift by 4 bits
srl $5, $5, 8		#shift by 8 bits
srl $5, $5, 16		#shift by 16 bits

srl $6, $6, 1		#shift by 1 bit
srl $6, $6, 2		#shift by 2 bits
srl $6, $6, 4		#shift by 4 bits
srl $6, $6, 8		#shift by 8 bits
srl $6, $6, 16		#shift by 16 bits

srl $7, $7, 1		#shift by 1 bit
srl $7, $7, 2		#shift by 2 bits
srl $7, $7, 4		#shift by 4 bits
srl $7, $7, 8		#shift by 8 bits
srl $7, $7, 16		#shift by 16 bits

srl $8, $8, 1		#shift by 1 bit
srl $8, $8, 2		#shift by 2 bits
srl $8, $8, 4		#shift by 4 bits
srl $8, $8, 8		#shift by 8 bits
srl $8, $8, 16		#shift by 16 bits

srl $9, $9, 1		#shift by 1 bit
srl $9, $9, 2		#shift by 2 bits
srl $9, $9, 4		#shift by 4 bits
srl $9, $9, 8		#shift by 8 bits
srl $9, $9, 16		#shift by 16 bits

srl $10, $10, 1		#shift by 1 bit
srl $10, $10, 2		#shift by 2 bits
srl $10, $10, 4		#shift by 4 bits
srl $10, $10, 8		#shift by 8 bits
srl $10, $10, 16		#shift by 16 bits

srl $11, $11, 1		#shift by 1 bit
srl $11, $11, 2		#shift by 2 bits
srl $11, $11, 4		#shift by 4 bits
srl $11, $11, 8		#shift by 8 bits
srl $11, $11, 16		#shift by 16 bits

srl $12, $12, 1		#shift by 1 bit
srl $12, $12, 2		#shift by 2 bits
srl $12, $12, 4		#shift by 4 bits
srl $12, $12, 8		#shift by 8 bits
srl $12, $12, 16		#shift by 16 bits

srl $13, $13, 1		#shift by 1 bit
srl $13, $13, 2		#shift by 2 bits
srl $13, $13, 4		#shift by 4 bits
srl $13, $13, 8		#shift by 8 bits
srl $13, $13, 16		#shift by 16 bits

srl $14, $14, 1		#shift by 1 bit
srl $14, $14, 2		#shift by 2 bits
srl $14, $14, 4		#shift by 4 bits
srl $14, $14, 8		#shift by 8 bits
srl $14, $14, 16		#shift by 16 bits

srl $15, $15, 1		#shift by 1 bit
srl $15, $15, 2		#shift by 2 bits
srl $15, $15, 4		#shift by 4 bits
srl $15, $15, 8		#shift by 8 bits
srl $15, $15, 16		#shift by 16 bits

srl $16, $16, 1		#shift by 1 bit
srl $16, $16, 2		#shift by 2 bits
srl $16, $16, 4		#shift by 4 bits
srl $16, $16, 8		#shift by 8 bits
srl $16, $16, 16		#shift by 16 bits

srl $17, $17, 1		#shift by 1 bit
srl $17, $17, 2		#shift by 2 bits
srl $17, $17, 4		#shift by 4 bits
srl $17, $17, 8		#shift by 8 bits
srl $17, $17, 16		#shift by 16 bits

srl $18, $18, 1		#shift by 1 bit
srl $18, $18, 2		#shift by 2 bits
srl $18, $18, 4		#shift by 4 bits
srl $18, $18, 8		#shift by 8 bits
srl $18, $18, 16		#shift by 16 bits

srl $19, $19, 1		#shift by 1 bit
srl $19, $19, 2		#shift by 2 bits
srl $19, $19, 4		#shift by 4 bits
srl $19, $19, 8		#shift by 8 bits
srl $19, $19, 16		#shift by 16 bits

srl $20, $20, 1		#shift by 1 bit
srl $20, $20, 2		#shift by 2 bits
srl $20, $20, 4		#shift by 4 bits
srl $20, $20, 8		#shift by 8 bits
srl $20, $20, 16		#shift by 16 bits

srl $21, $21, 1		#shift by 1 bit
srl $21, $21, 2		#shift by 2 bits
srl $21, $21, 4		#shift by 4 bits
srl $21, $21, 8		#shift by 8 bits
srl $21, $21, 16		#shift by 16 bits

srl $22, $22, 1		#shift by 1 bit
srl $22, $22, 2		#shift by 2 bits
srl $22, $22, 4		#shift by 4 bits
srl $22, $22, 8		#shift by 8 bits
srl $22, $22, 16		#shift by 16 bits

srl $23, $23, 1		#shift by 1 bit
srl $23, $23, 2		#shift by 2 bits
srl $23, $23, 4		#shift by 4 bits
srl $23, $23, 8		#shift by 8 bits
srl $23, $23, 16		#shift by 16 bits

srl $24, $24, 1		#shift by 1 bit
srl $24, $24, 2		#shift by 2 bits
srl $24, $24, 4		#shift by 4 bits
srl $24, $24, 8		#shift by 8 bits
srl $24, $24, 16		#shift by 16 bits

srl $25, $25, 1		#shift by 1 bit
srl $25, $25, 2		#shift by 2 bits
srl $25, $25, 4		#shift by 4 bits
srl $25, $25, 8		#shift by 8 bits
srl $25, $25, 16		#shift by 16 bits

srl $26, $26, 1		#shift by 1 bit
srl $26, $26, 2		#shift by 2 bits
srl $26, $26, 4		#shift by 4 bits
srl $26, $26, 8		#shift by 8 bits
srl $26, $26, 16		#shift by 16 bits

srl $27, $27, 1		#shift by 1 bit
srl $27, $27, 2		#shift by 2 bits
srl $27, $27, 4		#shift by 4 bits
srl $27, $27, 8		#shift by 8 bits
srl $27, $27, 16		#shift by 16 bits

# End Program 
halt