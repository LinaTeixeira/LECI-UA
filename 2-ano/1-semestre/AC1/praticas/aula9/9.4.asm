	.data
	.eqv read_double, 7
	.eqv print_double, 3
	.eqv SIZE, 10
a:	.space 80	# static double a[SIZE]
	.text
	.globl main
main: 	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $t0, 0	# i = 0
for0:	bge $t0, SIZE, endfor0	# for (i < SIZE)
	
	la $t1, a	# $a = $t1
	sll $t2, $t0, 3		# $t2 = i*8
	add $t2, $t2, $t1	# $t2 = &(a + i)

	li $v0, read_double
	syscall
	s.d $f0, 0($t2)	#a[i] = read_double()

	addi $t0, $t0, 1		# i++
	j for0
	
endfor0:	la $a0, a
	li $a1, SIZE
	jal max		# max( a, SIZE)
	
	mov.d $f12, $f0
	li $v0, print_double
	syscall		# print_double( max(a, SIZE))
	
	li $v0, 0	#return 0
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	jr $ra


# p : $a0
# n : $a1
# *p : $f0
# max : $f2
# u : $t0
max:	addiu $t0, $a1, -1
	sll $t0, $t0, 3
	addu $t0, $t0, $a0	# *u = p+n-1
	
	l.d $f2, 0($a0)		# max = *p
	addiu $a0, $a0, 8	# p++	
for:	bgt $a0, $t0, endfor	# for(p <= u)
	
	l.d $f0, 0($a0)		# *p = $f0
if:	c.le.d $f0, $f2		
	bc1t endif	#if ( *p > max)
	
	mov.d $f2, $f0			# max = *p
	
endif:	addiu $a0, $a0, 8	#p++
	j for
endfor:
	mov.d $f0, $f2	#return max
	jr $ra