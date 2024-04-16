.data
.text
.globl main
main:
    # Start Test
    # Testing a range of negative values
    
    addiu  $1, $0, -100	# Testing when $1 is less than the immediate
    slti  $2, $1, -10	# $2 should be set to 1
    
    addiu $1, $0, -37	# Testing when $1 is less than the immediate
    slti  $3, $1, -12	# $3 should be set to 1
    
    addiu $1, $0, -45	# Testing when $1 is greater than the immediate
    slti  $4, $1, -55	# $4 should be set to 0
    
    addiu $1, $0, -70	# Testing when $1 is greater than the immediate
    slti  $5, $1, -4432	# $5 should be set to 0
    
    addiu $1, $0, -7896	# Testing when $1 is equal to the immediate
    slti  $6, $1, -7896	# $6 should be set to 0
    
    addiu $1, $0, -79	# Testing when $1 is equal to the immediate
    slti  $7, $1, -79	# $7 should be set to 0
    
    # End Test
# Exit program
halt