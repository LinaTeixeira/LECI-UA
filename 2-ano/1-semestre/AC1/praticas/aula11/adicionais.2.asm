	.data
	.eqv print_float, 2
uvw:	.align 3
	.asciiz "St1"
	.space 6		
	.double 3.1415926535589
	.word 291
	.word 756
	.byte 'X'
	.align 2
	.float 1.983
	.text
	.globl main	

f1:	la $t0, uvw
	
	l.s $f0, 36($t0)
	cvt.d.s $f0, $f0		# $f0 = (double)s1.k
	
	addiu $t1, $t0, 28
	mtc1 $t1, $f2
	cvt.d.s $f2, $f2		# $f2 = (double)s1.a2[1]
	
	div.d $f4, $f2, $f0	# $f4 = (double)s1.a2[1] / (double)s1.k
	
	l.d $f6, 24($t0)		# $f6 = s1.g
	
	mul.d $f0, $f6, $f4	#$f0 = s1.g * (double)s1.a2[1] / (double)s1.k

	jr $ra
main:	addiu $sp, $sp, 4
	sw $ra, 0($sp)

	jal f1
	li $v0, print_float
	mov.d $f12, $f0
	syscall
	
	lw $ra, 0($sp)
	addiu $sp, $sp, -4
	jr $ra