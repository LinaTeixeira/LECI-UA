	.data
k1:	.float 2.59375
k2:	.float 0.0
	.eqv print_float, 2
	.eqv read_int, 5
	.text
	.globl main
# res : $f0
# val : $t0
main:		
do:	li $v0, 5
	syscall 
	move $t0, $v0	# val = read_int()
	
	la $t1, k1
	l.s $f2, 0($t1)	# $f2 = 2.59375
	
	mtc1 $t0, $f0		
	cvt.s.w $f0, $f0		# $f0 = (float)val
	
	mul.s $f0, $f0, $f2	# res = (float)val*2.59375
	
	li $v0, print_float
	mov.s $f12, $f0
	syscall			#print_float(res)

	la $t1, k2
	l.d $f2, 0($t1)
while:	c.eq.s $f0, $f2
	bc1f do			#while(res != 0.0)
	
	li $v0, 0		#return 0
	jr $ra
