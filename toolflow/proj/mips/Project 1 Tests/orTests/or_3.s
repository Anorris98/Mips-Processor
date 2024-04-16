.data
.text
.globl main
main:
lui $8, 0xFFFF #load $t0 with 0xFFFF
or $0, $8, $0 #$8 or $0 stored in $0
#expected result should be 0x00000000
#your or function should not overwrite $0 as 
#that register is always 0x00000000
halt 