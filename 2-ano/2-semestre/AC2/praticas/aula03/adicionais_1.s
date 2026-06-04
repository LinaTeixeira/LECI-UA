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

    lw $t1, TRISB($t0)          # RB3-RB0 entradas
    ori $t1, $t1, 0x0007            # 0000 0000 0000 0111
    sw $t1, TRISB($t0)

    lw $t1, TRISE($t0)          # RE5-RE2 saidas
    andi $t1, $t1, 0xFFC3                  # 1111 1111 1100 0011
    sw $t1, TRISE($t0)

while:

    lw $t1, PORTB($t0)          # ler RB3-RB0
    ori $t1, $t1, 0x0007        # reset de todos os bits menos 3-0
    xori $t1, $t1, 0x0009       # negar bits 0 e 3       # 0000 0000 0000 1001
    sll $t1, $t1, 2             # alinhar bits ( RE2 = RB0)

    lw $t2, LATE($t0)
    andi $t2, $t2, 0xFFC3       # reset dos bit a alterar
    or $t2, $t2, $t2            # merge
    sw $t2, LATE($t0)           # write


    j while

    jr $ra
