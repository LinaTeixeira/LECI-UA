	.data
	.eqv print_str, 4
str:	.asciiz "\n"
str1:	.asciiz "Arquitetura de "
str2:	.space 50
str3:	.asciiz "Computadores I"	
	.text
	.globl main
	
main:	addiu $sp, $sp, -4
	sw $ra, 0($sp) 

	la $a0, str2
	la $a1, str1
	jal strcpy	#strcpy(srt2, str1)
	
	la $a0, str2
	li $v0, print_str
	syscall		#print_str(str2)
	
	la $a0, str
	li $v0, print_str
	syscall		#print_str("\n")
	
	la $a0, str2
	la $a1, str3
	jal strcat	#strcat(str2, "Arquitetura ...")
	move $a0, $v0
	li $v0, print_str
	syscall		#print_str( strcat(str2, "Arquitetura ..."))
	
	li $v0, 0	#return 0

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
#####
# &dst : $a0 -> $s0
# p : $t4
# *dst : $t3
# &src : $a1
# *src : $t2
strcat:	addiu $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	move $s0, $a0	#calee saved		$s0 = &dst (p)
	move $t4, $a0	#char *p = dst
	
while2:	lb $t3, 0($t4)	# 	       --	*dst : $t3
	beq $t3, '\0', endw2
	addiu $t4, $t4, 1	#p++
	
	j while2
endw2:	move $a0, $t4
	#move $a1, $a1
	jal strcpy	#strcpy(p, src)
	
	move $v0,$s0	#return dst
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addiu $sp, $sp, 8
	jr $ra