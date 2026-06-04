    .equ ADDR_BASE_HI, 0xBF88
    .equ TRISE, 0x6100
    .equ TRISB, 0x6040
    .equ PORTB, 0x6050
    .equ LATE, 6120
    .equ resetCoreTimer, 12
    .equ readCoreTimer, 11
    .data
    .text
    .globl main

main:
    lui $t0, ADDR_BASE_HI

    lw $t1, TRISE($t0)
    andi $t1, $t1, 0xFFE1             # 1111 1111 1110 0001
    sw $t1, TRISE($t0)                  # RE4-RE1 como saídas

    lw $t1, TRISB($t0)
    ori $t1, $t1, 0x000E              # 0000 0000 0000 1110
    sw $t1, TRISB($t0)                  # RB3-RB1 como entradas

    li $t2, 0       # cnt = 0

while:
    lw $t1 LATE($t0)
    andi $t1, $t1, 0xFFF1             # reset dos bits que vamos alterar
    sll $t3, $t2, 1                 # counter na posiçao 1
    or $t1, $t1, $t3                # merge
    sw $t1, LATE($t0)

    li $v0, resetCoreTimer
    syscall
wait:
    li $v0, readCoreTimer
    syscall
    blt $v0, 4347826, wait      # f = 4.6Hz

    addi $t2, $t2, 1    #cnt++
    andi $t2, $t2, 0x000F

    j while


    jr $ra
