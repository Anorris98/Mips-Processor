# negative values
# $t0 is initialized to 0xFFFFFFFF.  $t1 is initialized to 0x00000000.  A loop iterates $t1 down to 0xFFFFFFFF with an unsigned -1 operation.  Because $t0 and $t1 are equal, the loop iterates a second time, breaking the inequality.  Program should halt with the final values $t0 = 0xFFFFFFFF and $t1 = 0xFFFFFFFE.

lui $t0,0xFFFF
addi $t0,$t0,0xFFFF
add $t1, $zero, $zero
Loop:
addiu $t1, $t1, -1
beq $t0, $t1, Loop
halt