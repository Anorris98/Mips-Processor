.data
.text
.globl main
main:
      # Start Test - Coping over value at same memory location
      # Explanation - Common case test that checks to make sure that values being stored at the same memory location gets overridden
addi $t0, $0, 10   
lui $s0, 0x1001
sw $t0, 0($s0)     # Stores 10
addi $t1, $0, 20
sw $t1, 0($s0)     # Stores 20
addi $t2, $0, 30
sw $t2, 0($s0)     # Stores 30
addi $t3, $0, 40
sw $t3, 0($s0)     # Stores 40
addi $t4, $0, 500
sw $t4, 0($s0)     # Stores 500

# End Test

    # Exit program
    halt
