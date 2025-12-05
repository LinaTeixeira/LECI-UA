# mapa de registos
# value:	 $t0
# bit: $t1
# i: $t2

	.data
str1:	.asciiz "Introduza um numero:\n"
str2:	.asciiz "\nO valor em binario e': "
	.eqv print_str, 4
	.eqv print_char, 11
	.eqv read_int, 5
	.text
	.globl main
	
main:	la $a0, str1
	li $v0, print_str
	syscall
	
	li $v0, read_int
	syscall
	move $t0, $v0 	# value = read_int
	
	la $a0, str2
	li $v0, print_str
	syscall	#print_string(str2)
	
	li $t2, 0 # i = 0
	li $t3, 0x80000000 
	
for:	bge $t2, 32, endfor #for i<32
	and $t1, $t0 ,$t3  # bit = value & 0x80000000
	
	rem $t4, $t2, 4	# $t4 = i%4
if1:    bne $t4, 0, endif1 #if (i%4) == 0

	li $a0, ' '
	li $v0, print_char
	syscall
endif1:	
###############################
if:	beq $t1, 0, else  #if bit!= 0
	li $a0, '1'
	li $v0, print_char
	syscall
	
	j endif
	
else:
	li $a0, '0'
	li $v0, print_char
	syscall
	
endif:	sll $t0, $t0, 1
	addi $t2, $t2, 1 # i++
	
	j for	
endfor:
	jr $ra
	