	.data
	.eqv print_int10, 1
	.eqv SIZE, 4
array:	.word 7692, 23, 5, 234
	.text
	.globl main
# p : $t0
# pultimo: $t1
# *p : $t2
# soma: $t3
# SIZE : $t4
main:	li $t3, 0 #soma = 0
	la $t0, array	# p = array
	li $t4, SIZE	# $t4 = size
	addi $t4, $t4, -1	#$t4 = SIZE - 1
	sll $t5, $t4, 2
	addu $t1, $t5, $t0	#pultimo = array + SIZE


while:	bgt $t0, $t1, endw
	lw $t2, 0($t0)	#$t2 = *p
	add $t3, $t3, $t2	#soma = soma + (*p)
	addiu $t0, $t0, 4		#p++ 

	j while
endw:	
	li $v0, print_int10
	move $a0, $t3
	syscall
	jr $ra
	