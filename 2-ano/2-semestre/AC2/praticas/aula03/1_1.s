    .equ AddrBaseHI, 0xBF88
    .equ TRISE, 6100
    .equ TRISB, 6040
    .equ PORTB, 6050   # RE0 saida
    .equ LATE, 6120   # RB0 entrada
    .data
    .text
    .globl main

main:
    lui $t0, AddrBaseHI

    lw $t1, TRISE($t0)
    andi $t1, $t1, 0xFFFE        # 1111 1111 1111 1110
    sw $t1, TRISE($t0)      # RE0 como saída

    lw $t1, TRISB($t0)
    ori $t1, $t1, 0x0001        # 0000 0000 0000 0001
    sw $t1, TRISB($t0)      # RB0 como entrada

while:
    lw $t1, PORTB($t0)
    andi $t1, $t1, 0x0001   # reset de todos os bits menos o 0

    lw $t2, LATE($t0)
    andi $t2, $t2, 0xFFF6   # reset do bit 0 ( pq o vamos alterar)

    or $t2, $t2, $t1        # merge dos conteudos
    sw $t2, LATE($t0)       # escrita no LATB

    j while
endw:

    jr $ra
    