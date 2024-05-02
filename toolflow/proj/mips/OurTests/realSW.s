.data
res:
	.word -1-1-1-1
.text
.globl main
main:
	la 	$s7, res
	sll     $3,$3,2
        addu    $2,$3,$2
        lw      $2,0($s7)
        sw      $2,16($s7)
halt
