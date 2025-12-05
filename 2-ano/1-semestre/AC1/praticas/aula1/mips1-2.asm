	.data
		# y =2x - 8
		# x = $t0
		# y = $t1
	.text
	.globl main
main: 	ori $v0, $0, 5  # syscall 5(read_int)
	syscall
	or $t0, $0, $v0 # $t0 = x
	ori $t2,$0,8 # $t2 = 8
	add $t1,$t0,$t0 # $t1 = $t0 + $t0 <==> x + x <==> 2 * x
	sub $t1,$t1,$t2 # $t1 = $t1 + $t2 <==> y = 2 * x - 8
	
	or $a0, $0, $t1  # $a0 = y -> para printar y
	ori $v0, $0, 1 # syscall 1(print_int10)
	syscall
	
	ori $v0, $0, 34  # syscall 34 (print_int16)
	syscall
	
	ori $v0, $0, 36 # syscall 36 (print_intu10)
	syscall
	jr $ra # fim do programa
