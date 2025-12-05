.data
	.eqv print_double, 3
	.eqv read_double, 7
	.eqv SIZE, 10
k1:	.double 0.0

a:	.space SIZE#######aqui
	.text
	.globl main
# n : $a1
# i : $t1
# i*4 : $t2
# *array[i] : $f2
# sum : $f4

average:	
	addi $t1, $t0, -1	# i = n - 1
	
	la $t2, k1
	l.d $f2, 0($t2)		# sum = 0.0
	
for:	blt $t1, 0, endfor
		
	sll $t2, $t1, 3		# $t2 : i*8
	add $t3, $t2, $a0
	l.d $f2, 0($t3)		# $f2 = *array[i]
	
	add.d $f4, $f4, $f2	#sum +=array[i]

	addi $t1, $t1, -1	#i--
	j for
endfor:
	mtc1 $a1,$f0
	cvt.d.w $f0, $f0
	div.d $f0, $f4, $f2	# return sum / (double)n
	jr $ra

# i : $t1
main:	addiu $sp, $sp, -4   #####continuar main
	sw $ra, 0($sp)

	li $t1, 0	# i=0
for1:	bge $t1, SIZE, endfor1	#for(i<SIZE)
	li $v0, read_double

	addi $t1, $t1, 1		#i++
endfor1:


	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	jr $ra