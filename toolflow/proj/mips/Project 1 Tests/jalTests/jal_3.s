.data
.text
.globl main
main:
    # Start Test
    #Ensure the jump portion of jal works as intended
    
    jal Label
    addiu $t0, $0, 0 #Set to 0 if failed case
    j Exit #Fail case if jal doesn't jump correctly

    Label: 
    addiu $t0, $0, 1 #Set $t0 to 1 if the jump part of jal worked correctly
    
    Exit:
    
    # End Test
    # Exit program
    halt
