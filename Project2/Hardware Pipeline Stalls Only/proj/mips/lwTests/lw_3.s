.data
    array: .word 10, 20, 30, 40, 50   # Array of 5 32-bit words
    array2: .word 10, 20, 30, 40, 50   # Array of 5 32-bit words

.text
main:
    # Load base address of array into $s0
    la $2, array
    la $1, array2
 
    #test that the negative offset works
    lw $3, -4($1)
    lw $4, -4($1)
    lw $5, -4($1)
    lw $6, -4($1)
    lw $7, -4($1)
    lw $8, -4($1)
    lw $9, -4($1)
    lw $10, -4($1)
    lw $11, -4($1)
    lw $12, -4($1)
    lw $13, -4($1)
    lw $14, -4($1)
    lw $15, -4($1)
    lw $16, -4($1)
    lw $17, -4($1)
    lw $18, -4($1)
    lw $19, -4($1)
    lw $20, -4($1)
    lw $21, -4($1)
    lw $22, -4($1)
    lw $23, -4($1)
    lw $24, -4($1)
    lw $25, -4($1)
    lw $26, -4($1)
    lw $27, -4($1)
    lw $28, -4($1)
    lw $29, -4($1)
     lw $30, -4($1)
    lw $31, -4($1)

halt
