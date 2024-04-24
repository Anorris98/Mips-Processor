.data
.text
.globl main
main:
    # Start Test We increment by 1 in this kinda pattern 0x00000001, then xori 0x00000010, then xori 0x00000100....
    # This is a basic test of 0 and 1 equally 1 in both directions
    xori $15, $0, 0x01      #1
    xori $16, $15, 0x02     #3
    xori $17, $16, 0x04     #7
    xori $18, $17, 0x08     #f
    xori $19, $18, 0x10     #1f
    xori $20, $19, 0x20     #3f
    xori $21, $20, 0x40     #7f
    xori $22, $21, 0x80     #ff

    # Exit program
    halt
