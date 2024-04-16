# Test 2: Overflow Testing
# Description: Tests addition with large operands to check overflow behavior

.data
operand1:   .word   2147483647   # Maximum positive value for a 32-bit signed integer
operand2:   .word   1            # Adding 1 to the maximum value should cause overflow
result:     .word   0

.text
main:
    lw  $t0, operand1       # Load operand1
    lw  $t1, operand2       # Load operand2
    add $t2, $t0, $t1       # Perform addition (potential overflow)
    sw  $t2, result         # Store result

halt
