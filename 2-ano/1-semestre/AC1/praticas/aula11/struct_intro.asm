	.data
	.eqv print_str, 4
	.eqv print_char, 11
	.eqv print_float, 2
	.eqv print_intu10, 36
str1:	.asciiz "\nN. Mec: "
str2:	.asciiz "\nNome: "
str3:	.asciiz "\nNota: "

	.align 2 #neste caso é desnecessario(pq .word já alinha num mult de 4) mas pa garantir q a struct é mult de 4
stg:	.word 72343
	.asciiz "Napoleao"	# 9 bytes
	.space 9			# 9 + 9 = 18 bytes (first_name[18])
	.asciiz "Bonaparte"	# 10 bytes
	.space 5			# last_name[15]
	.float 5.1		
	.text
	.globl main
main:	la $a0, str1
	li $v0, print_str
	syscall		#print_str("N.Mec")
	
	
	la $t0, stg #	$t0 = &stg
	li $v0, print_intu10
	lw $a0, 0($t0)
	syscall		#print_intu10(stg.id_number)
	
	la $a0, str2
	li $v0, print_str
	syscall		#print_str("Nome")
	
	addiu $a0, $t0, 22
	li $v0, print_str
	syscall		#print_str(stg.last_name)
	
	li $v0, print_char
	li $a0, ','
	syscall
	
	addiu $a0, $t0, 4
	li $v0, print_str
	syscall			#print_str(stg.first_name)
	
	la $a0, str3
	li $v0, print_str
	syscall			#print_str("Nota")
	
	li $v0, print_float
	l.s $f12, 40($t0)
	syscall			#print_float(stg.grade)
	
	li $v0, 0	#return 0
	jr $ra