	.data
val:	.word 8,4,15,-1987,327,-9,27,16	
str1:	.asciiz "Digite 20 inteiros: "
str2:	.asciiz "Max/min: "
	.eqv SIZE, 8
	.eqv print_char, 11
	.eqv print_str, 4
	.eqv print_int10, 1
	.eqv read_int, 5
	.text
	.globl main
main:
	la $a0, str1
	li $v0, print_str
	syscall
	
	li $t1, 0
	li $t2, 0x7FFFFFFF
	li $t3, 0x80000000

do:	
	li $v0, read_int
	syscall
	move $t0, $v0

if:	beq $t0, 0, endif

if1:	ble $t0, $t3, endif1
	move $t3, $t0
endif1:
if2:	bge $t0, $t2, endif2
	move $t2, $t0
endif2:
endif:
	addi $t1, $t1, 1
while:	bge $t1, 20, endw
	beq $t0, 0, endw
	j do
endw:	
	li $v0, print_str
	la $a0, str2
	syscall
	
	li $v0, print_int10
	move $a0, $t3
	syscall
	
	li $v0, print_char
	li $a0, ':'
	syscall
	
	li $v0, print_int10
	move $a0, $t2
	syscall
	
	jr $ra