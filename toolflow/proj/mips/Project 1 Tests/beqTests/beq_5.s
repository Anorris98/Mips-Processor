# jumping works correctly
# I'm not sure what else to test, so how about whether jumping works both forward and backward?  Previous tests jumped backwards in the program, this test will jump forward.  Final values should be $t0 = 0x0000FF00 and $t1 = 0x0000FF00.  Test has failed if $t0 = 1.

addi $t0, $zero, 0xFF00
addi $t1, $zero, 0xFF00
beq $t0, $t1, Skip
addi $t0, $zero, 1
Skip:
halt