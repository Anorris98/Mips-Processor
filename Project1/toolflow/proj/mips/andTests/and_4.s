.data
.text
.globl main
main:

    # Testing that each individual bit should be able to pass through 
    # when anded with an all high register

    # Start Test
    addi $t0, $0, 1 # Load $t0 with 1

    # Load $t1 with 0xFFFFFFFF
    addi $t1, $0, 0xFFFF
    sll $t1, $t1, 16
    addi $t1, $t1, 0xFFFF

    # Check that nothing passes through for and with 0
    and $t2, $t0, $0
    and $t2, $0, $t0
    
    # Checking that bit 0 passes through with no difference in order
    and $t2, $t0, $t1
    and $t3, $t1, $t0
    
    # Checking that bit 1 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 2 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0
    
    # Checking that bit 3 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 4 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 5 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 6 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 7 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 8 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 9 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 10 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 11 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 12 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 13 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 14 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 15 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 16 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 17 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 18 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 19 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 20 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 21 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 22 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 23 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 24 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 25 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 26 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 27 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 28 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 29 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 30 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0

    # Checking that bit 31 passes through with no difference in order
    sll $t0, $t0, 1
    and $t2, $t0, $t1
    and $t3, $t1, $t0
   
    # End Test

    # Exit program
    halt
