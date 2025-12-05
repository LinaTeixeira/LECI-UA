	.data
	.eqv SIZE, 5
array:	.word 5,27,3,11,56
	.text
	.globl main
# mapa de registos:
# i: $t0
# max1: $t1
# max2: $t2
main:	li $t1, 1 #max1 = 1
	sll $t1, $t1, 31 # max1= 1<<31
	move $t2,$t1	# max2 =  max1
	
	li $t0, 0 	#i=0
	la $t6, array

for:	bge $t0, SIZE, endfor	# for ( i < size)
	sll $t4, $t0, 2
	addu $t3 ,$t6 , $t4	
	lw $t5, 0($t3)		#$t3 = array[i]
	
if1:	ble $t5, $t1, else1	#if array[i] > max1
	move $t2, $t1	#max2 = max1
	move $t1, $t5
	j endif1
else1:
if2:	ble $t5, $t2, endif2	#if array[i] > max2
	bge $t5, $t1, endif2	# && array[i] < max1
	move $t2, $t5
endif2:
endif1:
	addi $t0, $t0, 1		#i++
	j for
endfor:	

	jr $ra