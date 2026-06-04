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
    andi $t1, $t1, 0xFFFE
    sw $t1, TRISE($t0)      # configuracao de RE0 como saida

    lw $t1, TRISB($t0)
    ori $t1, $t1, 0x0001
    sw $t1, TRISB($t0)      # configuracao de RB0 como entrada

while:
    lw $t1, TRISB($t0)
    andi $t1, $t1, 0x0001   # reset de todos menos o bit 0( que queremos ler)

    xor $t1, $t1, 0x0001    #negar o valor de entrada(bit 0)

    lw $t2, LATE($t0)       # ler valor currente de LATE -- read
    andi $t2, $t2, 0xFFFE   # reset do bit 0
    or $t2, $t2, $t1        # merge                      -- modify
    sw $t2, LATE($t0)       #                           -- write

    j while
endw:
    jr $ra
