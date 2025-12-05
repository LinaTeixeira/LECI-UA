	.data
	.eqv read_float, 6
	.eqv read_str, 8
	.eqv print_str, 4
	.eqv print_char, 11
	.eqv print_float, 2
	.eqv print_intu10, 36
	.eqv read_int, 5
str1:	.asciiz "\nN. Mec: "
str2:	.asciiz "\nNome: "
str3:	.asciiz "\nNota: "
str4:	.asciiz "Primeiro Nome: "

	.align 2		#stg em endereço mult de 4
stg:	.space 44
	.text
	.globl main
	
main:	la $a0, str1
	li $v0, print_str
	syscall
	
	la $t0, stg
	
	li $v0, read_int
	syscall
	sw $v0, 0($t0)		#nmec
	
	la $a0, str4
	li $v0, print_str
	syscall		#print_str(prim nome)
	
	addiu $a0, $t0, 4
	li $a1, 17
	li $v0, read_str
	syscall		#read_string(str.first_name, 17)
	
	addiu $a0, $t0, 22
	li $a1, 14
	li $v0, read_str
	syscall
	
	li $v0, read_float
	syscall
	s.s $f0, 40($t0)
		
#####
	la $a0, str1
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