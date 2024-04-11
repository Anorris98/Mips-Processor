# NOTE: Our processor assumes all registers initially have value 0x0,
#       but in MARS, $28 and $29 have initial, non-zero values.

# srl always pads with zeros. 
# Want to make sure that the srl function always pads zeros even in the case of a negative number to shift.


# Start test
addi $1, $1, 0xFFFFFFFF # Set the value of $1 to negative 1
addi $2, $2, 0xFFFFFFFF # Set the value of $2 to negative 1
addi $3, $3, 0xFFFFFFFF # Set the value of $3 to negative 1
addi $4, $4, 0xFFFFFFFF # Set the value of $4 to negative 1
addi $5, $5, 0xFFFFFFFF # Set the value of $5 to negative 1
addi $6, $6, 0xFFFFFFFF # Set the value of $6 to negative 1
addi $7, $7, 0xFFFFFFFF # Set the value of $7 to negative 1
addi $8, $8, 0xFFFFFFFF # Set the value of $8 to negative 1
addi $9, $9, 0xFFFFFFFF # Set the value of $9 to negative 1
addi $10, $10, 0xFFFFFFFF # Set the value of $10 to negative 1
addi $11, $11, 0xFFFFFFFF # Set the value of $11 to negative 1
addi $12, $12, 0xFFFFFFFF # Set the value of $12 to negative 1
addi $13, $13, 0xFFFFFFFF # Set the value of $13 to negative 1
addi $14, $14, 0xFFFFFFFF # Set the value of $14 to negative 1
addi $15, $15, 0xFFFFFFFF # Set the value of $15 to negative 1
addi $16, $16, 0xFFFFFFFF # Set the value of $16 to negative 1
addi $17, $17, 0xFFFFFFFF # Set the value of $17 to negative 1
addi $18, $18, 0xFFFFFFFF # Set the value of $18 to negative 1
addi $19, $19, 0xFFFFFFFF # Set the value of $19 to negative 1
addi $20, $20, 0xFFFFFFFF # Set the value of $20 to negative 1
addi $21, $21, 0xFFFFFFFF # Set the value of $21 to negative 1
addi $22, $22, 0xFFFFFFFF # Set the value of $22 to negative 1
addi $23, $23, 0xFFFFFFFF # Set the value of $23 to negative 1
addi $24, $24, 0xFFFFFFFF # Set the value of $24 to negative 1
addi $25, $25, 0xFFFFFFFF # Set the value of $25 to negative 1
addi $26, $26, 0xFFFFFFFF # Set the value of $26 to negative 1
addi $27, $27, 0xFFFFFFFF # Set the value of $27 to negative 1
addi $28, $0, 0xFFFFFFFF # Set the value of $28 to negative 1
addi $29, $0, 0xFFFFFFFF # Set the value of $29 to negative 1
addi $30, $30, 0xFFFFFFFF # Set the value of $30 to negative 1
addi $31, $31, 0xFFFFFFFF # Set the value of $31 to negative 1

#Shift the values
srl $1, $1, 8		#shift by 8 bits
srl $1, $1, 16		#shift by 16 bits

srl $2, $2, 8		#shift by 8 bits
srl $2, $2, 16		#shift by 16 bits

srl $3, $3, 8		#shift by 8 bits
srl $3, $3, 16		#shift by 16 bits

srl $4, $4, 8		#shift by 8 bits
srl $4, $4, 16		#shift by 16 bits

srl $5, $5, 8		#shift by 8 bits
srl $5, $5, 16		#shift by 16 bits

srl $6, $6, 8		#shift by 8 bits
srl $6, $6, 16		#shift by 16 bits

srl $7, $7, 8		#shift by 8 bits
srl $7, $7, 16		#shift by 16 bits

srl $8, $8, 8		#shift by 8 bits
srl $8, $8, 16		#shift by 16 bits

srl $9, $9, 8		#shift by 8 bits
srl $9, $9, 16		#shift by 16 bits

srl $10, $10, 8		#shift by 8 bits
srl $10, $10, 16	#shift by 16 bits

srl $11, $11, 8		#shift by 8 bits
srl $11, $11, 16	#shift by 16 bits

srl $12, $12, 8		#shift by 8 bits
srl $12, $12, 16	#shift by 16 bits

srl $13, $13, 8		#shift by 8 bits
srl $13, $13, 16	#shift by 16 bits

srl $14, $14, 8		#shift by 8 bits
srl $14, $14, 16	#shift by 16 bits

srl $15, $15, 8		#shift by 8 bits
srl $15, $15, 16	#shift by 16 bits

srl $16, $16, 8		#shift by 8 bits
srl $16, $16, 16	#shift by 16 bits

srl $17, $17, 8		#shift by 8 bits
srl $17, $17, 16	#shift by 16 bits

srl $18, $18, 8		#shift by 8 bits
srl $18, $18, 16	#shift by 16 bits

srl $19, $19, 8		#shift by 8 bits
srl $19, $19, 16	#shift by 16 bits

srl $20, $20, 8		#shift by 8 bits
srl $20, $20, 16	#shift by 16 bits

srl $21, $21, 8		#shift by 8 bits
srl $21, $21, 16	#shift by 16 bits

srl $22, $22, 8		#shift by 8 bits
srl $22, $22, 16	#shift by 16 bits

srl $23, $23, 8		#shift by 8 bits
srl $23, $23, 16	#shift by 16 bits

srl $24, $24, 8		#shift by 8 bits
srl $24, $24, 16	#shift by 16 bits

srl $25, $25, 8		#shift by 8 bits
srl $25, $25, 16	#shift by 16 bits

srl $26, $26, 8		#shift by 8 bits
srl $26, $26, 16	#shift by 16 bits

srl $27, $27, 8		#shift by 8 bits
srl $27, $27, 16	#shift by 16 bits

srl $28, $28, 8		#shift by 8 bits
srl $28, $28, 16	#shift by 16 bits

srl $29, $29, 8		#shift by 8 bits
srl $29, $29, 16	#shift by 16 bits

srl $30, $30, 8		#shift by 8 bits
srl $30, $30, 16	#shift by 16 bits

srl $31, $31, 8		#shift by 8 bits
srl $31, $31, 16	#shift by 16 bits


# End Program
halt
