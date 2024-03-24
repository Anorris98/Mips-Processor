.data
.text
.globl main
main:
    # Start Test (max out shift)
    lui $t0, 0xABCD  #initial $t0 value
    ori $t0, $t0, 0xEF01  #initial $t0 value
    sra $t1, $t0, 31     # Should shift and fill in all values of $t1 with ones. 
    # End Test

    # Exit program
    halt
