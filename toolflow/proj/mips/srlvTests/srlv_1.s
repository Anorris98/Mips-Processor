.data
.text
.globl main

main:
addiu $t0, $zero,0xFFFFFFFF# load values to test
addiu $t1, $zero,4

srlv $t2,$t0,$t1 # should move the ammount of 4 to the right
		# and fill the vacant spaces with 0 on the left side
		
		#output  $t2 should be 0x0FFFFFFF

    halt

