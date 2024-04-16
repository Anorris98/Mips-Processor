.data
.text
.globl main
main:
	
	# It covers a case of subtracting a positive number from a negative number.
	# we should be properly subtracting 15 - -6  and setting $t2 equal to the result of 21

    	# Start Test
	addi $s4, $zero, 15  # $t6 = 15
	addi $s5, $zero, -6    # $t7 = -6
	# $t8 = $t6 - $t7 = 15 - -6 = 21
	sub $s6, $s4, $s5     # Subtract $s5 from $s4 and store the result in $s6
    	# End Test

    	# Exit program
    	halt
