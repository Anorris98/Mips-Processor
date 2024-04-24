.data
    array: .word 10, 20, 30, 40, 50   # Array of 5 32-bit words

.text
main:
    # Load base address of array into $s0
    la $1, array
    
    # Load word from memory into $t0 (Load the first element of the array)
    #test that when it the loaction without any offset it return a result of the first number.
    lw $2, 0($1)
    lw $3, 0($1)
    lw $4, 0($1)
    lw $5, 0($1)
    lw $6, 0($1)
    lw $7, 0($1)
    lw $8, 0($1)
    lw $9, 0($1)
    lw $10, 0($1)
    lw $11, 0($1)
    lw $12, 0($1)
    lw $13, 0($1)
    lw $14, 0($1)
    lw $15, 0($1)
    lw $16, 0($1)
    lw $17, 0($1)
    lw $18, 0($1)
    lw $19, 0($1)
    lw $20, 0($1)
    lw $21, 0($1)
    lw $22, 0($1)
    lw $23, 0($1)
    lw $24, 0($1)
    lw $25, 0($1)
    lw $26, 0($1)
    lw $27, 0($1)
    lw $28, 0($1)
    lw $29, 0($1)
     lw $30, 0($1)
    lw $31, 0($1)

halt

    
    
