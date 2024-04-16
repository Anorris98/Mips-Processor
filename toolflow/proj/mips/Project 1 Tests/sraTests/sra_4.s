.data
.text
.globl main
main:
    # Start Test (shift a negative signed data value)
    lui $t0, 0xABCD  #initial $t0 value
    ori $t0, $t0, 0xEF01  #initial $t0 value
    sra $t1, $t0, 2     # verify that one can shift a register value with '1' in signed value. shift by 2.
    sra $t1, $t0, 4     # verify that one can shift a register value with '1' in signed value. shift by 4. 
    # End Test

    # Exit program
    halt
