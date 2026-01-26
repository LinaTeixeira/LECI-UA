	.data
	.eqv print_str, 4
	.eqv print_char, 11
	.eqv print_float, 2
	.eqv print_intu10, 36
str1:	.asciiz "\nN. Mec: "
str2:	.asciiz "\nNome: "
str3:	.asciiz "\nNota: "

	.align 2
stg:	.word 72343
	.asciiz "Napoleao" #9 bytes
	.space 9		# +9
	.asciiz "Bonaparte" #10
	.space 5		# + 5 bytes
	.float 5.1
	.text
	.globl main
#stg : $t0	
main:	la $t0, stg

	li $v0, print_str
	la $a0, str1
	syscall		#print_str("\nN Mec: ")
	
	li $v0, print_intu10
	lw $a0, 0($t0)
	syscall		#print_intu10(stg.id_number)
	
	li $v0, print_str
	la $a0, str2
	syscall		#print_str("\nNome: ")
	
	li $v0, print_str
	addiu $a0, $t0, 22
	syscall		#print_str(stg.last_name)
	
	li $v0, print_char
	li $a0, ','
	syscall
	
	li $v0, print_str
	addiu $a0, $t0, 4
	syscall		#print_str(stg.first_name)
	
	li $v0, print_str
	la $a0, str3
	syscall		# print_str("Nota: ")
	
	li $v0, print_float
	l.s $f12, 40($t0)
	syscall		#print_float(stg.grade)
	
	li $v0, 0	#return 0
	jr $ra