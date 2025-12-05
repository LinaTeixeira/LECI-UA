	.data
	.eqv SIZE, 4
	.eqv print_int10, 1
	.eqv
array:	.word 7692, 23, 5 ,234
	.text
	.globl main
# Mapa de registos
# p:		$t0
# pultimo:	$t1
# *p:		$t2
# soma:		$t3
main:
	li $t3, 0	#soma = 0
	la $t0, array
	
	li $t4, SIZE	#pultimo = size
	addi $t4, $t4, -1 	# $t4 = size -1
	sll $t4, $t4, 2		# $t4 * 4
	addu $t1, $t0, $t4  # pultimo = $t1 + p	
	
while:	bgtu $t0,$t1,endw
	lw $t2, 0($t0)		# $t2 = *p
	add $t3, $t3, $t2	#soma += *p
	addiu $t0, $t0, 4	#p = p+4 -- p++
	j while
endw:	
	move $a0, $t3
	li $v0, print_int10
	syscall
	jr $ra
