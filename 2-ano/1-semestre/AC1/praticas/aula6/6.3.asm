	.data
	.eqv SIZE, 3
	.eqv print_int10, 1
	.eqv print_str, 4
	.eqv print_char, 11
str:	.asciiz "\nString #"
str0:	.asciiz ": "
str1:	.asciiz "Array"
str2:	.asciiz "de"
str3:	.asciiz "Ponteiros"
array:	.word str1, str2, str3
	.text
	.globl main
# i : $t0
# j : $t4
# array[i][j] : $t5
main:	li $t0, 0	# i = 0
for:	bge $t0, SIZE, endfor
	
	li $v0, print_str
	la $a0, str
	syscall
	
	li $v0, print_int10
	move $a0, $t0
	syscall
	
	li $v0, print_str
	la $a0, str0
	syscall
	
	li $t4, 0	# j = 0
while:	la $t5, array
	sll $t2, $t0, 2
	addu $t5, $t5, $t2
	lw $t5, 0($t5)
	addu $t5, $t5, $t4
	lb $t5, 0($t5)
	
	beq $t5, 0, endw
	
	li $v0, print_char
	move $a0, $t5
	syscall
	li $a0,'-'
	syscall
	addi $t4, $t4, 1
	j while
endw:
	addi $t0, $t0, 1	#i++
	j for
endfor:
	jr $ra