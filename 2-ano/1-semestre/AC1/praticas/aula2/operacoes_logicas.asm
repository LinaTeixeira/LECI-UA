	.data
	.text
	.globl main
	# $t1 = val_1 , $t2 = val_2
	# $t2 = AND , $t3 = OR, $t4 = NOR, $t5 = XOR, $t6 = NOT
main:	ori $t0, $0, 0xE543
	ori $t1, $0, 0xA3E4
	and $t2, $t0, $t1
	or $t3, $t0, $t1
	nor $t4, $t0, $t1
	xor $t5, $t0, $t1
	nor $t6, $t0, $0  # para not fazemos NOR com 0 ($0)
	
	jr $ra
	