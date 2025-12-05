	.data
	.eqv print_str, 4
	.eqv read_str, 8
	.eqv SIZE, 20
str1:	.asciiz "Introduza uma string: "
str:	.space 21
	.text
	.globl main
# p : $t0
# *p: $t1
# SIZE : $t2
# : $t3
#  : $t4
main: 	li $v0, print_str
	la $a0, str1
	syscall #print_str(introduza uma string)
	
	li $v0, read_str
	la $a0, str
	li $a1, SIZE
	syscall
	la $t0, str	#p = str
	
while:	lb $t1, 0($t0)	#$t1 = *p
	beq $t1, '\0', endw
	
if:	ble $t1,0x60, endif 	# branch pq n e letra
	bge $t1, 0x7A, endif	# branch pq pode ser minuscula
	addiu $t1, $t1, -0x61
	addiu $t1, $t1, 0x41
	sb $t1, 0($t0)		#*p = *p - 'a' + 'A'
		
endif:	addiu $t0, $t0, 1	#p++
	j while
endw:
	li $v0, print_str
	la $a0, str
	syscall
	jr $ra