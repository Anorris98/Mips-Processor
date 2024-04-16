.data
.text
.globl main
main:
    # Start Test
    #Make sure jal updates $ra correctly
    
    jal Label #$ra should now point to the instruction below this
    addiu $0, $0, 0 #No-op / spacer

    Label:     addiu $t1, $ra, 0 #Store the $ra set by jal into $t1
    jal Label2 #$ra should now point to the instruction below this

    Label2:    addiu $t2, $ra, 0 #Store the new $ra set by jal into $t2
    addiu $t1, $t1, 12	#The second stored $ra is 3 words away from the original
    beq $t1, $t2, CORRECT
    j Exit

    CORRECT: addiu $t0, $0, 1 #Set $t0 to 1 when $ra is stored correctly by jal
    
    Exit:
    # End Test
    # Exit program
    halt
    
