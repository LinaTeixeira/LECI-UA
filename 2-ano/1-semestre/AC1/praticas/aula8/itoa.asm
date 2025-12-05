	.data
	.text
	.globl main

main:
	
	
	

	jr $ra
	
# mapa de registos:
# n:	$a0 -> $s0
# b:	$a1 -> $s1
# s:	$a2 -> $s2
# p:	$s3
#digit: $t0
itoa:	addiu $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $ra, 16($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $s2	#*p = s2

	
do:


while:	rem $t0,$s0, $s1		# digit = n % b
	div $s0, $s0, $s1	# n = n / b
	
	move $a0, $t0
	jal toascii		#*p = toascii(digit)
	sw $s3,0($v0)		
	addi $s3, $s3, 1		#p++
	bge $s0, 0, do		#while (n>0)
	sb $s3, 
	
	
	
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)
	addiu $sp, $sp, 20
	jr $ra
	

	