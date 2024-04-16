.data
.text
.globl main
main:
    #Start Test - Storing values at different offsets 
    # Explanation - Common Test and edge case of the offset value for sw so I have the smallest offset value and highest offset value 
    addi $t0, $t0, 1       # Value 1
    lui $s0, 0x1001
    sw $t0, 0($s0)
    addi $t1, $0, 2        # Value 2
    sw $t1, 4($s0)
    addi $t2, $0, 3        # Value 3
    sw $t2, 8($s0)
    addi $t3, $0, 4        # Value 4
    sw $t3, 12($s0)
    addi $t4, $0, 5        # Value 5
    sw $t4, 0($s0)    # Stores at smallest offset value (0x10008000 with $s0=0x10010000)
    addi $t5, $0, 6        # Value 6
    sw $t5, 4092($s0)     # Stores at smallest offset value (0x10017ffc with $s0=0x10010000)
    
    # End Test

    # Exit program
    halt
