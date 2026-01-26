	.data
	.text
	.globl main
	# $t0 = val
	# $t2 = shift left logical , $t3 = shift right logical, $t4 = shift right arithmetic
	# $t1 = gray

main:	li $t0, 2
	
	sll $t2, $t0, 4
	srl $t3, $t0, 4
	sra $t4, $t0, 4
	
	#bin to gray
	srl $t1, $t0, 1
	xor $t1, $t1, $t0 
	
	jr $ra
	