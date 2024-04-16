.data
.text
.globl main
main:
    # Start Test
    # Testing a range of posotive and negative values
    
    addiu   $1, $0, -1	# Testing when $1 is less than the immediate
    slti  $2, $1, 0	# $2 should be set to 1
    
    addiu $1, $0, -32768 # Testing when $1 is less than the immediate
    slti  $3, $1, 32767  # $3 should be set to 1
    
    addiu $1, $0, 32767  # Testing when $1 is greater than the immediate
    slti  $4, $1, -32768 # $4 should be set to 0
    
    addiu $1, $0, -564	# Testing when $1 is less than the immediate
    slti  $5, $1, 1947	# $5 should be set to 1
    
    addiu $1, $0, 7894	# Testing when $1 is greater than the immediate
    slti  $6, $1, -2351	# $6 should be set to 0
    
    addiu $1, $0, -2145	# Testing when $1 is less than the immediate
    slti  $7, $1, 2582	# $7 should be set to 1
    
    # End Test
# Exit program
halt