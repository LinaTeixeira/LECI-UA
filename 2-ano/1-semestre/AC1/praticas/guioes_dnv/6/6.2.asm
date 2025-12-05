	.data
	.eqv SIZE, 3
	.eqv print_str, 4
	.eqv print_char, 11
str1:	.asciiz "Array"
str2:	.asciiz "de"
str3:	.asciiz "Ponteiros"
array:	.word str1, str2, str3
	.text
	.globl main
# p: $t0
# *p: $t1
# pultimo: $t2
main:	la $t0, array	# p = array
	li $t3, SIZE
	sll $t3, $t3, 2
	add $t2, $t0, $t3	#pultimo = array +SIZE

for:	bgeu $t0, $t2, endfor
	lw $t1, 0($t0)
	
	li $v0, print_str
	move $a0, $t1
	syscall
	
	li $v0, print_char
	li $a0, '\n'
	syscall
	
	addiu $t0, $t0, 4
	j for
	
endfor:	jr $ra