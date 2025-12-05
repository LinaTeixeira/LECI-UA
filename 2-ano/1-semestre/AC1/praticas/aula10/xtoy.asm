	.data
	.eqv read_float, 6
	.eqv read_int, 5
	.eqv print_float, 2
	.eqv print_str, 4
str1:	.asciiz "Reultado: "
	.text
	.globl main
# x : $f12 -> $f20(callee-saved)
# y : $a0  -> $s0
# i : $t0
# result : $f0
# abs(y) : $t1
xtoy:	addiu $sp, $sp, -12
	sw $ra, 0($sp)
	s.s $f20, 4($sp)
	sw $s0, 8($sp)
	
	mov.s $f20, $f12		# $f20 = x
	move $s0, $a0
	
	jal abs
	move $t1, $v0		# $t1 =abs(y)
	li $t0, 0		#i = 0
	
	li $t2, 1		#$f0 = 1
	mtc1 $t2, $f0
	cvt.s.w $f0, $f0		#$f0=1.0
	
for:	bge $t0, $t1, endfor	# for(i<abs(y))

if:	ble $s0, $0, else
	mul.s $f0, $f0, $f20	# result *= x
	j endif
	
else:	div.s $f0, $f0, $f20	#result /= x
	j endif
	
endif:	addi $t0, $t0, 1		#i++
	j for
	
endfor:	
	lw $ra, 0($sp)
	l.s $f20, 4($sp)
	lw $s0, 8($sp)
	addiu $sp, $sp, 12

	jr $ra
	
# val : $a0
abs:
if1:	bge $a0, 0, endif1
	sub $v0,$0, $a0		#return

endif1:

	jr $ra
	
main:	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $v0, read_float
	syscall
	mov.s $f12, $f0		#$f12 = x
	
	li $v0, read_int
	syscall
	move $a0, $v0		#$a0 = y
	
	jal xtoy			#xtoy(x, y)
	
	li $v0, print_str
	la $a0, str1
	syscall
	mov.s $f12, $f0
	li $v0, print_float
	syscall		#print_float(x, y)
	
	lw $ra, 0($sp)
	addiu $sp, $sp, 4

	jr $ra