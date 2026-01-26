	.data
str:	.asciiz "Arquitetura de Computadores I"
	.eqv print_int10, 1
	.text
	.globl main
	
main:	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $a0, str
	jal strlen	#strlen(str)
	move $a0, $v0	
	li $v0, print_int10
	syscall		#print_int10(strlen(str)
	
	li $v0, 0	#return 0
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	jr $ra
	
	
# len : $t1
# *s : $a0 -> $t0
#	
strlen:	li $t1, 0	#len = 0
	
	
while:	lb $t0, 0($a0)	#$t0 = *s
	addiu $a0, $a0, 1		#s++
	beq $t0, '\0', endw
	addi $t1, $t1, 1		#len++
	j while
endw:
	move $v0, $t1		#return len
	jr $ra