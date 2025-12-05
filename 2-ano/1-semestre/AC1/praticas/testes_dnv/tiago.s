	.data
	.eqv SIZE, 8
	.eqv print_int10, 1
	.eqv print_str, 4
	.eqv print_char, 11
val:	.word 8, 4, 15, -1987, 327, -9, 27, 16
str:	.asciiz "Result is: "
	.text
	.globl main

# Mapa de Registos
# $t0:	i
# $t1:	i*4
# $t2:	SIZE
# $t3:	&val
# $t4:	val[i]
# $t5:	&val[i]
# $t6:	SIZE*4
# $t7: 	SIZE*4/2
# $t8:	&val[i + SIZE/2]
# $t9: 	val[i + SIZE/2]

main:	li $t0, 0		# i = 0
	la $t3, val		# $t3 = &val
	li $t2, SIZE		# $t2 = SIZE
	sll $t6, $t2, 2		# $t6 = SIZE*4
	srl $t7, $t6, 1		# $t7 = SIZE*4/2

do:	sll $t1, $t0, 2		# $t1 = i*4
	addu $t5, $t3, $t1 	# $t5 = &val[i]
	lw $t4, 0($t5)		# $t4 = val[i]
	
	add $t8, $t7, $t1	# $t8 = i + SIZE/2
	addu $t8, $t3, $t8	# $t8 = &val[i + SIZE/2]
	lw $t9, 0($t8)		# $t9 = val[i + SIZE/2]
	
	sw $t9, 0($t5)		# val[i] = val[i + SIZE/2]
	sw $t4, 0($t8)		# val[i + SIZE/2] = val[i]
	
	addi $t0, $t0, 1	# ++i
	
	srl $a0, $t2, 1		# $a0 = SIZE/2
while: 	blt $t0, $a0, do	# ( i < SIZE/2 )

	li $t0, 0		# i = 0

do2:	li $v0, print_int10
	sll $t1, $t0, 2		# $t1 = i*4
	addu $t5, $t3, $t1	# $t5 = &val[i]
	lw $t4, 0($t5)		# $t4 = val[i]
	
	move $a0, $t4		# $a0 = val[i]
	syscall			# print_int10(val[i])
	
	addi $t0, $t0, 1	# i++
	
	li $a0, ','		# $a0 = ','
	li $v0, print_char
	syscall			# print_char(',')
	
while2: blt $t0, $t2, do2	# while ( i < SIZE )
	
	jr $ra