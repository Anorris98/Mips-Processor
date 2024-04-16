.data
.text
.globl main
main:
    # Start Test
    # OR with 0 
    # $t0 = 0x340F
    # $t1 = 0x0000
    # Expected $t2 = 0x340F

    addi $t0, $t0, 0x340F
    addi $t1, $t1, 0x0000

    or $t2, $t0, $t1
    # End Test

    # Exit program
    halt