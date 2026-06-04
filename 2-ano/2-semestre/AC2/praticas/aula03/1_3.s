    .equ ADDR_BASE_HI, 0xBF88
    .equ TRISD, 0x60C0          # RD8 = entrada
    .equ TRISE, 0x6100          # RE0 = saida
    .equ PORTD, 0x60D0
    .equ LATE, 0x6120
    .data
    .text
    .globl main
main:

    lui $t0, ADDR_BASE_HI

    lw $t1, TRISD($t0)
    ori $t1, $t1, 0x0100            # 0000 0001 0000 0000
    sw $t1, TRISD($t0)              # RD8 como entrada

    lw $t1, TRISE($t0)
    andi $t1, $t1, 0xFFFE            # 1111 1111 1111 1110
    sw $t1, TRISE($t0)              # RE0 como saida

while:
    lw $t1, PORTD($t0)      # ler valor currente de PORTD
    andi $t1, $t1, 0x0100   # reset de todos os bits menos o 8

    srl $t1, $t1, 8         # alinhar bits
    xori $t1, $t1, 0x0001   # negação da entrada

    lw $t2, LATE($t0)
    andi $t2, $t2, 0xFFFE       # reset do bit 0( bit que vamos alterar)
    or $t2, $t2, $t1            # merge
    sw $t2, LATE($t0)

    j while
endw:

    jr $ra
