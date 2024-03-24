.data
.text
.globl main
main:
    # Start Test
    # These tests also check to make sure that the left-most bits are filled w/0 because logical shift
    addi $1, $0, 0xFEDBCA98	# Initial register w/base testing value
    srl $2, $1, 0		# verify that 00 shift results in 0xFEDBCA98
    srl $2, $1, 1		# verify that 01 shift results in 0x7F6DE54C
    srl $2, $1, 2		# verify that 02 shift results in 0x3FB6F2A6
    srl $2, $1, 3		# verify that 03 shift results in 0x1FDB7953
    srl $2, $1, 4		# verify that 04 shift results in 0x0FEDBCA9
    srl $2, $1, 5		# verify that 05 shift results in 0x07F6DE54
    srl $2, $1, 6		# verify that 06 shift results in 0x03FB6F2A
    srl $2, $1, 7		# verify that 07 shift results in 0x01FDB795
    srl $2, $1, 8		# verify that 08 shift results in 0x00FEDBCA
    srl $2, $1, 9		# verify that 09 shift results in 0x007F6DE5
    srl $2, $1, 10		# verify that 10 shift results in 0x003FB6F2
    srl $2, $1, 11		# verify that 11 shift results in 0x001FDB79
    srl $2, $1, 12		# verify that 12 shift results in 0x000FEDBC
    srl $2, $1, 13		# verify that 13 shift results in 0x0007F6DE
    srl $2, $1, 14		# verify that 14 shift results in 0x0003FB6F
    srl $2, $1, 15		# verify that 15 shift results in 0x0001FDB7
    srl $2, $1, 16		# verify that 16 shift results in 0x0000FEDB
    srl $2, $1, 17		# verify that 17 shift results in 0x00007F6D
    srl $2, $1, 18		# verify that 18 shift results in 0x00003FB6
    srl $2, $1, 19		# verify that 19 shift results in 0x00001FDB
    srl $2, $1, 20		# verify that 20 shift results in 0x00000FED
    srl $2, $1, 21		# verify that 21 shift results in 0x000007F6
    srl $2, $1, 22		# verify that 22 shift results in 0x000003FB
    srl $2, $1, 23		# verify that 23 shift results in 0x000001FD
    srl $2, $1, 24		# verify that 24 shift results in 0x000000FE
    srl $2, $1, 25		# verify that 25 shift results in 0x0000007F
    srl $2, $1, 26		# verify that 26 shift results in 0x0000003F
    srl $2, $1, 27		# verify that 27 shift results in 0x0000001F
    srl $2, $1, 28		# verify that 28 shift results in 0x0000000F
    srl $2, $1, 29		# verify that 29 shift results in 0x00000007
    srl $2, $1, 30		# verify that 30 shift results in 0x00000003
    srl $2, $1, 31		# verify that 31 shift results in 0x00000001
    # End Test

    # Exit program
    halt
