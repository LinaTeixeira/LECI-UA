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
    andi $t1, $t1, 0xFFE1
    sw $t1, TRISE($t0)

    lw $t1, TRISB($t0)
    ori $t1, $t1, 0x0002    # 0000 0000 0000 1000
    sw $t1, TRISB($t0)

    li $t2, 1   #count=0
loop:
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
    blt $v0, 6666666, wait

    lw $t1, PORTB($t0)
    andi $t1, $t1, 0x0002

    beq $t1, $0, if0
if1:
    sll $t2, $t2, 1
    bne $t2, 16, loop
    li $t2, 1
    j loop
if0:
    srl $t2, $t2, 1
    bne $t2,$0, loop
    li $t2, 8
    j loop

    jr $ra
