    .data
    .equ resetCoreTimer, 12
    .equ readCoreTimer, 11
    .text
    .globl main

#counter : $s0
main:
    addiu $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)


    li $s0, 0       # counter = 0
while:
    li $v0, putChar
    li $a0, '\r'
    syscall         # putChar('\r')

    li $v0, printInt
    move $a0, $t0
    li $a1, 0x4000A
    syscall             # printInt(counter, 10 | 4 << 16)

    li $a0, 100
    jal timeDone

    addi $t0, $t0, 1    #counter++
    j while
endw:

    li $v0, 0       #return 0
    lw $s0, 0($sp)
    lw $ra, 0($sp)
    addiu $sp, $sp, 8
    jr $ra

# ms : $a0
# reset : $a1
# curCount : $t0
# retValue : $t1
timeDone:
    li $t1, 0       # retValue = 0

if: ble $a1, 0, else        # if(reset > 0)

    li $v0, resetCoreTimer
    syscall                    # resetCoreTimer()

    j endif
else:   
    li $v0, readCoreTimer
    syscall
    move $t0, $v0   # curCount = readCoreTimer()

    mul $t2, $a0, 20000 # $t2 = K *ms
if2: bge $t0, $t2, endif        #if (curCount > (K * ms)

    div $t1, $t0, 20000     # retValue = curCount/K

endif:

    move $v0, $t1   #return retValue
    jr $ra
