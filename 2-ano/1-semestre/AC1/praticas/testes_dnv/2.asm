	.data
	.eqv print_str, 4
	.eqv print_int10, 1
	.eqv print_char, 11
	.eqv SIZE, 8
str:	.asciiz "Result is: "
val:	.word 8,4,15,-1987,327,-9,27,16
	.text
	.globl main
# &val : $t0
# i : $t1
# v (*val[i]) : $t2
# &val[i] : $t3
# SIZE*4 : $t4
main:	li $t1, 0	# i = 0
	la $t0, val	# $t0 = &val
do:	sll $t3, $t1, 2 #$t3 = i*4
	addu $t3, $t3, $t0	#$t3 = &val[i]
	lw $t2, 0($t3)		#$t2 = v = *val[i]	
	
	li $t4, SIZE
	sll $t4, $t4, 2
	srl $t5, $t4, 1 #$t5 = SIZE/2
	addu $t5, $t5, $t3	# $t5 = &val[i+SIZE/2]
	lw $t6, 0($t5)		# $t6 = *val[i+SIZE/2]
	
	sw $t6, 0($t3)		#val[i] = val[i+SIZE/2]
	sw $t2, 0($t5)		#val[i+SIZE/2] = val[i]
	
	addi $t1, $t1, 1	#++i
while:	blt $t1, 4, do # while (++i < SIZE/2)

	li $v0, print_str
	la $a0, str
	syscall		#print_str("Result is)
	li $t1, 0	# i = 0
	
do2:	sll $t2, $t1, 2	#i*4
	addu $t2, $t2, $t0	# $t2 = &val[i]
	lw $a0, 0($t2)
	li $v0, print_int10
	syscall			#print_int10(val[i])
	addi $t1, $t1, 1		#i++
	
	li $v0, print_char
	li $a0, ','	
	syscall			# print_char(',')
while2:	blt $t1, SIZE, do2
	jr $ra