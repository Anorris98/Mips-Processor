.data
.text
.globl main
main:
	
	# It subtracts two positive numbers and verifies the result.
	# we should be properly subtracting 10 - 5 and setting $t2 equal to the result of 5

    	# Start Test
    	addi $t0, $zero, 10   # Load 10 into $t0
	addi $t1, $zero, 5    # Load 5 into $t1
	# $t2 = $t0 - $t1 = 10 - 5 = 5
    	sub $t2, $t0, $t1     # Subtract $t1 from $t0 and store the result in $t2
    	# End Test

    	# Exit program
    	halt
