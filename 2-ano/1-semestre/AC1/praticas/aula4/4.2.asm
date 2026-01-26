	.data
	.eqv read_str, 8
	.eqv print_int10, 1
	.eqv SIZE, 20
str:	.space 21
	.text
	.globl main
# num : $t0
# p: $t1
# *p : $t2
main:
	li $t0, 0 #num = 0
	
	la $a0, str
	li $a1, SIZE
	li $v0, read_str
	syscall
	la $t1, str #p =str

while:	lb $t2, 0($t1)
	beq $t2, '\0', endwhile

if:	blt $t2, '0', endif
	bgt $t2, '9', endif
	addi $t0, $t0, 1		#num++

endif:
	addi $t1, $t1, 1	#p++
	j while
endwhile:
	li $v0, print_int10
	move $a0, $t0 
	syscall
	jr $ra 
   