
  addi $1, $0, -1
  addi $2, $0, -2
  addi $3, $0, -3
  addi $4, $0, -4
  addi $5, $0, -5
  addi $6, $0, -6
  addi $7, $0, -7
  addi $8, $0, -8
 
  ## andi of most significant bit being 1 and 0
 
  andi $1, $1, 7	## 4 bit negative (-1) anded with 4 bit postive value (7), outputs 7
  andi $2, $2, 7	## 4 bit negative (-2) anded with 4 bit postive value (7), outputs 6
  andi $3, $3, 7	## 4 bit negative (-3) anded with 4 bit postive value (7), outputs 5
  andi $4, $4, 7	## 4 bit negative (-4) anded with 4 bit postive value (7), outputs 4
  andi $5, $5, 7	## 4 bit negative (-5) anded with 4 bit postive value (7), outputs 3
  andi $6, $6, 7	## 4 bit negative (-6) anded with 4 bit postive value (7), outputs 2
  andi $7, $7, 7	## 4 bit negative (-7) anded with 4 bit postive value (7), outputs 1
  andi $8, $8, 7	## 4 bit negative (-8) anded with 4 bit postive value (7), outputs 0

halt
