	.data
	.eqv print_double, 3
k035:	.double 0.35
xyz:	.align 3		# struct {
	.asciiz "Str_1"
	.space 8		# char a1[14]
	.word 2023	# int i
	.double 2,718281828459045	# double g
	.asciiz "Str_2"
	.space 11	# char a2[17}
			#} xyz
	.text
	.globl main
	
main:	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $a0, xyz
	jal f2
	mov.d $f12, $f0
	li $v0, print_double
	syscall
	

	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	jr $ra

# p : $a0
# p->g : $f0
# p->i : $f2	
f2:	l.d $f0, 24($a0)		# p->g
	
	lw $t2, 16($a0)
	mtc1 $t2, $f2
	cvt.d.w $f2, $f2		#(double)p->i
	
	mul.d $f0, $f0, $f2
	
	la $t1, k035
	l.d $f2, 0($t1)
	
	div.d $f0, $f0, $f2
	jr $ra