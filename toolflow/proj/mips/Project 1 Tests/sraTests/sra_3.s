.data
.text
.globl main
main:
   addi $1, $0, 0xFEDCBA98 
   addi $2, $0, 0xFEDCBA98 
   addi $3, $0, 0xFEDCBA98 
   addi $4, $0, 0xFEDCBA98 
   addi $5, $0, 0xFEDCBA98 
   addi $6, $0, 0xFEDCBA98 
   addi $7, $0, 0xFEDCBA98 
   addi $8, $0, 0xFEDCBA98 
   addi $9, $0, 0xFEDCBA98 
   addi $10, $0, 0xFEDCBA98 
   addi $11, $0, 0xFEDCBA98 
   addi $12, $0, 0xFEDCBA98 
   addi $13, $0, 0xFEDCBA98 
   addi $14, $0, 0xFEDCBA98 
   addi $15, $0, 0xFEDCBA98 
   addi $16, $0, 0xFEDCBA98 
   addi $17, $0, 0xFEDCBA98 
   addi $18, $0, 0xFEDCBA98 
   addi $19, $0, 0xFEDCBA98 
   addi $20, $0, 0xFEDCBA98 
   addi $21, $0, 0xFEDCBA98 
   addi $22, $0, 0xFEDCBA98 
   addi $23, $0, 0xFEDCBA98 
   addi $24, $0, 0xFEDCBA98 
   addi $25, $0, 0xFEDCBA98 
   addi $26, $0, 0xFEDCBA98 
   addi $27, $0, 0xFEDCBA98 
   addi $28, $0, 0xFEDCBA98 
   addi $29, $0, 0xFEDCBA98 
   addi $30, $0, 0xFEDCBA98 
   addi $0, $0, 0xFEDCBA98
   # register 1 is initialized last as addi uses register 1 as a temporary register
   addi $1, $0, 0xFEDCBA98
   
   #Start test
   # each register will be right sifted 0 bits 
   # confrim that each register is 0x00000000
   sra $1, $1, 0
   sra $2, $2, 0
   sra $3, $3, 0
   sra $4, $4, 0
   sra $5, $5, 0
   sra $6, $6, 0
   sra $7, $7, 0
   sra $8, $8, 0
   sra $9, $9, 0
   sra $10, $10, 0
   sra $11, $11, 0
   sra $12, $12, 0
   sra $13, $13, 0
   sra $14, $14, 0
   sra $15, $15, 0
   sra $16, $16, 0
   sra $17, $17, 0
   sra $18, $18, 0
   sra $19, $19, 0
   sra $20, $20, 0
   sra $21, $21, 0
   sra $22, $22, 0
   sra $23, $23, 0
   sra $24, $24, 0
   sra $25, $25, 0
   sra $26, $26, 0
   sra $27, $27, 0
   sra $28, $28, 0
   sra $29, $29, 0
   sra $30, $30, 0
   sra $0, $0, 0
   #End test

   # Exit program
   halt
