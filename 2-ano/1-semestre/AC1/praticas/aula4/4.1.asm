	.data
	.eqv read_str, 8
	.eqv print_int10, 1
	.eqv SIZE, 20
str:	.space 21
	.text
	.globl main
# num : $t0
# i: $t1
# str : $t2
#&str[i] : $t3
#*str[i] : $t4
main:
	la $a0, str
	li $a1, SIZE
	li $v0, read_str
	syscall	#read_str(str, SIZE)
	
	li $t0, 0	#num = 0
	li $t1, 0	# i = 0
	
while:	la $t2, str	# $t2 = &str
	addu $t3, $t2, $t1	# $st3 = &str[i] -- $t3 = str + i
	lb $t4, 0($t3)	# $t4 = *str[i]
	beq $t4, '\0', endwhile	#while( str[i] != 0)
	
if:	blt $t4, '0', endif
	bgt $t4, '9', endif
	addi $t0, $t0, 1 #num++

endif:	addi $t1, $t1, 1	#i++
	j while
endwhile:
	li $v0, print_int10
	move $a0, $t0
	syscall
	jr $ra