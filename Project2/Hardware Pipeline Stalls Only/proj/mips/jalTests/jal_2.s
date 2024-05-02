.data
.text
.globl main
main:
    # Start Test
    #Make sure $ra can be overwritten
    
    addiu $t1, $ra, 0 #Store original $ra
    jal Label	#Overwrite original $ra with new $ra

    Label: bne $t1, $ra, CORRECT #If the new $ra = the old $ra, the test has failed.
    addiu $t0, $0, 0 #Set $t0 to 0 if failed case
    j Exit

    CORRECT: 
    addiu $t0, $0, 1	#Set $t0 to 1 when $ra is able to be overwritten

    Exit:
    # End Test
    # Exit program
    halt
