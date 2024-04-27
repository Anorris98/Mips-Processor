# Test 1
# This test case is where an immediate vaule is added to a register
addi $t0, $zero, 5 # $t0 = 5
addiu $t1, $t0, 7  # $t1 = $t0 + 7
# This test ensures that the instruction operates correctly under normal circumstances 
halt
