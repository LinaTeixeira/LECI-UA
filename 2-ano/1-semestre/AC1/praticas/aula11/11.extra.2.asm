	.data
	.eqv print_float, 2
uvw:	.align 3		# struct {
	.asciiz "St1"
	.space 6		# char a1[10]
	.align 3
	.double 3.141592653589		# double g
	.align 2
	.word 291, 756		# int a2[2]
	.byte 'X'		# char v
	.align 2		
	.float 1.983		# float k
			# }
	.text
	.globl main
main:	addiu $sp, $sp, -4
	sw $ra, 0($sp)

	jal f1
	li $v0, print_float
	mov.s $f12, $f0
	syscall

	li $v0, 0

	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	jr $ra
	
# s1 : $t0  
#	
f1:	la $t0, uvw

	l.s $f0, 36($t0)
	cvt.d.s $f0, $f0		# $f0 = (double)s1.k
	
	lw $t1, 28($t0)
	mtc1 $t1, $f2
	cvt.d.w $f2, $f2		# $f2 = (double)s1.a2[1]
	
	l.d $f6, 16($t0)		# $f6 = s1.g
	
	mul.d $f6, $f6, $f2	# $f6 = s1.g *(double)s1.a2[1] 
	div.d $f0, $f6, $f0	# $f0 = s1.g *(double)s1.a2[1] / (double)s1.k
	
	cvt.s.d $f0, $f0		# return (float)s1.g * ...
	jr $ra