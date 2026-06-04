
    .equ INKEY, 1
    .equ PUT_CHAR, 3
    .equ PRINT_INT, 6
    .data
    .text
    .globl main

# c = $t0
# cnt = $t1
main:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)

    li $t1, 0   #int cnt = 0

while:              #while(1)
    li $v0, INKEY
    syscall

if: bne $v0, 'R', endif     #if( c == 'R')

    li $t1, 0   #cnt = 0

endif:
    li $v0, PUT_CHAR
    li $a0, '\r'
    syscall         #putChar('\r')

    li $v0, PRINT_INT
    move $a0, $t1
    li $a1, 0x0003000A
    syscall             # printInt(cnt, 10 | 3 << 16)

    addi $t1, $t1, 1    # cnt + 1
    andi $t1, $t1, 0xFF     #cnt = ( cnt +1 ) & 0xFF

    li $a0, 4
    jal wait

    j while
endw:

    li $v0 , 0  #return 0
    
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

###########################3
# i = $t2
# 515000 * ts = $t3
wait:
    li $t2, 0   #int i = 0
    li $t3, 515000
    mul $t3, $t3, $a0       # $t1 = 515000 * ts

for: bge $t2, $t3, endfor       #for(i < 515000 * ts)
    addi $t2, $t2, 1    #i++
    j for
endfor:

    jr $ra

