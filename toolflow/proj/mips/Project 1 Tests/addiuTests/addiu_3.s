# Test 3
# This test case is where a large positive immedicate is added to a register 
addi $t0,$zero, 10000 # Setting $t0 with a large positive value
addiu $t1,$t0, 5000   # $t1 = $t0 + 5000
# The test make sure that the instruction can handle large immediate value
halt
