# Test Case 2: Return from Procedure

.text
.globl main
main:
    jal procedure          # Call procedure; $ra is set to return address
    addi $t1, $0, 1        # Execution resumes here after jr $ra in procedure
    halt

procedure:
    jr $ra                 # Return from procedure using $ra
    addi $t1, $0, 2
    halt
