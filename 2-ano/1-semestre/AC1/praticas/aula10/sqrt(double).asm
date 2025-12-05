	.data
	.eqv read_double, 7
	.eqv print_double, 3
	.eqv print_str, 4
str1:	.asciiz "Reultado: "
k0:	.double 0.0
k1:	.double 1.0
k5:	.double 0.5
	.text
	.globl main
main:	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $v0, read_double
	syscall
	mov.d $f12, $f0
	
	jal sqrt
	
	li $v0, print_str
	la $a0, str1
	syscall
	mov.d $f12, $f0
	li $v0, print_double
	syscall		#print_float(sqrt)

	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	jr $ra


# i : $t0
# val : $f12
# xn : $f0
# 0.0 : $f2
# aux : $f4
# xn +val/xn) : $f6
sqrt:
	la $t1, k1
	l.d $f0, 0($t1)	#xn = 1.0
	li $t0, 0	# i = 0
	
	la $t1, k0
	l.d $f2, 0($t1)	#$f2 = 0.0
	
if:	c.le.d $f12, $f2
	bc1t else		#if ( val > 0.0 )
	
do:	mov.d $f4, $f0		# aux =xn
	
	div.d $f6, $f12, $f0	# $f6 = val/xn
	add.d $f6, $f0, $f6	# $f6 = xn + val/xn
	
	la $t1, k5
	l.d $f8, 0($t1)
	mul.d $f0, $f6, $f8	# xn = 0.5 * (xn + val/xn)
	
while:	c.eq.d $f4, $f0
	bc1t enddo		#while(aux != xn &
	
	addi $t0, $t0, 1	
	blt $t0, 25, do		#& ++i < 25)
	
enddo:
	j endif
else:
	la $t1, k0
	l.d $f0, 0($t1)	# xn = 0.0
endif:
	jr $ra