	.data
	.eqv print_str, 4
	.eqv read_int, 5
	.eqv SIZE, 5
	.align 2
lista:	.space 20 #size * 4
str:	.asciiz "\nIntroduza um numero: "
	.text
	.globl main
# mapa:
# i:$t0
# lista: $t1
# lista + i = lista[i] : $t2
main:	li $t0, 0 # i=0
for:	bge $t0, SIZE, endfor	# for ( i < SIZE)
	
	la $t1, lista
	sll $t3, $t0, 2
	addu $t2, $t1, $t3 #lista[i] = $t2
	
	li $v0, print_str
	la $a0, str
	syscall	#print_str(str)
	
	li $v0, read_int
	syscall
	sw $v0, 0($t2)	#lista[i] = read_int()
	
	addiu $t0, $t0, 1	#i++
	j for
endfor:
	jr $ra