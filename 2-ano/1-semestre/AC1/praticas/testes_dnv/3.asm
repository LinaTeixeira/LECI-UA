	.data
	.eqv print_str, 4
	.eqv print_int10, 1
	.eqv print_char, 11
	.eqv read_int, 5
	.eqv N, 5
	.eqv Nx4, 20
	.align 2
a:	.space Nx4
	.align 2
a2:	.space Nx4		#b dá erro
	.text
	.globl main
#  : $t0
# p1 : $t1
# p2  : $t2
# *p1 : $t3
# *p2 : $t4
# n_even : $t5
# n_odd : $t6
# a+N : $t7
main:	li $t5, 0 #n_even = 0
	li $t6, 0 #n_odd = 0
	la $t1, a	# p1 = &a
	li $t7, N
	sll $t7, $t7, 2 #$t7 = N*2
	addu $t7, $t1, $t7	# $t7 = a+N
for1:	bge $t1, $t7, endfor1	#for( p1 < a+N )
	
	li $v0, read_int
	syscall
	sw $v0, 0($t1)	# *p1 = read_int()

	addiu $t1, $t1, 4	#p1++
	j for1
endfor1:
	la $t1, a	# p1 = a
	la $t2, a2	# p2 = a2(b)	
for2: 	bge $t1, $t7, endfor2	# for(p1 < (a + N)) 

if:	lw $t3, 0($t1)	#$t3 = *p1 
	rem $t0, $t3, 2	#$t0 = *p1 % 2
	beq $t0, $0, else
	
	sw $t3, 0($t2)	#*p2++ = *p1
	addiu $t2, $t2, 4
	addi $t6, $t6, 1 #n_odd++
	j endif
else:
	addi $t5, $t5, 1	#n_even++ 
endif:
	addiu $t1, $t1, 4	#p1++
	j for2
endfor2:
	la $t2, a2	#p2 = a2(b)
	sll $t6, $t6, 2
	addu $t8, $t2, $t6	# $t8 = b + n_odd 
for3:	
	bge $t2, $t8, endfor3
	
	li $v0, print_int10
	lw $a0, 0($t2)
	syscall			#print_int10(*p2)
	
	addiu $t2, $t2, 4	#p2++
	j for3
endfor3:
	jr $ra