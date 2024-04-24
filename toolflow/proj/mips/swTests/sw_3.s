.data
.text
.globl main
main:
      # Start Test - Boundary Test
      # Explanation - I want to test the edge case of where values can be stored to, on MIPS there is a designated .data section so for this test it stores values from the beinning and end of the section
addi $t0, $0, 10
lui $s0, 0x1001
sw $t0, 0($s0)     # Stores 10 at beginning of .data memory location
addi $t0, $0, 20
lui $s0, 0x1003
ori $s0, $s0, 0xFFC # Largest word index = 0b1111_1111_1100
sw $t0, 0($s0)     # Stores 20 at the end of .data memory location

# End Test

    # Exit program
    halt
