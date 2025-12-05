	.data
	.eqv SIZE, 3
	.eqv print_str, 4
	.eqv print_char, 11
array:	.word str1, str2, str3
str1:	.asciiz "Array"
str2:	.asciiz "de"
str3:	.asciiz "ponteiros"
	.text
	.globl main
#mapa de registos
# i: $t0
# &array[0]: $t1
# &array[i]: $t2
main:	
	li $t0,0
	
for:	bge $t0, SIZE, endfor	#for i<SIZE
	la $t1, array		#$t1 = &array[0]
	sll $t2, $t0, 2  	# $t2 = SIZE*4
	addu $t2,$t1, $t2	#$t2 = &array[0] + SIZE*4
	
	lw $a0,0($t2)
	li $v0, print_str
	syscall 			#print_str(array[i])
	
	li $a0, '\n'
	li $v0, print_char
	syscall			#print_char('\n')

	addi $t0, $t0, 1		#i++
	j for
endfor:
	jr $ra