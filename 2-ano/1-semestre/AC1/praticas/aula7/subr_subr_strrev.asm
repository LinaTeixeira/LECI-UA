	.data
str1:	.asciiz "ITED - orievA ed edadisrevinU"
	.text
	.eqv print_int10, 1
	.globl main
# $s1: p1
# $s2: p2
# str : $a0 -> $s0
main:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $a0, str1
	jal strrev
	
	move $a0, $v0
	li $v0, 4
	syscall 
	lw $ra, 0($sp)
	jr $ra
# $t1 = c1
# $t2 =c2
# $t3 = aux	
exchange:
	lb $t3, 0($a0)
	lb $t2, 0($a1)
	sb $t3, 0($a1)
	sb $t2, 0($a0)
	jr $ra
	
# pi : $s1
# p2: $s2
# str : $a0 -> $s0
strrev:	addiu $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	move $s0, $a0
	move $s1, $a0	#*p1 = str
	move $s2, $a0	#*p2 = str  
	
while1:	lb $t0, 0($s2)
	beq $t0, '\0', endw1
	addiu $s2, $s2, 1
	
	j while1
endw1:
	addi $s2, $s2, -1

while2:	bgeu $s1, $s2, endw2
	move $a0, $s1	# exchange(p1
	move $a1, $s2	# ,p2)
	jal exchange
	
	addi $s1, $s1, 1
	addi $s2, $s2, -1
	j while2
endw2:
	move $v0, $s0
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addiu $sp, $sp, 16
	jr $ra
