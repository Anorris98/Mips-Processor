.data
.text
.globl main
main:
    # Start Test

ori $s0, $zero, 0xFFFF # making s0 FFFF
ori $s1, $zero, 0xFFFF # making s1 FFFF
addu $t0, $s0, $s1 #adding them together


  
    # End Test

    # Exit program
    halt
