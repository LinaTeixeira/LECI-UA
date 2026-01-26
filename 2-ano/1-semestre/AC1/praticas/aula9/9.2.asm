	.data
k1:	.double 5.0
k2:	.double 9.0
k3:	.double 32.0
str:	.asciiz "valor em Fahrenheit?: "
str1:	.asciiz "valor em Celsius: "
	.eqv read_double, 7
	.eqv print_double, 3
	.eqv print_str, 4
	.text
	.globl main
	
main:	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $v0, print_str
	la $a0, str
	syscall
	
	li $v0, read_double
	syscall
	
	mov.d $f12, $f0
	jal f2c		# f2c(double)
	
	li $v0, print_str
	la $a0,str1
	syscall
	
	li $v0, print_double
	mov.d $f12, $f0
	syscall

	li $v0, 0	#return 0
	
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	jr $ra

# ft : $f12
#		
f2c:	
	la $t0, k3
	l.d $f0, 0($t0)
	sub.d $f0, $f12, $f0	# $f0 = ft - 32
	
	la $t0, k1
	l.d $f2, 0($t0)	# $f2 = 5.0
	la $t0, k2
	l.d $f4, 0($t0)	# $f4 = 9.0
	div.d $f2, $f2, $f4	#$f4 = 5.0 / 9.0
	
	mul.d $f0, $f2, $f0	# return ( 5.0 / 9.0 * (ft - 32) 
	
	jr $ra