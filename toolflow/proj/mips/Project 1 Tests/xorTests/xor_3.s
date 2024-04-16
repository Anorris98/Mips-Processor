    .data
a: .word 0xFFFFFFFF
result: .word 0

    .text
    .globl main
main:
    # This test case tests in the event that we are doing the max value
    # The reason for this is because we dont want it to cause any overflows
    # or errors with the xor function that cause unexpected values

    # Load maximum value into register
    addi $t0, $zero, -1 # $t0 = 0xFFFFFFFF
    
    # Perform XOR with maximum value
    xor $t1, $t0, $t0   # $t1 = $t0 XOR $t0
    # $t1 = 0

halt
