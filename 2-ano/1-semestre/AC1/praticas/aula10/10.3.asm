	.data
	.eqv read_float, 6
	.eqv read_int, 5
	.eqv print_float, 2
k1:	.float 1.0
k05:	.double 0.5
k0:	.float 0.0

	.text
	.globl main
main:

	jr $ra
# &array : $a0 -> $s0
# nval : $a1 -> $s1
# i : $s2			
# media : $f20	
# soma : $f22		
var:	addiu $sp, $sp, -36
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	s.s $f20, 20($sp)
	s.s $f22, 28($sp)
	move $s0, $a0
	move $s1, $a1
	
	move $a0, $s0
	move $a1, $s1
	jal average	# average( array, nval)
	cvt.s.d $f20, $f0		# media = (double)average( array, nval)
	
	li $s2, 0	# i = 0
	la $t0, k0
	l.s $f22, 0($t0)	# soma = 0.0
	
for4:	bge $s2, $s1, endfor4	# for( i < nval)
	
	sll $t1, $s2, 3	# $t1 = i * 8
	addu $t1, $t1, $s0	# $t1 = &array[i]
	l.d $f2, 0($t1)		# $f0 = *array[i]
	cvt.s.d $f2,$f2		# $f0 = (float)array[i]
	
	sub.s $f12, $f2, $f22	# $f12 = (float)array[i] - media
	li $a0, 2
	jal xtoy		
	add.s $f22, $f22, $f0	#soma += xtoy((float)array[i] - media, 2)
	
	addiu $s2, $s2, 8	#i++ 
	j for4
endfor4:

	cvt.d.s $f22, $f22	# (double)soma
	mtc1 $s1, $f4
	cvt.d.w $f4, $f4		# (double)nval

	div.d $f0, $f22, $f4	# return (double)soma / (double)nval
		
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	l.s $f20, 20($sp)
	l.s $f22, 28($sp)
	addiu $sp, $sp, 36
	jr $ra

# array : $a0 -> $s0
# nval : $a1 -> $s1
stdev:	addiu $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	move $s0, $a0
	move $s1, $a1
	
	jal var
	mov.d $f12, $f0
	jal sqrt		# return sqrt(...)


	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
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
	
# x : $f12 -> $f20
# y : $a0 -> $s0
# i : $s1
# result: $f22
# abs(y) : $t1
xtoy:	addiu $sp, $sp, -28
	sw $ra, 0($sp)
	s.s $f20, 4($sp)
	sw $s0, 8($sp)
	sw $s1, 12($sp)
	s.s $f22, 20($sp)
	
	mov.s $f20, $f12
	move $s0, $a0
	
	li $s1, 0	# i = 0
	
	la $t0, k1
	l.s $f22, 0($t0)	# result = 1.0
	
	move $a0, $s0
	jal abs		
	move $t1, $v0	# $t1 = abs(y)
for3:	bge $s1, $t1, endfor3	# for(i < abs(Y))
	
if3:	ble $s0, 0, else3		# if ( y > 0)

	mul.s $f22, $f22, $f20	# result *= x
	j endif3
	
else3:	div.s $f22, $f22, $f20	# result /= x

endif3:
	addi $s1, $s1, 1		#i++
	j for3
endfor3:	
	mov.s $f0, $f22	# return result
	
	lw $ra, 0($sp)
	l.s $f20, 4($sp)
	lw $s0, 8($sp)
	lw $s1, 12($sp)
	l.s $f22, 20($sp)
	addiu $sp, $sp, 28
	jr $ra
	
# val : $a0	
abs:
if1:	bge $a0, 0, endif1	# if( val < 0)
	sub $a0, $0, $a0		# val = -val
	
endif1:	move $v0, $a0		# return val
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
if7:	c.le.d $f12, $f4
	bc1t else7	# if (val > 0.0)

do7:	mov.d $f0, $f2	# aux = xn
	div.d $f6, $f12, $f2	# $f6 = val / xn
	add.d $f6, $f2, $f6	# $f6 = xn + val /xn
	
	la $t0, k05
	l.d $f8, 0($t0)
	mul.d $f2, $f8, $f6	# xn = 0.5 * (xn + val /xn )
	
while7:	c.eq.d $f0, $f2
	bc1t enddo7		# while  (( aux != xn) 
	
	addi $t1, $t1, 1		# ++i
	blt $t1, 25, do7		# && (++i < 25))
	
enddo7:	j endif7
else7:
	la $t0, k0
	l.d $f2, 0($t0)	# xn = 0.0
endif7:
	mov.d $f0, $f2
	jr $ra
