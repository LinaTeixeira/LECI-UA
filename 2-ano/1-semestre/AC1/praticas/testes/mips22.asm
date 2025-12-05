	.data
	.eqv read_int, 5
	.eqv print_int10, 1
	.eqv print_str,  4
str:	.asciiz "No set bits\n"
	.text
	.globl main
	
#	order : $t0 /   i : $t1   / num : $t2  / temp : $t3
main:	li $v0, read_int
	syscall
	li $t0, -1
	move $t2, $v0	#num = read_int
	li $t1, 0	# i= 0
	
do:	andi $t3, $t2, 1
	
if1:	bne $t3, 1, endif1  #if (num && 1) ==1
	move $t0, $t1	#order = i
endif1:
	srl $t2, $t2, 1	#num = num >> 1
	addi $t1, $t1, 1	#i++

while:	blt $t1, 32, do
if2:
	beq $t0, -1, else2  #if (order != -1)
	li $v0, print_int10
	move $a0, $t0
	syscall #prit_int10(order)
	j endif2
else2:
	li $v0, print_str
	la $a0, str	
	syscall		#print_str(str) 
	
endif2:	jr $ra