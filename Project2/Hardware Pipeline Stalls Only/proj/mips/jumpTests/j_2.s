.data
.text
.globl main

main:
    nop                      # Start of the program for backward jump

    j backward_jump          # Jump to the backward_jump label
    nop                      

    j end_test               # Jump to end_test to exit cleanly
    nop                      

backward_jump:
    nop                      # If jump works, this executes after jumping back

end_test:
    # Exit program
    halt
