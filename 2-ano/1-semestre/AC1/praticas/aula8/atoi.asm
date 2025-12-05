	.data
str:	.asciiz "101101"
	.eqv print_int10, 1
	.text
	.globl main
# mapa de registos (sub-rotina terminal -> n sao usados registos $sx
# res:	$v0
# s:	$a0
# *s:	$t0
#digit:	$t1
atoi:	
	li $t1, 0	#int digit=0
	li $v0, 0	#int res=0
	
while:	lb $t0, 0($a0)	
	blt $t0, '0', endw	# while *s >= '0' &&
	bgt $t0, '1', endw	# *s <= '9'

	addiu $t1, $t0, -0x30	# digit = *s++ -'0'
	addiu $a0, $a0, 1	# s++
	mulu $v0, $v0, 2		# res = 10*res
	addu $v0, $v0, $t1 
	
	j while
endw:	
	jr $ra

main:	
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $a0, str
	jal atoi
	move $a0, $v0
	li $v0, print_int10
	syscall
	
	lw $ra, 0($sp)
	addiu $sp, $sp, 4

	jr $ra