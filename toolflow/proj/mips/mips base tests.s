#test codes for project 2

main:
	addiu $t1, $zero, 0#set to zero
	add $zero, $zero, $zero
	add $zero, $zero, $zero
	add $zero, $zero, $zero
	add $zero, $zero, $zero
	add $zero, $zero, $zero
	addiu $t1, $t1, 16
	addiu $s0, $zero, 1#s1 is now 1.
	add $zero, $zero, $zero
	add $zero, $zero, $zero	
	add $zero, $zero, $zero
	add $zero, $zero, $zero
	add $zero, $zero, $zero
	sub $s1, $s1, $s1 #s1 - $s1 shoudl now be 0
	add $zero, $zero, $zero	
	add $zero, $zero, $zero
	add $zero, $zero, $zero
	add $zero, $zero, $zero
	add $zero, $zero, $zero
	or $s0, $s1, $t1 #s0 should now be 16
	add $zero, $zero, $zero	
	add $zero, $zero, $zero
	add $zero, $zero, $zero
	add $zero, $zero, $zero
	add $zero, $zero, $zero
	and $t1, $s1, $t1 #t1 should now be 0
	add $zero, $zero, $zero
	add $zero, $zero, $zero
	add $zero, $zero, $zero
	add $zero, $zero, $zero	
	add $zero, $zero, $zero
	halt