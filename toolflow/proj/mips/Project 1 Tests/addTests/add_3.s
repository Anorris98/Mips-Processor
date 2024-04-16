# Test 3: Negative Operand Testing
# Description: Tests addition with negative operands

.data
operand1:   .word   -10
operand2:   .word   -15
result:     .word   0

.text
main:
    lw  $t0, operand1       # Load operand1
    lw  $t1, operand2       # Load operand2
    add $t2, $t0, $t1       # Perform addition
    sw  $t2, result         # Store result

halt
