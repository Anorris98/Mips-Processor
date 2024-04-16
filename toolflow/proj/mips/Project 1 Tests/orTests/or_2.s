.data
.text
.globl main
main:
or $8, $0, 100 #$0 | immediate
#expected result should be an error because
#normally on mars this would work becasue the
#compiler just uses ori instead and treats or as a pseudo instruction
#but our processor will not do this so we need to make sure our
#or instruction can not take an immediate.
halt
