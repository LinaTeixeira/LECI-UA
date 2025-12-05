	.data
str0:	.asciiz "Digite ate 20 inteios(zero para terminar):"
str1:	.asciiz "Maximo/minimo sao: "
	.eqv print_str, 4
	.eqv print_char, 11
	.eqv print_int10, 1
	.eqv read_int, 5
	.text
	.globl main
#
# val: $t0
# n: $t1
# min: $t2
# max : $t3
main:	li $t2, 0x7FFFFFFF	#min = 0x7FFFFFFF
	li $t3, 0x80000000	#max = 0x80000000
	li $t1, 0	# n=0
	
	li $v0, print_str
	la $a0, str0
	syscall			# print_str(str0)
	
do:	li $v0, read_int
	syscall
	move $t0, $v0	#val = read_int
if1: 	beq $t0, $0, endif1	# if( val != 0)
if2:	ble $t0, $t3, endif2	# if (val > max)
	move $t3, $t0		# max = val
endif2:
if3:	bge $t0, $t2, endif3	# if ( val < min)
	move $t2, $t0	# min = val
endif3:
endif1:	addi $t1, $t1, 1	#n++
while:	bge $t1, 20, endw	#while ( n < 20 &&
	bne $t0, 0, do		# val != 0)	
endw:
	li $v0, print_str
	la $a0, str1
	syscall
	
	li $v0, print_int10
	move $a0, $t3
	syscall
	
	li $v0, print_char
	li $a0, ':'
	syscall
	
	li $v0, print_int10
	move $a0, $t2
	syscall




	jr $ra