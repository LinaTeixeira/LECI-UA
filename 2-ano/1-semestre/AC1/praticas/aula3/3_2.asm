# mapa de registos
# value:	 $t0
# bit: $t1
# i: $t2

	.data
str1	.asciiz "Introduza um numero:\n"
str2	.asciiz "\nO valor em binario e': "
	.eqv print_str, 4
	.eqv print_char, 11
	.eqv read_int, 5
	.text
	.globl main
	
main:	la $a0, str1
	li $v0, 4
	syscall
	li $v0, 5
	move $t0, $v0 	# value = read_int
	
	la $a0, str2
	li 
	