.data
.text
.globl main
main:
    # Start Test

ori $s0, $zero, 0x5 # making s0 5
ori $s1, $zero, 0x7 # making s1 7
addu $t0, $s0, $s1 #adding them together

  
    # End Test

    # Exit program
    halt
