  addi $1, $0, 500
  addi $2, $0, 500
  addi $3, $0, 500
  addi $4, $0, 500

  ## andi of 500 and 0 to check if clearing registers works
 
  andi $1, $0, 0	## clearing register 1
  andi $2, $0, 0	## clearing register 2
  andi $3, $0, 0	## clearing register 3
  andi $4, $0, 0	## clearing register 4

halt
