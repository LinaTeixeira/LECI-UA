	.data
	.eqv SIZE, 3
	.eqv print_str, 4
	.eqv print_char, 11
	.eqv print_int10, 1
array:	.word str1, str2, str3
str1:	.asciiz "Array"
str2:	.asciiz "de"
str3:	.asciiz "ponteiros"
str4:	.asciiz "\n String #"
str5:	.asciiz ": "
	.text
	.globl main
#mapa de registos
# i: $t0
# j: $t1
# array [i][j]: $t3
main:	
	li $t0, 0  # i=0

for:	bge $t0, SIZE, endfor	#for i < SIZE
	la $a0, str4
	li $v0, print_str
	syscall			#print_str(str4)
	
	move $a0, $t0
	li $v0, print_int10
	syscall 			#print_int10(i)
	la $a0, str5
	li $v0, print_str
	syscall			#print_str(": ")
	
	li $t1, 0		# j = 0

while:	
	la $t3,array		# $t3 = &array
	sll $t2, $t0, 2		#
	addu $t3, $t3, $t2
	lw $t3, 0($t3)
	addu $t3, $t3, $t1	#$t3 = &array[i][j] = *(array[i] + j)
	lb $t3, 0($t3)		#
	beq $t3, '\0', endwhile	#while (array[i][j] != 0)	
	
	li $v0, print_char
	move $a0, $t3
	syscall			#print_char(array[i][j])
	
	li $a0, '-'
	syscall			#print_char('-')
	
	addi $t1, $t1, 1		#j++
	j while
endwhile:
	addi $t0, $t0, 1	#i++
	j for
endfor:

	jr $ra