.data
.text
.globl main
main:
    # Start Test

lui $t0, 0 #setting t0 to 0
ori $t0, $t1, 0xFFFF #making t0 FFFF

  
    # End Test

    # Exit program
    halt
