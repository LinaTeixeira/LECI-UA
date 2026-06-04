    .data
    .equ putChar, 3
    .equ printInt, 6
    .equ resetCoreTimer, 12
    .equ readCoreTimer, 11
    .text
    .globl main

main:                           # NAO ESTA CORRETO!!!
    addiu $sp, $sp, -4
    sw $ra, 0($sp)

# cn1 : $t1
# cnt5 : $t5
# cnt10 : $t0
while:
    li $t1, 0
    li $t5, 0
    li $t0, 0

    li $v0, putChar
    li $a0, '\r'
    syscall         # putChar('\r')

    li $v0, printInt
    move $a0, $t1
    li $a1, 0x5000A
    syscall             # printInt(cnt1, 10 | 5 << 16)

    li $a0, 1000    # 1000ms = 1Hz
    jal delay

    addi $t1, $t1, 1    #cnt1++

    li $v0, putChar
    li $a0, '\r'
    syscall         # putChar('\r')

    li $v0, printInt
    move $a0, $t5
    li $a1, 0x5000A
    syscall             # printInt(cnt1, 10 | 5 << 16)

    li $a0, 200    # 200ms = 5Hz
    jal delay

    addi $t5, $t5, 1    #cnt5++

    li $v0, putChar
    li $a0, '\r'
    syscall         # putChar('\r')

    li $v0, printInt
    move $a0, $t0
    li $a1, 0x5000A
    syscall             # printInt(cnt0, 10 | 5 << 16)

    li $a0, 100    # 100ms = 1Hz
    jal delay

    addi $t0, $t0, 1    #cnt10++

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
