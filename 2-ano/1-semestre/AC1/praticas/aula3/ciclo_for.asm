# mapa de registos:
#soma :		$t0
#value :		$t1
#i:		$t2
	.data
str1:	.asciiz "\nIntroduza um numero\n"	
str2:	.asciiz "Valor ignorado\n"
str3:	.asciiz "\nA soma dos positivos e': "

	.eqv print_str, 4
	.eqv read_int, 5
	.eqv print_int10, 1

	.text
	.globl main
main:	
	li $t2, 0		#i=0
	li $t0, 0		# soma = 0

for:	bge $t2, 5, endfor	#while(i<5) {
	la $a0, str1
	li $v0, print_str
	syscall			#print_string("introduza um valor")
	
	li $v0, read_int
	syscall
	#or St1, $v0, 0
	move $t1, $v0	# value = read_int
	
if:	ble $t1, 0, else		#if(value > 0)
	add $t0, $t0, $t1	# soma += value
	j endif
	
else:	la $a0, str2
	li $v0, print_str
	syscall
	
endif:	la $a0, str3
	li $v0, print_str
	syscall			#print_str(str3)
	
	move $a0, $t0
	li $v0, print_int10
	syscall
	
	addi $t2, $t2, 1		#i++ 
	j for		#}
	
endfor:
	jr $ra	