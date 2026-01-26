	.data
	.eqv STR_MAX_SIZE, 30
str1:	.asciiz "I serodatupmoC ed arutetiuqrA"
str2:	.space 31	#str2[STR_MAX_SIZE + 1]
str:	.asciiz "\n"
str3:	.asciiz "String too long: "
	.eqv print_int10, 1
	.eqv print_str, 4
	.text
	.globl main
# exit_value : $t0
main:	addiu $sp, $sp, -4
	sw $ra, 0($sp)

if0:	la $a0, str1
	jal strlen	#strlen(str1)
	bgt $v0, STR_MAX_SIZE, else0	# if(strlen(str1) <= STR_MAX_SIZE)
	
	la $a0, str2
	la $a1, str1
	jal strcpy	#strcpy(str2, str1)
	move $a0, $v0
	li $v0, print_str
	syscall		#prin_str(str2) 
	
	la $a0, str
	li $v0, print_str
	syscall		#print_str("\n")
	
	la $a0, str2
	jal strrev
	move $a0, $v0
	li $v0, print_str
	syscall		#print_str(strrev(str2))
	li $t0, 0	#exit_value = 0
	j endif0
	
else0:	li $v0, print_str
	la $a0, str3
	syscall		#print_str("String too long")
	
	la $a0, str1
	jal strlen
	move $a0, $v0
	li $v0, print_int10
	syscall		#print_int10(strlen(str1))
	li $t0, -1	#exit_value = -1	
endif0:
	
	move $v0, $s0	#return exi_value
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	jr $ra
# $dst : $a0 -> $t0
# &src : $a1 -> $t1
# *src : $t2	
strcpy:	move $t0, $a0	# $t0 = &dst = *p
	move $t1, $a1
do3:	lb $t2, 0($t1)	# $t2 = *src
	sb $t2, 0($t0)
	addiu $t0, $t0, 1	#*p++
	addiu $t1, $t1, 1	# *src++
	
while3: bne $t2,'\0', do3 
	move $v0, $a0		#return dst
	jr $ra
######
# len : $t1
# *s : $a0 -> $t0
strlen:	li $t1, 0	#len = 0
	
	
while:	lb $t0, 0($a0)	#$t0 = *s
	addiu $a0, $a0, 1		#s++
	beq $t0, '\0', endw
	addi $t1, $t1, 1		#len++
	j while
endw:
	move $v0, $t1		#return len
	jr $ra
#####
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
