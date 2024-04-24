.data
.text
.globl main
main:
    # Start Test
    # Basic OR operation
    # $t0 = 0x340F
    # $t1 = 0x8123
    # Expected $t2 = 0xB52F

    addi $t0, $t0, 0x340F
    addi $t1, $t1, 0x8123

    or $t2, $t0, $t1
    # End Test

    # Exit program
    halt