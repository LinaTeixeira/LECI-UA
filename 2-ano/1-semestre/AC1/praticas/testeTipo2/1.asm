	.data
	.eqv print_int10, 1
	.eqv print_str, 4
str:	.asciiz "Invalid argc"
	.eqv SIZE, 15
	.text
	.globl func1
# f1 : $a0 -> $s0
# k : $a1 -> $s1
# av : $a2 -> $s2
# i : $s3
# res : $t0
func1: 	addiu $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s2, 16($sp)
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
if:	blt $s1, 2, else		#if( k>= 2)
	bgt $s1, SIZE, else	# && (k <= SIZE)
	
	li $s3, 2	# i = 2
	
do:	addu $t2, $s2, $s3	# $t2 = &av[i]
	lb $t2, 0($t2)		# $t2 = *av[i]
	move $a0, $t2
	jal toi
	sll $t1, $s3, 2		# $t1 = i*4
	addu $t1, $s0, $s4	# $t1 = &f1[i]
	sw $v0, 0($t1)		# f1[i] = toi(av[i]
	
	addi $s3, $s3, 1		# i++	 	 
while:	blt $s3, $s1, do		# while( i < k)
	
	move $a0, $s0
	move $a1, $s1
	jal avz
	move $t0, $v0		#res = avz(f1, k)

	li $v0, print_int10
	move $a0, $t0
	syscall			#print_int10(res)

	j endif
else:	li $v0, print_str
	la $a0, str
	syscall			#print_str("Invalid argc")
	li $t0, -1		# res = -1
	
endif:	move $v0, $t0		# return res
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s2, 16($sp)
	addiu $sp, $sp, 20
	jr $ra