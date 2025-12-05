	.data
	.eqv print_string,4
str0:	.asciiz "uma string qualquer"
str1:	.asciiz "AC1-P"
str2:	.asciiz "OLA"
	.text
	.globl main
main:
	la $a0, str0 		#load address
	ori $v0, $0 , print_string
	syscall
	
	jr $ra