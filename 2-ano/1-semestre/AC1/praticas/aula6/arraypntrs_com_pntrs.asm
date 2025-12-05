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
# p: $t1
# pultimo: $t2
# p*: $t3
main:	
	la $t1, array #p = &array
	li $t0, SIZE  #i = SIZE 
	sll $t0, $t0, 2
	addu $t2, $t1, $t0 # pultimo = array + size*4
	
for:	bgeu $t1, $t2, endfor	#for p < pultimo
	
	lw $a0, 0($t1)
	li $v0, print_str
	syscall			#print_str(*p)
	
	li $a0, '\n'
	li $v0, print_char
	syscall			#print_char('\n')
	
	addiu $t1, $t1, 4  #p++
	j for
endfor:
	
	jr $ra