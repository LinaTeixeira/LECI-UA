	.data

S1:	.asciiz "AC1-2018"
	.align 2
A1:	.space 48
D2:	
	.text
	.globl main
main:	la $t0, S1
	la $t1, A1

	
	jr $ra