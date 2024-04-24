# Test Case 4: Loop Control with jr

.data
    counter: .word 10       # Initialize counter with 10

.text
.globl main
main:
    la $t0, counter       # Load address of counter
    lw $t1, 0($t0)        # Load counter value into $t1

loop_start:
    beq $t1, $zero, end_loop  # If counter is 0, exit loop
    sub $t1, $t1, 1       # Decrement counter
    sw $t1, 0($t0)        # Store updated counter value

    la $ra, loop_start    # Load address of loop_start into $ra
    jr $ra                # Jump back to loop_start

end_loop:
    # Loop completed. Continue with the rest of the program.
    halt
