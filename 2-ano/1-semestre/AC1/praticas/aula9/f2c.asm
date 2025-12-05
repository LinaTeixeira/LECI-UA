	.data
	.eqv print_double, 3
k1:	.double 5.0
k2:	.double 9.0
k3:	.double 32.0
k:	.double 10.0
	.text
	.globl main

f2c:	la $t0, k1
	l.d $f2, 0($t0)
	
	la $t0, k2
	l.d $f4, 0($t0)
	
	la $t0, k3
	l.d $f6, 0($t0)
	
	div.d $f2, $f2, $f4	# $f2 = 5.0 / 9.0
	sub.d $f6, $f12, $f6	# $f6 = ft - 32.0
	mul.d $f0, $f2, $f6	# $f8 = (5.0 / 9.0 * (ft - 32.0))
	
	jr $ra

main:	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $t1, k
	l.d $f12, 0($t1)
	
	jal f2c
	
	mov.d $f12, $f0
	li $v0, print_double
	syscall
	
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	
	jr $ra
	