.data
.text
.globl main
main:

    # Any bit position can be achieved by anding a combination of these values
    # Only implementing for the lower half-word of the register

    # Start Test
    addi $t0, $0, 0x00FF # Low Byte
    addi $t1, $0, 0xFF00 # High Byte 
    addi $t2, $0, 0x0F0F # Low Nibble
    addi $t3, $0, 0xF0F0 # High Nibble
    addi $t4, $0, 0x3333 # Low Pair     0x3 = 0b0011
    addi $t5, $0, 0xCCCC # High Pair    0xC = 0b1100
    addi $t6, $0, 0x5555 # Low Bit      0x5 = 0b0101
    addi $t7, $0, 0xAAAA # High Bit     0xA = 0b1010
    
    and $t8, $t0, $t2 # Take from the low bytes only the low nibble 
    and $t8, $t8, $t4 # Take the low pair
    and $t8, $t8, $t6 # Take the low bit
    # Result: $t8 = 0x0001


    and $t8, $t0, $t2 # Take from the low bytes only the low nibble 
    and $t8, $t8, $t4 # Take the low pair
    and $t8, $t8, $t7 # Take the high bit
    # Result: $t8 = 0x0002


    and $t8, $t0, $t2 # Take from the low bytes only the low nibble 
    and $t8, $t8, $t5 # Take the high pair
    and $t8, $t8, $t6 # Take the low bit
    # Result: $t8 = 0x0004


    and $t8, $t0, $t2 # Take from the low bytes only the low nibble 
    and $t8, $t8, $t5 # Take the high pair
    and $t8, $t8, $t7 # Take the high bit
    # Result: $t8 = 0x0008


    and $t8, $t0, $t3 # Take from the low bytes only the high nibble
    and $t8, $t8, $t4 # Take the low pair
    and $t8, $t8, $t6 # Take the low bit
    # Result: $t8 = 0x0010


    and $t8, $t0, $t3 # Take from the low bytes only the high nibble
    and $t8, $t8, $t4 # Take the low pair
    and $t8, $t8, $t7 # Take the high bit
    # Result: $t8 = 0x0020


    and $t8, $t0, $t3 # Take from the low bytes only the high nibble
    and $t8, $t8, $t5 # Take the high pair
    and $t8, $t8, $t6 # Take the low bit
    # Result: $t8 = 0x0040


    and $t8, $t0, $t3 # Take from the low bytes only the high nibble
    and $t8, $t8, $t5 # Take the high pair
    and $t8, $t8, $t7 # Take the high bit
    # Result: $t8 = 0x0080


    and $t8, $t1, $t2 # Take from the high bytes only the low nibble
    and $t8, $t8, $t4 # Take the low pair
    and $t8, $t8, $t6 # Take the low bit
    # Result: $t8 = 0x0100


    and $t8, $t1, $t2 # Take from the high bytes only the low nibble
    and $t8, $t8, $t4 # Take the low pair
    and $t8, $t8, $t7 # Take the high bit
    # Result: $t8 = 0x0200


    and $t8, $t1, $t2 # Take from the high bytes only the low nibble
    and $t8, $t8, $t5 # Take the high pair
    and $t8, $t8, $t6 # Take the low bit
    # Result: $t8 = 0x0400


    and $t8, $t1, $t2 # Take from the high bytes only the low nibble
    and $t8, $t8, $t5 # Take the high pair
    and $t8, $t8, $t7 # Take the high bit
    # Result: $t8 = 0x0800


    and $t8, $t1, $t3 # Take from the high bytes only the high nibble
    and $t8, $t8, $t4 # Take the low pair
    and $t8, $t8, $t6 # Take the low bit
    # Result: $t8 = 0x1000


    and $t8, $t1, $t3 # Take from the high bytes only the high nibble
    and $t8, $t8, $t4 # Take the low pair
    and $t8, $t8, $t7 # Take the high bit
    # Result: $t8 = 0x2000


    and $t8, $t1, $t3 # Take from the high bytes only the high nibble
    and $t8, $t8, $t5 # Take the high pair
    and $t8, $t8, $t6 # Take the low bit
    # Result: $t8 = 0x4000


    and $t8, $t1, $t3 # Take from the high bytes only the high nibble
    and $t8, $t8, $t5 # Take the high pair
    and $t8, $t8, $t7 # Take the high bit
    # Result: $t8 = 0x8000

    # Exit program
    halt
