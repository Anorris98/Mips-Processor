# Tests larger numbers and saving back to the read registers

addi $a0, $0, 0xffffffff
addi $a1, $0, 0x11111111


andi $s0, $a0, 0x12345678			
andi $t0, $a1, 0x12345678
andi $a0, $a0, 0x00000000 
andi $a1, $a1, 0xeeeeeeee

# Expected results:
# $s0 = 0x12345678
# $t0 = 0x10101010
# $a0 = 0x00000000
# $a1 = 0x00000000

halt
