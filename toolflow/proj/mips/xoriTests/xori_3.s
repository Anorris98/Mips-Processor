.data
.text
.globl main
main:
    # Start Test: We are mainly ensuring that this is an xor and not or, by having matching values in a row,
    # an or would remain the same but xor goes back to zeros
    xori $15, $0, 0xFFFF      #FFFF
    xori $16, $15, 0xFFFF     #0000
    xori $17, $16, 0xF0F0     #F0F0
    xori $18, $17, 0x0F0F     #FFFF
    xori $19, $18, 0xFFFF     #0000
    xori $20, $19, 0x0000     #0000
    xori $21, $20, 0xFF00     #FF00
    xori $22, $21, 0x00FF     #FFFF

    # Exit program
    halt
