	.data
SIZE	.eqv 10
	.eqv read_float, 7
	.eqv print_double, 3
	.eqv print_str, 4
str1:	.asciiz "Reultado: "
k0:	.double 0.0
k1:	.double 1.0
k5:	.double 0.5
	.text
	.text
	.globl main
main:	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	
	
	

	lw $ra, 0($sp)
	addiu $sp, $sp, 4


	jr $ra