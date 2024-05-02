.data

numbers: .word 3, 0, 0, 3, 54, -1, 2, 256, -3, 0		# Array of N=10

.text
main:
	
	addiu $s0, $zero, 1    	#SwappedSomething = true	#initialize swapped something to true.
	addiu $s2, $zero, 9 	#(n-2)				#initzalize for loop counter to stop at N-2, becasue of i and i++
	
	nop

whileloop:
	addiu, $s1, $zero, 0	#i = 0				#initialize for loop counter to 0.


	beq $s0, $0, fin	# we Need to run this only if swappedsomething == true, else done and print.
	
	nop
	nop
	nop		#5 nops because we need to know if we are branching or not before loading the next instruciton from pc+4 or the new address.

	lasw $s7, numbers					#(PsuedoInstruction) load memory address for array into $s7 with 3 additional nops
	addiu $s0, $zero, 0		#swapped something = false
	nop
	nop


forloop:
	lw $t0, 0($s7) 		#number[i]
	lw $t1, 4($s7)		#number[i + 1]
	
	nop
	nop
	nop

	slt $1, $t1, $t0####psuedo instruction for BGT because Mips uses one, but ours nativly supports it.
	nop
	nop
	nop
	bne $1, $0, swap##############################	psuedo end	
	nop			#4 nops to allow us to not load bad data if we didnt branch.
	nop
	nop
	
	j increment		#else increment for loop.
	
	nop
	nop
	nop			#4 NOPS TO NOT LOAD BAD DATA BECAUSE OF JUMP, we want to wait until the jump adress is given back to the pc.



swap:
	addiu $s0, $zero, 1		#swapped something == true.			#swap memory location $t0 with $t1
	sw $t0, 4($s7)		#memory for numbers[i] = numbers[i+1]
	sw $t1, 0($s7)		#memory numbers i+1 = numbers[i]
increment:
	addiu $s1, $s1, 1		#increment counter/i++ moved from lower because no matter what we need to inc
	addiu $s7, $s7, 4		#increment memory location to next word(4 bytes or sll by 2.)
	
	nop
	nop			#2 nops to allow s1 to write
	
	beq $s1, $s2, whileloop		#restart while loop if we are at the end of the for loop.
	nop
	nop
	nop
	j forloop			#else do next iteration of for loop.

	nop
	nop
	nop

	
fin:	

	halt			# end the program.
