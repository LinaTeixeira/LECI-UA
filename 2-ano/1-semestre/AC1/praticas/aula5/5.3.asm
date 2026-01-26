	.data
	.eqv SIZE, 10
	.eqv TRUE, 1
	.eqv FALSE, 0
	.eqv print_str, 4
	.eqv read_int, 5
	.eqv print_int10, 1
	.align 2
lista:	.space 40 #size * 4
str:	.asciiz "\nIntroduza um numero: "
str2:	.asciiz "\nConteudo do array:\n"
str3:	.asciiz "; "
	.text
	.globl main
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
################################
# i : $s1 
# SIZE-1 = $s2 
# houvetroca = $s5
# lista: $s6
# lista + i : $s7

	la $s0, lista
do:	li $s5, FALSE	# houveTroca = FALSE
	li $s1, 0	# i = 0
	
for3:	li $s2, SIZE
	addi $s2, $s2, -1
	sll $s2, $s2, 2	#$s2 = SIZE-1
	bge $s1, $s2, endfor3	#for ( i<SIZE-1)
	
if3:	sll $s4, $s1, 2
	addu $s6, $s4, $s0	# $s6 = &lista[i]
	lw $s7, 0($s6)	#$s7 = *lista[i]
	lw $s3, 4($s6)	#$s3 = *lista[i+1]

	ble $s7, $s3, endif3	#if(lista[i] > lista[i+1])
	
	sw $s3, 4($s6)	# lista[i] = *lista[i+1]
	sw $s7, 0($s6)	#lista[i+1] = lista[i]
	li $s5, TRUE	#houveTroca = TRUE		
endif3:
	addiu $s1, $s1, 4
	j for3
endfor3:

while: beq $s5, TRUE, do
#################################
# p : $t4
# *p: $t5
# lista + SIZE : $t6
	la $a0, str2
	li $v0, print_str
	syscall 		#print_str(str)
	
	la $t4, lista	#p = lista
	li $t6, SIZE
	sll $t6, $t6, 2
	addu $t6, $t6, $t4	# $t6 = lista + SIZE
for2:	bge $t4, $t6, endfor2	#for ( p < lista + SIZE )
	
	lw $t5, 0($t4)	#$t5 = *p
	li $v0, print_int10
	move $a0, $t5
	syscall
	
	li $v0, print_str
	la $a0, str3
	syscall

	addiu $t4, $t4, 4	#p++
	j for2
endfor2:	jr $ra