	.data
	.eqv print_int10, 1
	.eqv print_str, 4
	.eqv SIZE, 10
lista:	.word 8, -4, 3, 5, 124, -15, 87, 9, 27, 15
str2:	.asciiz "\nConteudo do array:\n"
str3:	.asciiz "; "
	.text
	.globl main
# p : $t4
# *p: $t5
# lista + SIZE : $t6
main:	la $a0, str2
	li $v0, print_str
	syscall 		#print_str(str)
	
	la $t4, lista	#p = lista
	li $t6, SIZE
	sll $t6, $t6, 2
	addu $t6, $t6, $t4	# $t6 = lista + SIZE
for:	bge $t4, $t6, endfor	#for ( p < lista + SIZE )
	
	lw $t5, 0($t4)	#$t5 = *p
	li $v0, print_int10
	move $a0, $t5
	syscall
	
	li $v0, print_str
	la $a0, str
	syscall

	addiu $t4, $t4, 4	#p++
	j for
endfor:
	jr $ra