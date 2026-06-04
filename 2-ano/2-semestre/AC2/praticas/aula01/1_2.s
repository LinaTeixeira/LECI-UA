    
    .equ GET_CHAR, 2
    .equ PUT_CHAR, 3
    .equ PRINT_INT, 6
    .data
    .text
    .globl main

# c = $t0
# cnt = $t1
main:
    li $t1, 0   #int cnt = 1

do:
    li $v0, GET_CHAR
    syscall # c = getChar

    move $a0, $v0
    addi $a0, $a0, 1    
    li $v0, PUT_CHAR
    syscall     # putChar(c +1 )

    addi $t1, $t1, 1    #cnt++

    addi $a0, $a0, -1   #para putChar(c+1)
while: bne $a0, '\n', do

    li $v0, PRINT_INT
    move $a0, $t1
    li $a1, 10
    syscall         # printInt(cnt, 10)

    li $t0, 0       # return 0

    jr $ra
