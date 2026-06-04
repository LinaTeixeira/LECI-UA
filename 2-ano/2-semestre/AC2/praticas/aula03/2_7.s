    .equ ADDR_HIGH, 0xBf88
    .equ TRISE, 0x6100
    .equ LATE, 0x6120
    .equ TRISB, 0x6040
    .equ PORTB, 0x6050
    .equ readCoreTimer, 11
    .equ resetCoreTimer, 12
    .data
    .text
    .globl main
main:
    lui $t0, ADDR_HIGH

    lw $t1, TRISE($t0)
    andi $t1, $t1, 0xFFE1       # 1111 1111 1110 0001
    sw $t1, TRISE($t0)

    lw $t1, TRISB($t0)
    ori $t1, $t1, 0x0008    # 0000 0000 0000 1000
    sw $t1, TRISB($t0)

    li $t2, 0       # count = 0
while:
    lw $t1, LATE($t0)
    andi $t1, $t1, 0xFFE1
    sll $t3, $t2, 1
    or $t1, $t1, $t3
    sw $t1, LATE($t0)

    li $v0, resetCoreTimer
    syscall
wait:
    li $v0, readCoreTimer
    syscall
    blt $v0, 13333333, wait       # freq 1.5Hz

    lw $t1, PORTB($t0)
    andi $t1, $t1, 0x0004    # ler apenas bit 2
    beq $t1, $0, if0

if1:    # esquerda
    andi $t3, $t2, 0x8  # ler bit 3
    srl $t3, $t3, 3     # colocar no bit 0
    xori $t3, $t3, 1  # anular o bit 3

    sll $t2, $t2, 1
    andi $t2, $t2, 0xF
    or $t2, $t2, $t3    #merge 
    j while

if0:    #direita
    andi $t3, $t2, 0x1      # ler bit 0
    xori $t3, $t3, 0x1      # anular bit 0
    sll $t3, $t3, 3         # colocar no bit 3

    srl $t2, $t2, 1
    andi $t2, $t2, 0xF      # certificar que n passa dos 4 bits
    or $t2, $t2, $t3        # merge

    j while
    
    jr $ra
