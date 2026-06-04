    .equ ADDR_HIGH, 0xBf88
    .equ TRISE, 0x6100
    .equ LATE, 0x6120
    .equ readCoreTimer, 11
    .equ resetCoreTimer, 12
    .data
    .text
    .globl main
main:
    lui $t0, ADDR_HIGH

    lw $t1, TRISE($t0)
    andi $t1, $t1, 0xFFE1
    sw $t1, TRISE($t0)

    li $t2, 0   # count = 0

while:
    lw $t1, LATE($t0)
    andi $t1, $t1, 0xFFE1
    sll $t3, $t2, 1
    or $t1, $t1, $t3
    sw $t1, LATE($t0)

    li $v0, resetCoreTimer
    syscall

wait: li $v0, readCoreTimer
    syscall
    blt $v0, 5000000, wait

    addi $t2, $t2, -1
    andi $t2, $t2, 0xF

    j while

    jr $ra
