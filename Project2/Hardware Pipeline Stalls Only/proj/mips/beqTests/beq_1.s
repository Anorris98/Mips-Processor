.data
newline:       .asciiz "\n"
equal_msg:     .asciiz "Test Case: Values are Equal\n"
not_equal_msg: .asciiz "Test Case: Values are Not Equal\n"

.text
main:
    # Test Case: Equality Check
    addi $t0, $zero, 10      # $t0 = 10
    addi $t1, $zero, 10      # $t1 = 10
    beq $t0, $t1, equal_case # Branch to equal_case if $t0 == $t1

    # Code to execute if not equal
    addi $t2, $zero, 10      # should not arrive
    halt

equal_case:
    # Exit the program
    addi $t3, $zero, 10      # should arrive
    halt
