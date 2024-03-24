.text
main:
    # Test Case: Inequality Check
    addi $s0, $zero, 5           # $s0 = 5
    addi $s1, $zero, 10          # $s1 = 10
    beq $s0, $s1, equal_case     # Branch to equal_case if $s0 == $s1

    # Code to execute if not equal
    addi $t0, $t0, 1            # Increment $t0

    # Exit the program
    halt

equal_case:
    # Code to execute if equal
    addi $t1, $t1, 1            # Increment $t1

    # Exit the program
    halt
