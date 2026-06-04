    .equ printInt, 6
    .equ readInt10, 5
    .equ putChar, 3
    .equ inKey, 1
    .equ UP, 1
    .equ DOWN, 0
    .data
    .text
    .globl main
# c : $s1
# state : $t1
# cnt : $s0
main:
    addiu $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    li $s0, 0   # cnt = 0
    li $t1, UP

do: 
    li $v0, putChar
    li $a0, '\r'
    syscall         #putChar('\r')

    li $v0, printInt
    move $a0, $s0
    li $a1, 0x3000A
    syscall             #printInt( cnt, 10 | 3 << 16)

    li $v0, putChar
    li $a0, '\t'
    syscall             #putChar('\t')

    li $v0, printInt
    move $a0, $s0
    li $a1, 0x80002
    syscall             #printInt( cnt, 2 | 8 << 16)

    li $a0, 5
    jal wait            # wait(5)

    li $v0, inKey
    syscall
    move $s1, $v0   # c = inkey()

if0: bne $s1, '+', elseif0  # if ( c == '+')
    li $t1, UP  # state = UP

    j endif0
elseif0: bne $s1, '-', endif0   # if ( c == '-')
    li $t1, DOWN    #state = DOWN

endif0:
if1: bne $t1, UP, else1    # if (state == UP)
    addi $s0, $s0, 1
    andi $s0, $s0, 0xFF     # cnt = (cnt + 1) & 0xFF

    j endif1
else1:
    addi $s0, $s0, -1
    andi $s0, $s0, 0xFF     # cnt = (cnt - 1) & 0xFF

endif1:

while: bne $s1, 'q', do     #while ( c != 'q')

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addiu $sp, $sp, 12

    li $v0, 0   #return 0
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
