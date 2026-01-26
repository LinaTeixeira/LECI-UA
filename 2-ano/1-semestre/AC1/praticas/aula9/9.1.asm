	.data
	.eqv read_int, 5
	.eqv print_float, 2
k1:	.float 2.59375
k0:	.float 0.0
	.text
	.globl main
# res : $f0
# val : $t0
# (float) val : $f2
main:
do:	li $v0, read_int
	syscall
	move $t0, $v0	# val = read_int()
	
	mtc1 $t0, $f2
	cvt.s.w $f2, $f2		# (float)val : $f2
	
	la $t1, k1
	l.s $f4, 0($t1)		# $f4 = 2.59375
	
	mul.s $f0, $f2, $f4	# res = (float)val * 2.59375
	li $v0, print_float
	mov.s $f12, $f0
	syscall			# print_float(res)
	
	la $t1, k0
	l.s $f6, 0($t1)		# $f6 = 0.0
	
while:	c.eq.s $f0, $f6
	bc1f do			#while(res != 0.0)
	
	li $v0, 0	 #return 0
	jr $ra