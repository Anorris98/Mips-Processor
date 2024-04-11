    .data
a: .word 0x1234
b: .word 0x5678
result: .word 0

    .text
    .globl main
main:
    # This test just test the generic ability for XOR to work correctly

    # Load values
    lw $t0, a
    lw $t1, b
    
    # Testing XOR - Generic
    xor $t2, $t0, $t1 # $t2 = $t0 XOR $t1

halt
