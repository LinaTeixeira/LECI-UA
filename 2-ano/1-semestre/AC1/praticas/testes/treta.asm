	.data
val:	.word 8,4,15,-1987,327,-9,27,16
	.eqv SIZE, 8
	.text
	.globl main
# v: $t0
# i : $t1
# &(val[0]): $t2
# val[i+SIZE/2] : $t3
main:	li $t1, 0	# i = 0

do1:	la $t2, val	# $t2 = val[0]
	sll $t1, $t1, 2
	addu $t0, $t2, $t1	#v = val[i]
	
	li $t3, SIZE
	div $t3, $t3, 2 # $t3 = SIZE/2
	addi $t3, $t1, $t3	# $t3 = i + SIZE/2
	sw $t3, 0($t0)	# val[i] = val[i+SIZE/2]
	move $t3,	# val[i+SIZE/2] = v
while1:

	jr $ra