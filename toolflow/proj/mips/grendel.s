#
# Topological sort using an adjacency matrix. Maximum 4 nodes.
# 
# The expected output of this program is that the 1st 4 addresses of the data segment
# are [4,0,3,2]. should take ~2000 cycles in a single cycle procesor.
#

.data
res:
	.word -1-1-1-1
nodes:
        .byte   97 # a
        .byte   98 # b
        .byte   99 # c
        .byte   100 # d
adjacencymatrix:
        .word   6
        .word   0
        .word   0
        .word   3
visited:
	.byte 0 0 0 0
res_idx:
        .word   3
.text
	addiu $sp, $zero, 0x10011000
	addiu $fp, $zero, 0
	lasw $ra pump
	j main # jump to the starting location
	
	nop
	nop	#for jump
	nop	
pump:
	halt


main:
        addiu   $sp,$sp,-40 # MAIN
        
        nop
        nop################################################################
        nop
        
        sw      $31,36($sp)
        sw      $fp,32($sp)
        nop
        add    	$fp,$sp,$zero
        sw      $0,24($fp)
        j       main_loop_control

	nop
	nop	#for jump
	nop

main_loop_body:
        lw      $4,24($fp)
        lasw 	$ra, trucks
        j     is_visited

	nop
	nop	#for jump
	nop

        trucks:

        xori    $2,$2,0x1
#        andi    $2,$2,0x00ff
        beq     $2,$0,kick
        
	nop
	nop	#for Branch
	nop        

        lw      $4,24($fp)
        # addi 	$k0, $k0,1# breakpoint
        lasw 	$ra, billowy
        j     	topsort

	nop
	nop	#for jump
	nop

        billowy:

kick:
        lw      $2,24($fp)
        addiu   $2,$2,1
        sw      $2,24($fp)
main_loop_control:
        lw      $2,24($fp)
        nop
        nop################################################################
        nop
        slti     $2,$2, 4
        
        nop
        nop################################################################
        nop
        beq	$2, $zero, hew # beq, j to simulate bne 
        
        nop
	nop	#for Branch
	nop   
        
        j       main_loop_body

	nop
	nop	#for jump
	nop

        hew:
        sw      $0,28($fp)
        j       welcome
        
	nop
	nop	#for jump
	nop

wave:
        lw      $2,28($fp)
        nop
        nop################################################################
        nop
        addiu   $2,$2,1
        nop
        nop################################################################
        nop
        sw      $2,28($fp)
welcome:
        lw      $2,28($fp)
        nop
        nop################################################################
        nop
        slti    $2,$2,4
        nop
        nop################################################################
        nop
        xori	$2,$2,1 # xori 1, beq to simulate bne where val in [0,1]
        nop
        nop################################################################
        nop
        beq     $2,$0,wave
        
        nop
	nop	#for Branch
	nop   

        move    $2,$0
        move    $sp,$fp
        nop
        nop################################################################
        nop
        lw      $31,36($sp)
        lw      $fp,32($sp)
        nop
        nop################################################################
        nop
        addiu   $sp,$sp,40
        jr       $ra
        
	nop
	nop	#for jump
	nop
        
interest:
        lw      $4,24($fp)
        lasw	$ra, new
        j	is_visited
        
	nop
	nop	#for jump
	nop
	
	new:
        xori    $2,$2,0x1
        nop
        nop################################################################
        nop
        beq     $2,$0,tasteful
        
	nop
	nop	#for Branch
	nop           

        lw      $4,24($fp)
        lasw	$ra, partner
        
        j     	topsort
        
	nop
	nop	#for jump
	nop
        partner:

tasteful:
        addiu   $4,$fp,28
#        move    $4,$2
        lasw	$ra, badge
        j     next_edge
        
     	nop
	nop	#for jump
	nop
        
        badge:
        sw      $2,24($fp)
        
turkey:
        lw      $3,24($fp)
        nop
        nop################################################################
        nop
        beq	$3,-1,telling # beq, j to simulate bne
        
        nop
	nop	#for Branch
	nop   
        j	interest
        
	nop
	nop	#for jump
	nop
	
        telling:
	lasw 	$v0, res_idx
	lw	$v0, 0($v0)
        addiu   $4,$2,-1
        lasw 	$3, res_idx
        nop
        nop################################################################
        nop
        sw 	$4, 0($3)
        lasw	$4, res
        #lui     $3,%hi(res_idx)
        #sw      $4,%lo(res_idx)($3)
        #lui     $4,%hi(res)
        sll     $3,$2,2
#        srl	$3,$3,1
#        sra	$3,$3,1
#        sll     $3,$3,2
       
#        xor	$at, $ra, $2 # does nothing 
#        nor	$at, $ra, $2 # does nothing 
        
        lasw	$2, res
        nop
        nop################################################################
        nop
        andi	$at, $2, 0xffff # -1 will sign extend (according to assembler), but 0xffff won't
        addu 	$2, $4, $at
        nop
        nop################################################################
        nop
        addu    $2,$3,$2
        lw      $3,48($fp)
        nop
        nop################################################################
        nop
        sw      $3,0($2)
        move    $sp,$fp
        lw      $31,44($fp)
        lw      $fp,40($fp)
        addiu   $sp,$sp,48
        jr      $ra
        
	nop
	nop	#for jump
	nop
   
topsort:
        addiu   $sp,$sp,-48
        nop
        nop################################################################
        nop
        sw      $31,44($sp)
        sw      $fp,40($sp)
        move    $fp,$sp
        nop
        nop################################################################
        nop
        sw      $4,48($fp)
        lw      $4,48($fp)
        lasw	$ra, verse
        j	mark_visited
        
       	nop
	nop	#for jump
	nop
        verse:

        addiu   $4,$fp,28
        lw      $5,48($fp)
 #       move    $4,$2
        lasw 	$ra, joyous
        j	iterate_edges
        
       	nop
	nop	#for jump
	nop
        joyous:

        addiu   $2,$fp,28
        nop
        nop################################################################
        nop
        move    $4,$2
        lasw	$ra, whispering
        j     	next_edge
        
       	nop
	nop	#for jump
	nop
	
        whispering:

        sw      $2,24($fp)
        j       turkey
        
       	nop
	nop	#for jump
	nop

iterate_edges:
        addiu   $sp,$sp,-24
        nop
        nop################################################################
        nop
        sw      $fp,20($sp)
        move    $fp,$sp
        nop
        nop################################################################
        nop
        subu	$at, $fp, $sp
        sw      $4,24($fp)
        sw      $5,28($fp)
        lw      $2,28($fp)
        nop
        nop################################################################
        nop
        sw      $2,8($fp)
        sw      $0,12($fp)
        lw      $2,24($fp)
        lw      $4,8($fp)
        lw      $3,12($fp)
        nop
        nop################################################################
        sw      $4,0($2)
        sw      $3,4($2)
        lw      $2,24($fp)
        move    $sp,$fp
        lw      $fp,20($fp)
        addiu   $sp,$fp,24
        jr      $ra
        
       	nop
	nop	#for jump
	nop
        
next_edge:
        addiu   $sp,$sp,-32
        nop
        nop################################################################
        nop
        sw      $31,28($sp)
        sw      $fp,24($sp)
        add	$fp,$zero,$sp
        sw      $4,32($sp)
        j       waggish
        
       	nop
	nop	#for jump
	nop

snail:
        lw      $2,32($fp)
        nop
        nop################################################################
        nop
        lw      $4,0($2) 	#Originally lw      $3,0($2)
        lw      $2,32($fp)
        nop
        nop################################################################
        nop
        lw      $5,4($2)	#originally      $2,4($2)
        nop
        nop################################################################
        nop
        #move    $5,$2
        #move    $4,$3
        lasw	$ra,induce
        j       has_edge
        
       	nop
	nop	#for jump
	nop
        
        induce:
        beq     $2,$0,quarter
        
       	nop
	nop	#for Branch
	nop
        
        lw      $2,32($fp)
        nop
        nop################################################################
        nop
        lw      $2,4($2)
        nop
        nop################################################################
        nop
        addiu   $4,$2,1
        lw      $3,32($fp)
        nop
        nop################################################################
        nop
        sw      $4,4($3)
        j       cynical
        
       	nop
	nop	#for jump
	nop


quarter:
        lw      $2,32($fp)
        nop
        nop################################################################
        nop
        lw      $2,4($2)
        nop
        nop################################################################
        nop
        addiu   $3,$2,1
        nop
        nop################################################################
        nop
        lw      $2,32($fp)
        nop
        nop################################################################
        nop
        sw      $3,4($2)

waggish:
        lw      $2,32($fp)
        nop
        nop################################################################
        nop
        lw      $2,4($2)
        nop
        nop################################################################
        nop
        slti    $2,$2,4
        nop
        nop################################################################
        nop
        beq	$2,$zero,mark # beq, j to simulate bne 
        
        nop
	nop	#for branch
	nop
	
        j	snail
        
        nop
	nop	#for jump
	nop
        
        mark:
        addiu   $2, $zero, -1

cynical:
        move    $sp,$fp
        nop################################################################
        lw      $31,28($fp)
        lw      $fp,24($fp)
        addiu   $sp,$sp,32
        jr      $ra
        
       	nop
	nop	#for jump
	nop
	
has_edge:
        addiu   $sp,$sp,-32
        nop
        nop################################################################
        nop
        sw      $fp,28($sp)
        move    $fp,$sp
        nop
        nop################################################################
        nop
        sw      $4,32($fp)
        sw      $5,36($fp)
        lasw    $2,adjacencymatrix
        lw      $3,32($fp)
        nop
        nop################################################################
        nop
        sll     $3,$3,2
        nop
        nop################################################################
        nop
        addu    $2,$3,$2
        nop
        nop################################################################
        nop
        lw      $2,0($2)
        nop
        nop################################################################
        nop
        sw      $2,16($fp)
        addiu   $2, $zero, 1
        nop
        nop################################################################
        nop
        sw      $2,8($fp)
        sw      $0,12($fp)
        j       measley
        
       	nop
	nop	#for jump
	nop

look:
        lw      $2,8($fp)
        nop
        nop################################################################
        nop
        sll     $2,$2,1
        nop
        nop################################################################
        nop
        sw      $2,8($fp)
        lw      $2,12($fp)
        nop
        nop################################################################
        nop
        addiu   $2,$2,1
        nop
        nop################################################################
        nop
        sw      $2,12($fp)
        nop
        nop################################################################
        nop
measley:
        lw      $3,12($fp)
        lw      $2,36($fp)
        nop
        nop################################################################
        nop
        slt     $2,$3,$2
        nop
        nop################################################################
        nop
        beq     $2,$0,experience # beq, j to simulate bne 
        
        nop
	nop	#for Branch
	nop
	   
        j 	look
        
       	nop
	nop	#for jump
	nop
        
       	experience:
        lw      $3,8($fp)
        lw      $2,16($fp)
        nop
        nop################################################################
        nop
        and     $2,$3,$2
        nop
        nop################################################################
        nop
        slt     $2,$0,$2
        nop
        nop################################################################
        nop
        andi    $2,$2,0x00ff
        move    $sp,$fp
        nop
        nop################################################################
        nop
        lw      $fp,28($sp)
        addiu   $sp,$sp,32
        jr      $ra
        
       	nop
	nop	#for jump
	nop
        
mark_visited:
        addiu   $sp,$sp,-32
        nop
        nop################################################################
        nop
        sw      $fp,28($sp)
        move    $fp,$sp
        nop
        nop################################################################
        nop
        sw      $4,32($fp)
        addiu   $2, $zero, 1
        nop
        nop################################################################
        nop
        sw      $2,8($fp)
        sw      $0,12($fp)
        j       recast
        
       	nop
	nop	#for jump
	nop

example:
        lw      $2,8($fp)
        nop
        nop################################################################
        nop
        sll     $2,$2,8
        nop
        nop################################################################
        nop
        sw      $2,8($fp)
        lw      $2,12($fp)
        nop
        nop################################################################
        nop
        addiu   $2,$2,1
        sw      $2,12($fp)
        
        nop
        nop##################################################
        nop
recast:
        lw      $3,12($fp)
        lw      $2,32($fp)
        
	nop
        nop################################################################
        nop
        
        slt     $2,$3,$2
        
	nop
        nop################################################################
        nop
        
        beq	$2,$zero,pat # beq, j to simulate bne
        
        nop
	nop	#for Branch
	nop   
        
        j	example
        
       	nop
	nop	#for jump
	nop
	
        pat:
       	lasw	$2, visited
       	nop
        nop################################################################
        nop
        sw      $2,16($fp)
        lw      $2,16($fp)
        nop
        nop################################################################
        nop
        lw      $3,0($2)
        lw      $2,8($fp)
        nop
        nop################################################################
        nop
        or      $3,$3,$2
        lw      $2,16($fp)
        nop
        nop################################################################
        nop
        sw      $3,0($2)
        move    $sp,$fp
        nop
        nop################################################################
        nop
        lw      $fp,28($sp)
        addiu   $sp,$sp,32
        jr      $ra
        
       	nop
	nop	#for jump
	nop
        
is_visited:
        addiu   $sp,$sp,-32
        nop
        nop################################################################
        nop
        sw      $fp,28($sp)
        move    $fp,$sp
        nop
        nop################################################################
        nop
        sw      $4,32($fp)
        ori     $2,$zero,1
        nop
        nop################################################################
        nop
        sw      $2,8($fp)
        sw      $0,12($fp)
        j       evasive
        
       	nop
	nop	#for jump
	nop

justify:
        lw      $2,8($fp)
        nop
        nop################################################################
        nop
        sll     $2,$2,8
        nop
        nop################################################################
        nop
        sw      $2,8($fp)
        lw      $2,12($fp)
        nop
        nop################################################################
        nop
        addiu   $2,$2,1
        nop
        nop################################################################
        nop
        sw      $2,12($fp)
        nop
        nop################################################################
        nop
evasive:
        lw      $3,12($fp)
        lw      $2,32($fp)
        nop
        nop################################################################
        nop
        slt     $2,$3,$2
        nop
        nop################################################################
        nop
        beq	$2,$0,representitive # beq, j to simulate bne
        
        nop
	nop	#for Branch
	nop   
	
        j     	justify
        
       	nop
	nop	#for jump
	nop
        representitive:

        lasw	$2,visited
        nop
        nop################################################################
        nop
        lw      $2,0($2)
        nop
        nop################################################################
        nop
        sw      $2,16($fp)
        nop
        nop################################################################
        nop
        lw      $3,16($fp)
        lw      $2,8($fp)
        nop
        nop################################################################
        nop
        and     $2,$3,$2
        nop
        nop################################################################
        nop
        slt     $2,$0,$2
        nop
        nop################################################################
        nop
        andi    $2,$2,0x00ff
        move    $sp,$fp
        nop
        nop################################################################
        nop
        lw      $fp,28($sp)
        addiu   $sp,$sp,32
        jr      $ra
        
       	nop
	nop	#for jump
	nop
