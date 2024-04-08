#BubbleSort for Proj1

#javacode
#swappedsomething = false;
#while(swappedsomething == true){
#	for (int i = 0; i< numbers.length - 1; i++){
#		if (number[i]> number [i + 1]){
#		swappedSomething = true;
#		int temp = numbers[i];
#		numbers [i] = numbers [i+1]
#		numbers[i+1] = temp;
#		}
#	}
#}
#$s0 - swapped something
#s1 = i
#s2 = n-2

#$s7 =  active array memory location

.data

numbers: .word 3, 0, 0, 3, 54, -1, 2, 256, -3, 0		# Array of N=10

.text
main:
	
	li $s0, 1    	#SwappedSomething = true	#initialize swapped something to true.
	li $s2, 9 	#(n-2)				#initzalize for loop counter to stop at N-2, becasue of i and i++
	
	j whileloop	#start looping

whileloop:
	li $s1, 0	#i = 0				#initialize for loop counter to 0.
	nop		#nop or 28, $s0, 35
	beq $s0, 0, fin	# we Need to run this only if swappedsomething == true, else done and print.
	
	nop
	nop
	nop		#5 nops because we need to know if we are branching or not before loading the next instruciton from pc+4 or the new address.
	nop
	nop
	
	li $s0, 0		#swapped something = false
	lasw $s7, numbers					#(PsuedoInstruction) load memory address for array into $s7 with 3 additional nops
	
forloop:
	lw $t0, 0($s7) 		#number[i]
	lw $t1, 4($s7)		#number[i + 1]
	
	nop
	nop
	nop
	nop
	
	bgt $t0, $t1, swap	#if numbers in i > numbers in i+1, need to sort.
	
	nop
	nop			#4 nops to allow us to not load bad data if we didnt branch.
	nop
	nop
	
	
	j increment		#else increment for loop.
	
	nop
	nop
	nop			#4 NOPS TO NOT LOAD BAD DATA BECAUSE OF JUMP, we want to wait until the jump adress is given back to the pc.
	nop


swap:
	li $s0, 1		#swapped something == true.			#swap memory location $t0 with $t1
	sw $t0, 4($s7)		#memory for numbers[i] = numbers[i+1]
	sw $t1, 0($s7)		#memory numbers i+1 = numbers[i]
increment:	
	addiu $s7, $s7, 4		#increment memory location to next word(4 bytes or sll by 2.)
	addiu $s1, $s1, 1		#increment counter/i++
	
	nop
	nop
	nop			#4 nops to allow s1 to write.
	nop
	
	beq $s1, $s2, whileloop		#restart while loop if we are at the end of the for loop.
	j forloop			#else do next iteration of for loop.
	
	nop
	nop
	nop
	nop
	
fin:	
	nop
	nop
	nop
	nop
	halt			# end the program.
