    .data
    .equ putChar, 3
    .equ printInt, 6
    .equ resetCoreTimer, 12
    .equ readCoreTimer, 11
    .text
    .globl main
#counter : $t0
main:
    li $t0, 0   # int counter = 0;

while:  # while(1)
    li $v0, putChar
    li $a0, '\r'
    syscall         # putChar('\r')

    li $v0, printInt
    move $a0, $t0
    li $a1, 0x4000A
    syscall             # printInt(counter, 10 | 4 << 16)

    li $v0, resetCoreTimer
    syscall                 # resetCoreTimer()

    li $t1, 200000  # 100Hz, 2 000 000 = 10Hz, 4 000 000 = 5Hz, 20 000 000 = 1Hz 
while2: li $v0, readCoreTimer
    syscall
    bge $v0, $t1, endw2        #while(readCoreTimer() < 200000)

    j while2
endw2:  addi $t0, $t0, 1    #counter++
    j while
endw:
    li $v0, 0       # return 0

    jr $ra
