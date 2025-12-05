	.data
	.eqv	SIZE, 10
	.eqv	print_int10, 1
	.eqv	print_str, 4
	.align 2
lista:	.word 8, -4, 3, 5, 124, -15, 87, 9, 27, 15
str1:	.asciiz "\n Conteudo do array:\n "
str2: 	.asciiz "; "
	.text
	.globl main
# p: $t5
# *p: $t6
# lista + size: $t7
main:
	la $a0, str1
	li $v0, print_str
	syscall		#print_str(str1)
	
	la $t5, lista  # p = &lista
	li $t8, SIZE	# $t8 = SIZE
	sll $t9, $t8, 2		# $t9 = lista * 4
	addu $t7, $t9, $t5	# $t7 = &lista + SIZE * 4

for:	bgeu $t5, $t7, endfor	#for p < lista + SIZE
	lw $t6, 0($t5) 		# $t6 = *p
	
	move $a0, $t6
	li $v0, print_int10
	syscall			#print_int10(*p)
	
	la $a0, str2
	li $v0, print_str
	syscall			#print_str(str2)

	addiu $t5, $t5, 4	# p++
	j for
endfor:
	jr $ra
