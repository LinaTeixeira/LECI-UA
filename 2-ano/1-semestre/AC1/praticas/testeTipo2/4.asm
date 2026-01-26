	.data
AA:	.asciiz "#F47D3FA2"
BB:	.word 5
CC:	.word 0x52, 0x126C, 0x3A, 0x139A8, 0xABA
UI:	.word 0x7C38
	.align 2
DD:	.space 4
	.text
	.globl main
	
main:	la $t1, AA
	la $t2, BB
	la $t3, CC
	la $t4, DD
	la $t5, UI
	
	la $t3, AA
	lw $t6, 0($t3)