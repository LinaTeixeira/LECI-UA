	.data
X1:	.asciiz "TEST1"
	.align 2
X2:	.word 1,2,3,4,5
	.text
	.globl main
main:	
	la $t1, X2 #oi
	jr $ra