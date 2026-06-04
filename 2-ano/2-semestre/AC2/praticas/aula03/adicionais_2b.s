    .equ ADDR_BASE_HI, 0xBF88
    .equ TRISE, 0x6100
    .equ LATE, 0x6120
    .equ TRISD, 0x60C0
    .equ LATD, 0x60E0
    .equ resetCoreTimer, 12
    .equ readCoreTimer, 11
    .data
    .text
    .globl main
# v: $s1
main:
    addiu $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    lui $s0, ADDR_BASE_HI

    lw $t1, TRISE($s0)
    andi $t1, $t1, 0xFFFE
    sw $t1, TRISE($s0)      # TRISE = 0 - RE0 como saída

    lw $t1, TRISD($s0)
    andi $t1, $t1, 0xFFFE
    sw $t1, TRISD($s0)      # RD0 como saída

    li $s1, 0       # v = 0

while:
    lw $t1, LATE($s0)
    andi $t1, $t1, 0xFFFE       # reset bits
    or $t1, $t1, $s1            # merge
    sw $t1, LATE($s0)

    lw $1, LATD($s0)
    andi $t1, $t1, 0xFFFE
    or $t1, $t1, $s1
    sw $t1, $t1, $s1           # mesma coisa para o RD0

    li $a0, 500
    jal delay
    xori $s1, $s1, 0x0001

    j while    

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addiu $sp, $sp, 12

    jr $ra


# ms = $a0
delay:
    li $v0, resetCoreTimer
    syscall

    mul $a0, $a0, 20000
while0:
    li $v0, readCoreTimer
    syscall

    bge $v0, $a0, endw0     # while (readCoreTimer() < K * ms)

    j while0
endw0:
    jr $ra
    