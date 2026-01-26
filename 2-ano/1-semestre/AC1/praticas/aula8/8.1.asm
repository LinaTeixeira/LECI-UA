	.data
	.eqv print_int10, 1
str:	.asciiz "2020 e 2024 sao anos bissextos"
	.text
	.globl main
main:	addiu $sp, $sp, -4
	sw $ra, 0($sp)

	la $a0, str
	jal atoi
	
	move $a0, $v0
	li $v0, print_int10
	syscall		#print_int10( atoi(str) )

	li $v0, 0	# return 0
	
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	jr $ra
	
# &s : $a0
# digit : $t0
# res : $t1
# *s : $t2
atoi:	li $t0, 0	# digit = 0
	li $t1, 0	# res = 0
	
while1:	lb $t2, 0($a0)
	blt $t2, '0', endw1	# while ( (*s >= '0')
	bgt $t2, '9', endw1	#	&& ( *s <= '9'))
	
	addiu $t0, $t2, -0x30	# digit = *s - '0'
	addiu $a0, $a0, 1	# s++
	
	mulu $t1, $t1, 10		# 
	addu $t1, $t1, $t0	# res = 10 * res + digit
	
	j while1
	
endw1:	move $v0, $t1	# return res
	jr $ra