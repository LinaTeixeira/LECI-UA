	.data
k0:	.double 0.0
t_kvd:	.align 3
	.space 40
	.text
	.globl func3
# nv : $a0
# pt : $a1
# i : $t0
# j : $t1
# sum : $f0
func3:	la $t2, k0
	l.d $f0, 0($t2)		# double sum = 0.0
	li $t0, 0		# i = 0
for:	bge $t0, $a0, endfor	# for( i < nv)

	li $t1, 0	# j = 0
	
do:	addiu $t2, $a1, 16	# $t2 = &( pt->quest[0])
	addu $t2, $t2, $t1	# $t2 = &(pt->quest[j])
	lw $t2, 0($t2)		# $t2 = *(pt->quest[j])
	mtc1 $t2, $f2
	cvt.d.w $f2, $f2		# (double) pt->quest[j]
	
	add.d $f0, $f0, $f2	# sum += (double) pt->quest[j]
	
	addi $t1, $t1, 1		#j++
	
	lb $t3, 4($a1)		#$t3 = *( pt->nm )
while:	blt $t1, $t3, do		# while ( j < pt->nm)

	l.d $f4, 8($a1)		# $f4 = pt->grade
	div.d $f4, $f0, $f4	# $f4 = sum / pt->grade
	cvt.w.d $f4, $f4	
	mfc1 $t4, $f4		# (int) (sum / pt->grade)
	
	sw $t4, 0($a1)		# pt->acc = (int) (sum / pt->grade)
	
	addi $t0, $t0, 1		# i++
	addiu $a1, $a1, 40	# pt++	
	j for
endfor:
	lw $t5,32($a1)
	mtc1 $t5, $f6
	cvt.d.w	$f6, $f6		# $f6 = (double) pt->cq
	
	l.d $f0, 8($a1)		# $f0 = pt->grade
	mul.d $f0, $f0, $f6	# return ( pt->grade * (double) pt->cq)
	jr $ra