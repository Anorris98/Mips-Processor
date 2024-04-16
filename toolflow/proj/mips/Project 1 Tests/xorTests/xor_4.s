.data
value1: .word 0x12345678
value2: .word 0x12345679

.text
.globl main
main:
    # This test the case in which two values are very similar, which may
    # result in unexpected logic in the event part of the XOR function
    # is not implemented correctly.
    # The reason for this is to ensure that XOR works on all values, not
    # just drastically different values

    lw $t0, value1 # Load value1 into $t0
    lw $t1, value2 # Load value2 into $t1
    
    # Test XOR with similar values
    xor $t2, $t0, $t1 # XOR $t0 and $t1, store in $t2

halt
