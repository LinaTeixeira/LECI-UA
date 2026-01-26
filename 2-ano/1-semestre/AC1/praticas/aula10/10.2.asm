	.data
	.eqv read_double, 7
	.eqv print_double, 3
k0:	.double 0.0
k05:	.double 0.5
k1:	.double 1.0
	.text
	.globl main
main:	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $v0, read_double
	syscall
	mov.d $f12, $f0
	jal sqrt
	mov.d $f12, $f0
	li $v0, print_double
	syscall
	
	
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	jr $ra
	
# val: $f12
# aux : $f0
# xn : $f2
# i : $t1
sqrt:	la $t0, k1
	l.d $f2, 0($t0)	# xn = 1.0

	li $t1, 0	# i = 0
	
	la $t0, k0
	l.d $f4, 0($t0)	# $f4 = 0.0
if:	c.le.d $f12, $f4
	bc1t else	# if (val > 0.0)

do:	mov.d $f0, $f2	# aux = xn
	div.d $f6, $f12, $f2	# $f6 = val / xn
	add.d $f6, $f2, $f6	# $f6 = xn + val /xn
	
	la $t0, k05
	l.d $f8, 0($t0)
	mul.d $f2, $f8, $f6	# xn = 0.5 * (xn + val /xn )
	
while:	c.eq.d $f0, $f2
	bc1t enddo		# while  (( aux != xn) 
	
	addi $t1, $t1, 1		# ++i
	blt $t1, 25, do		# && (++i < 25))
	
enddo:	j endif
else:
	la $t0, k0
	l.d $f2, 0($t0)	# xn = 0.0
endif:
	mov.d $f0, $f2
	jr $ra