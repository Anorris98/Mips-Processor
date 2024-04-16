# simple common case
# a loop is created where $t0 and $t1 are equal to each other.  because they are equal, beq runs the loop again, iterating $t0, breaking the equality.  the final register values should be $t0 = 2 and $t1 = 1.

addi $t0, $zero, 0
addi $t1, $zero, 1
Loop:
addi $t0, $t0, 1
beq $t0, $t1, Loop
halt


