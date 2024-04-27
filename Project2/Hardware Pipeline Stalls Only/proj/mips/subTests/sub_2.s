.data
.text
.globl main
main:
	
	# It covers the commen case of subtracting two negative numbers.
	# we should be properly subtracting -8 - -3  and setting $t2 equal to the result of -5

    	# Start Test
	addi $t3, $zero, -8   # $t3 = -8
	addi $t4, $zero, -3   # $t4 = -3
	# $t5 = $t3 - $t4 = -8 - (-3) = -8 + 3 = -5
	sub $t5, $t3, $t4     # Subtract $t4 from $t3 and store the result in $t5
    	# End Test

    	# Exit program
    	halt
