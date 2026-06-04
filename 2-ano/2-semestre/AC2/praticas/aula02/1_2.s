    .data
    .equ putChar, 3
    .equ printInt, 6
    .equ resetCoreTimer, 12
    .equ readCoreTimer, 11
    .text
    .globl main
#counter : $t0
main:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)

    li $t0, 0       # counter = 0
while:
    li $v0, putChar
    li $a0, '\r'
    syscall         # putChar('\r')

    li $v0, printInt
    move $a0, $t0
    li $a1, 0x4000A
    syscall             # printInt(counter, 10 | 4 << 16)

    li $a0, 1
    jal delay

    addi $t0, $t0, 1    #counter++
    j while
endw:

    li $v0, 0       #return 0
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
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
    