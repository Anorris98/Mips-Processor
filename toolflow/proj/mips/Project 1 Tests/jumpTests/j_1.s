.data
.text
.globl main

main:
    nop                      # No operation, placeholder for the delayed slot

    j forward_jump           # Jump forward in the program

    # This part should be skipped by the forward jump
    nop                      # Placeholder to demonstrate skip
    nop                      # Another placeholder to demonstrate skip

forward_jump:
    nop                      # Confirm we've jumped forward

    # Exit program
    halt
