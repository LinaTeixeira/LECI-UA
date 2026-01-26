	.data
	.eqv read_int, 5
	.eqv print_str, 4
	.eqv MAX_SIZE, 33
str:	.space 33
	.text
	.globl main
	
# val : $s0
main:	addiu $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	
do3:	li $v0, read_int
	syscall
	move $s0, $v0	# val = read_int()
	
	move $a0, $s0
	li $a1, 2
	la $a2, str
	jal itoa		# itoa(val, 2, str)
	
	move $a0, $v0
	li $v0, print_str
	syscall		# print_str( itoa( val, 2, str))
	
	move $a0, $s0
	li $a1, 8
	la $a2, str
	jal itoa		# itoa(val, 8, str)
	
	move $a0, $v0
	li $v0, print_str
	syscall		# print_str( itoa( val, 8, str))
	
	move $a0, $s0
	li $a1, 16
	la $a2, str
	jal itoa		# itoa(val, 16, str)
	
	move $a0, $v0
	li $v0, print_str
	syscall		# print_str( itoa( val, 16, str))

while3:	bne $s0, 0, do3	#while( val != 0)

	li $v0, 0	#return 0
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
	
# n : $a0 -> $s0
# b : $a1 -> $s1
# s : $a2 -> s2
# p: $s3
# digit : $t0
itoa:	addiu $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a2	# char *p = s

	
do:		
	rem $t0, $s0, $s1	# digit = n % b
	div $s0, $s0, $s1	# n = n % b
	
	move $a0, $t0
	jal toascii	# toascii( digit)
	sb $v0, 0($s3)	# p = toascii (digit)
	addiu $s3, $s3, 1	# *p++

while:	bgt $s0, 0, do		#while ( n > 0)
	
	sb $0, 0($s3)		# *p = '\0'
	
	move $a0, $s2
	jal strrev	#strrev( s)
	
	move $v0, $s2	# return s
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addiu $sp, $sp, 20
	jr $ra

# v : $a0
toascii: addi $a0, $a0, '0'	# v += '0'
if0:	ble $a0, '9', endif0	# if ( v > '9')
	addi $a0, $a0, 7		# v += 7

endif0:	move $v0, $a0	#return v
	jr $ra
	
# str : $a0 -> $s0
# p1 : $s1
# p2 : $s2			
strrev:	addiu $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	move $s0, $a0	# $st0 = *str
	move $s1, $a0	# char *p1 = str
	move $s2, $a0	# char *p2 = str
	
while1:	lb $t0,0($s2)
	beq $t0, '\0', endw1	#while(*p2 != '\0')
	addiu $s2, $s2, 1	#p2++
	j while1
	
endw1:	addiu $s2, $s2, -1	#p2--

while2:	bgeu $s1, $s2, endw2	#while( p1 < p2)

	move $a0, $s1
	move $a1, $s2
	jal exchange	#exchange(p1, p2)
	
	addiu $s1, $s1, 1
	addiu $s2, $s2, -1

	j while2
endw2:

	move $v0, $s0	#return str
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addiu $sp, $sp, 16
	jr $ra	
	
# *c1 : $t1
# *c2 : $t2	
exchange:
	lb $t1, 0($a0)	# $t1 = *c1
	lb $t2, 0($a1)	# $t2 = *c2
	sb $t2, 0($a0)
	sb $t1, 0($a1)	
	
	jr $ra