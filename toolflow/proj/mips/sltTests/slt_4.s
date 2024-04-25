# Boundary Test Cases
.data
.text
.globl main
main:
    # Comparing a negative number with zero
    addi $t0, $zero, -1   # Set $t0 to -1. Expected output: $t0 = 0xFFFFFFFF
    slt  $t2, $t0, $zero  # Set $t2 to 1 since -1 is less than 0. Expected output: $t2 = 0x00000001

    # Comparing zero with a negative number
    slt  $t2, $zero, $t0  # Set $t2 to 0 since 0 is not less than -1. Expected output: $t2 = 0x00000000

    # Comparing the largest positive number with the smallest negative number
    lui  $t0, 0x7FFF      # Set $t0 to 32767. Expected output: $t0 = 0x7FFF0000
    addi $t1, $zero, -1   # Set $t1 to -1. Expected output: $t1 = 0xFFFFFFFF
    slt  $t2, $t0, $t1    # Set $t2 to 0 since 32767 is not less than -1. Expected output: $t2 = 0x00000000

    # Comparing the smallest negative number with the largest positive number
    slt  $t2, $t1, $t0    # Set $t2 to 1 since -1 is less than 32767. Expected output: $t2 = 0x00000001
    # End Test
    
    # End Program
    halt