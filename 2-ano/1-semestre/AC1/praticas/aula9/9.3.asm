	.data
	.eqv read_double, 7
	.eqv print_double, 3
	.eqv SIZE, 10
a:	.space 80	# static double a[SIZE]
k0:	.double 0.0
	.text
	.globl main
# i : $t0
# &a : $t1
# &(a+i) : $t2
# *a[i] : $f2
main: 	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $t0, 0	# i = 0
for0:	bge $t0, SIZE, endfor0	# for (i < SIZE)
	
	la $t1, a	# $a = $t1
	sll $t2, $t0, 3		# $t2 = i*3
	add $t2, $t2, $t1	# $t2 = &(a + i)

	li $v0, read_double
	syscall
	s.d $f0, 0($t2)	#a[i] = read_double()

	addi $t0, $t0, 1		# i++
	j for0
	
endfor0:	move $a0, $t1
	li $a1, SIZE
	jal average	# average( a, SIZE)
	
	mov.d $f12, $f0
	li $v0, print_double
	syscall		# print_double( average(a, SIZE))
	
	li $v0, 0	#return 0
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	jr $ra
	
# array : $a0
# *array[i] : $f0
# n : $a1
# i : $t1
# sum : $f2
average:
	addi $t1, $a1, -1	# int i = n - 1 
	la $t0, k0
	l.d $f2, 0($t0)		# double sum = 0.0
	
for:	blt $t1, 0, endfor	# for ( i >= 0)
	
	sll $t2, $t1, 3		# $t2 = i * 8 ( double)
	add $t0, $a0, $t2	# $t0 = &array[i]
	l.d $f0, 0($t0)		# $f0 = *array[i]
	
	add.d $f2, $f2, $f0	# sum += array[i]
	
	addi $t1, $t1, -1	#i--
	j for
	
endfor:	mtc1 $a1, $f0
	cvt.d.w	$f0, $f0		# $f0 = (double)n
	
	div.d $f0, $f2, $f0	# return sum / (double) n
	jr $ra