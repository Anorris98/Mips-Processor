# Test 2
# This test case will add an immedicate value which will result in a overflow
addi $t0, $zero, 4294967293 # set $t0 with a value that is close to max unsign value
addiu $t1, $t0, 5	    # $t1 = $t0 + 5 (overflow occurs)
# This test make sure that the processor handles overflow correctly 
halt
