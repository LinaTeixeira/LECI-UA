	.data
	.eqv read_float, 6
	.eqv read_int, 5
	.eqv print_float, 2
k1:	.float 1.0
	.text
	.globl main
main:	addiu $sp, $sp, -4
	sw $ra, 0($sp)

	li $v0, read_float
	syscall
	mov.s $f12, $f0
	
	li $v0, read_int
	syscall
	move $a0, $v0
	
	jal xtoy
	mov.s $f12, $f0
	li $v0, print_float
	syscall
	
	li $v0, 0	#return 0

	lw $ra, 0($sp)
	addiu $sp, $sp, 4
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
for:	bge $s1, $t1, endfor	# for(i < abs(Y))
	
if:	ble $s0, 0, else		# if ( y > 0)

	mul.s $f22, $f22, $f20	# result *= x
	j endif
	
else:	div.s $f22, $f22, $f20	# result /= x

endif:
	addi $s1, $s1, 1		#i++
	j for
endfor:	
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