	.data
	.eqv	SIZE, 5 # size*4
	.eqv	read_int, 5
	.eqv	print_str, 4
	.align 2
lista:	.space 20  # size * 4
str1:	.asciiz "\n Introduza um numero: "
	.text
	.globl main
# i: $t0
# lista: $t1
# *lista: $t2
# lista + i: $t3 	 
main:
	
	li $t0, 0	# i = 0
	
for:	bge $t0, SIZE, endfor  #for i<SIZE
	la $a0, str1	
	li $v0, print_str  #print_str(str1)
	syscall
	
	li $v0, read_int
	syscall
	la $t1, lista		# $t1 = &lista
	sll $t4, $t0, 2		# $t4 = i * 4
	addu $t2, $t1, $t4	# $t2 = &lista + i
	
	sw $v0, 0($t2)
	addi $t0, $t0, 1 #i++
	j for
	
endfor:
	jr $ra