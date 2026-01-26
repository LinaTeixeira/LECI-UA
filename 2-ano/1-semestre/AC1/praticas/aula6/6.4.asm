	.data
str0:	.asciiz "Nr. de parametros"
str2:	.asciiz ": "
str1:	.asciiz "\nP"
	.eqv print_str, 4
	.eqv print_int10, 1
	.text
	.globl main
# argc : $a0 -> $t0 
# i : $t1
# argv : $a1 -> $t2
# argv[i] : $t3
main:
	move $t0, $a0
	move $t2, $a1
	la $a0, str0
	li $v0, print_str
	syscall			#print_string(str)
	
	li $v0, print_int10
	move $a0, $t0
	syscall			#print_int10(argc)
	
	li $t1, 0		# i = 0
for:	bge $t1, $t0, endfor	#for (i<argc)
	
	li $v0, print_str
	la $a0, str1
	syscall			#print_str("\nP")
	
	li $v0, print_int10	
	move $a0, $t1
	syscall			#print_int10(i)
	
	li $v0, print_str
	la $a0, str2		
	syscall			#print_str(": ") 
	

	sll $t3, $t1, 2
	addu $t4, $t2, $t3
	
	lw $t4, 0($t4)
	move $a0, $t4
	syscall 
	
	addi $t1, $t1, 1		#i++
	j for
endfor:


	jr $ra