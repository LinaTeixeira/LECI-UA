	.data
k_1:	.float -1.0
k1:	.float 1.0
k0:	.float 0.0
	.text
	.globl func2
# a : $a0
# t : $f12
# n : $a1
# oldg : $f0
# g : $f2
# s : $f4
# k : $t0
func2:	la $t1, k_1
	l.s $f0, 0($t1)	#oldg = -1.0
	
	la $t1, k1
	l.s $f2, 0($t1)	# g = 1.0
	
	la $t1, k0
	l.s $f4, 0($t1)	# s = 0.0

	li $t0, 0	# k = 0
for:	bge $t0, $a1, endfor	#for( k < n)

	
while:	sub.s $f6, $f2, $f0	# $f6 = g-oldg
	c.le.s $f6, $f12
	bc1t endw		# while( (g-oldg) > t)
	mov.s $f0, $f2	# oldg = g
	
	sll $t2, $t0, 2		# $t2 = k*4
	addu $t2, $a0, $t2	# $t2 = &a[k]
	l.s $f8, 0($t2)		# $f8 = *a[k]
	
	add.s $f2, $f2, $f8
	div.s $f2, $f2, $f12	# g = (g + a[k]) / t
endw:
	add.s $f4, $f4, $f2	# s = s +g
	s.s $f2, 0($t2)		# a[k] = g
	
	addi $t0, $t0, 1		#k++
	j for
endfor:
	mtc1 $a1, $f10
	cvt.s.w $f10, $f10	# (float)n
	div.s $f0, $f4, $f10	# return s / (float) n
	jr $ra