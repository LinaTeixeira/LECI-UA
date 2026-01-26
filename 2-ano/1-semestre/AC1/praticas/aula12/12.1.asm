	.data
	.eqv print_intu10, 36
	.eqv read_float, 6
	.eqv read_str, 8
	.eqv read_int, 5
	.eqv print_str, 4
	.eqv print_float, 2
	.eqv MAX_STUDENTS, 4
strNMEC:	.asciiz "N. Mec: "
str1N:	.asciiz "Primeiro nome: "
str2N:	.asciiz "Ultimo nome: "
strNota:	.asciiz "Nota: "
strM:	.asciiz "\nMedia: "
k20:	.float -20.0
k0:	.float 0.0
	.align 2
st_array: .space 176	# 4 * size_of(students)
	.align 2
media:	.space 4
	.text
	.globl main
#
# pmax : $t1
# media : #t2	
main:	addiu $sp, $sp, -4	
	sw $ra, 0($sp)

	la $a0, st_array
	li $a1, MAX_STUDENTS
	jal read_data	# read_data( st_array, MAX_STUDENTS)
	
	la $a0, st_array
	li $a1, MAX_STUDENTS
	la $a2, media
	jal max
	move $t1, $v0	# pmax = max( st_array, MAX_STUDENTS, &media)
	
	li $v0, print_str
	la $a0, strM
	syscall		#print_str("Media: "
	
	li $v0, print_float
	la $a0, media
	l.s $f12, 0($a0)
	syscall		#print_float( media)
	
	move $a0, $t1
	jal print_student	# print_student( pmax)
	
	li $v0, 0	# return 0
			
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	jr $ra

# st : $a0 -> $t0 (syscall)
# ns : $a1 -> $t1
# i : $t2
# $st[i] : $t3
read_data: 
	move $t0, $a0
	move $t1, $a1
	
	li $t2, 0	#i = 0
for:	bge $t2, $t1, endfor
	
	mulu $t4, $t2, 44
	addu $t3, $t0, $t4   # t3 = &st[i]
	 
	li $v0, print_str
	la $a0, strNMEC
	syscall		# print_str("N. Mec: ")
	
	li $v0, read_int
	syscall
	sw $v0, 0($t3)		# st[i].id_number = read_int()
	
	li $v0, print_str
	la $a0, str1N
	syscall			# print_str("Prim nome: ")
	
	li $v0, read_str
	addiu $a0, $t3, 4
	li $a1, 17
	syscall			# read_str(st[i].first_name, 17)
	
	li $v0, print_str
	la $a0, str2N
	syscall			# print_str("Ultim nome: ")
	
	li $v0, read_str
	addiu $a0, $t3, 22
	li $a1, 14
	syscall			# read_str(st[i].last_name, 14)
	
	li $v0, print_str
	la $a0, strNota
	syscall			# print_str("Nota: ")
	
	li $v0, read_float
	syscall
	s.s $f0, 40($t3)		# st[i].grade = read_float()
	
	addi $t2, $t2, 1	#i++
	j for
endfor:
	jr $ra

# p : $a0 -> $t0 (syscall)
print_student:
	move $t0, $a0
	li $v0, print_intu10
	lw $a0, 0($t0)
	syscall			#print_intu10(p->id_number)
	
	li $v0, print_str
	addiu $a0, $t0, 4
	syscall			#print_str(p->first_name)
	
	li $v0, print_str
	addiu $a0, $t0, 22
	syscall			#print_str(p->last_name)
	
	li $v0, print_float
	l.s $f12, 40($t0)
	syscall			#print_float(p->grade)
	
	jr $ra
	
# st : $a0
# ns : $a1
# media : $a2
# max_grade : $f0
# sum :$f2	
# p : $t1
# st + ns : $t2
# pmax : $t3
# p->grade : $f4
max:	la $t0, k20
	l.s $f0, 0($t0)		# max_grade = -20.0
	
	la $t0, k0
	l.s $f2, 0($t0)		#sum = 0.0
	
	move $t1, $a0	# p = st
	mulu $t2, $a1, 44
	addu $t2, $a0, $t2	# $t2 = ( st + ns) * 44
for1:	bge $t1, $t2, endfor1
	
	l.s $f4, 40($t1)		# $f4 = p->grade
	add.s $f2, $f2, $f4	# sum += p->grade
if1:	c.le.s $f4, $f0
	bc1t endif1		# if(p->grade > max_grade)
	
	mov.s $f0, $f4		# max_grade = p->grade
	move $t3, $t1		# pmax = p
	
endif1:	addiu $t1, $t1, 44	#p++
	j for1
	
endfor1: mtc1 $a1, $f6
	cvt.s.w $f6, $f6		# (float)ns
	div.s $f6, $f2, $f6	# $f6 = sum / (float)ns
	s.s $f6, 0($a2)		# *media = sum / (float)ns
	
	move $v0, $t3		# return pmax
	jr $ra