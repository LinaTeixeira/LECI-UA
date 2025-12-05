	.data
	.eqv	SIZE, 10
	.eqv	read_int, 5
	.eqv	print_int10, 1
	.eqv	print_str, 4
	.eqv 	FALSE, 0
	.eqv	TRUE, 1
	.align 2
lista:	.space 40  # size * 4
str1:	.asciiz "\n Introduza um numero: "
str2:	.asciiz "\n Conteudo do array:\n "
str3: 	.asciiz "; "
	.text
	.globl main
# i: $t0
# lista: $t1
# *lista: $t2
# lista + i: $t3 	 
main:	li $t0, 0	# i = 0
	
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
##############################################
#houve_troca: $s0
#i: $s1
#lista: $s2
#lista +1: $s3

	la $s2, lista
do:
	li $s0, FALSE	# houve_troca = FALSE
	li $t5, 0	# i = 0
while:	bne $s0,, while 

##########################################	
# p: $t5
# *p: $t6
# lista + size: $t7
	la $a0, str1
	li $v0, print_str
	syscall		#print_str(str1)
	
	la $t5, lista  # p = &lista
	li $t8, SIZE	# $t8 = SIZE
	sll $t9, $t8, 2		# $t9 = lista * 4
	addu $t7, $t9, $t5	# $t7 = &lista + SIZE

for2:	bgeu $t5, $t7, endfor2	#for p < lista + SIZE
	lw $t6, 0($t5) 		# $t6 = *p
	
	move $a0, $t6
	li $v0, print_int10
	syscall			#print_int10(*p)
	
	la $a0, str2
	li $v0, print_str
	syscall			#print_str(str2)

	addiu $t5, $t5, 4	# p++
	j for2
endfor2:
	jr $ra