  addi $1, $0, 1920
  addi $2, $0, 8100
  addi $3, $0, 4
  addi $4, $0, 500
  addi $5, $0, 1000
  
  ## andi of random values with 1000 to verify correct outputs
 
  andi $1, $1, 1000	## outputs 0x00000380
  andi $2, $2, 1000	## outputs 0x000003a0
  andi $3, $3, 1000	## outputs 0x00000000
  andi $4, $4, 1000	## outputs 0x000001e0
  andi $5, $5, 1000	## outputs 0x000003e8

halt
