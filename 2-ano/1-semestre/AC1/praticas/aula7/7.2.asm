	.data
str:	.asciiz "ITED - orievA ed edadisrevinU"
	.eqv print_int10, 1
	.eqv print_str, 4
	.text
	.globl main
main:	addiu $sp, $sp, -4
	sw $ra, 0($sp)

	la $a0, str
	jal strrev
	
	move $a0, $v0
	li $v0, print_str
	syscall			#print_str(strrev(str))

	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	
	li $v0, 0	#return 0
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