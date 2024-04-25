.data
.text
.globl main
main:
    # Start Test: We are mainly ensuring that this is an xor and not or, by having matching values in a row,
    # an or would remain the same but xor goes back to zeros
    xori $15, $0, 0x66      #66
    xori $16, $15, 0x66     #00
    xori $17, $16, 0x99     #99
    xori $18, $17, 0x99     #00
    xori $19, $18, 0x96     #96
    xori $20, $19, 0x96     #00
    xori $21, $20, 0x69     #69
    xori $22, $21, 0x69     #00

    # Exit program
    halt
