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
# i : $t0
# &array : $t1
# &array[i] : $t2
# *array[i] : $t3
main:	li $t0,0		# i = 0
	la $t1, array
	
for:	bge $t0, SIZE, endfor

	la $t1, array
	sll $t2, $t0, 2
	addu $t2, $t1, $t2	# $t2 = &array[i]
	lw $t3, 0($t2)
	
	li $v0, print_str
	move $a0, $t3
	syscall
	
	li $v0, print_char
	li $a0, '\n'
	syscall
	
	addi $t0, $t0, 1
	j for
endfor:
	jr $ra