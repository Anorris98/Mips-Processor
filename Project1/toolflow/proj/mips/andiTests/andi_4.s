# Tests basic cases

addi $a0, $0, 15
addi $t0, $0, 10

andi $s0, $a0, 15	# 1111 & 1111 = 1111			
andi $s1, $t0, 15	# 1010 & 1111 = 1010
andi $s2, $t0, 5 	# 1010 & 0101 = 0000
andi $s3, $a0, 0	# 1111 & 0000 = 0000	

# Expected results:
# $s0 = 0x0000000f
# $s1 = 0x0000000a
# $s2 = 0x00000000
# $s3 = 0x00000000

halt
