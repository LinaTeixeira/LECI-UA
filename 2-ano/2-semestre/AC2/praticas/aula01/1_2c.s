    .equ printStr, 8
    .equ printInt10, 7
    .equ printInt, 6
    .equ readInt10, 5
    .data
str: .asciiz "\nIntroduza um inteiro (sinal e módulo): "
str1:   .asciiz "\nValor em base 10 (signed): "
str2:   .asciiz "\nValor em base 2: "
str3:   .asciiz "\nValor em base 2, formatado: "
str4:   .asciiz "\nValor em base 16: "
str5:   .asciiz "\nValor em base 10 (unsigned): "
str6:   .asciiz "\nValor em base 10 (unsigned), formatado: "
    .text
    .globl main

#value = $t0
main:

while:      #while(1)
    li $v0, printStr
    la $a0, str
    syscall     #printStr("Introduza ...")

    li $v0, readInt10
    syscall
    move $t0, $v0   #value = readInt10()

    li $v0, printStr
    la $a0, str1
    syscall     #printStr("Valor em base 10(signed): ")
    
    li $v0, printInt10
    move $a0, $t0
    syscall     #printInt10(value)

    li $v0, printStr
    la $a0, str2
    syscall     #printStr("Valor em base 2: ")

    li $v0, printInt
    move $a0, $t0
    li $a1, 2
    syscall         #printInt(value, 2)

    li $v0, printStr
    la $a0, str3
    syscall     #printStr("Valor em base 2, formatado: ")
    
    li $v0, printInt
    move $a0, $t0
    li $a1, 0x200002
    syscall     #printInt(value, 2 | 32 << 16)

    li $v0, printStr
    la $a0, str4
    syscall     #printStr("Valor em base 16: ")
    
    li $v0, printInt
    move $a0, $t0
    li $a1, 16
    syscall     #printInt(value, 16)

    li $v0, printStr
    la $a0, str5
    syscall     #printStr("Valor em base 10(unsigned): ")
    
    li $v0, printInt
    move $a0, $t0
    li $a1, 10
    syscall     #printInt(value, 10)

    li $v0, printStr
    la $a0, str6
    syscall     #printStr("Valor em base 10(usigned), formatado: ")
    
    li $v0, printInt
    move $a0, $t0
    li $a1, 0x5000A
    syscall     #printInt10(value, 10 | 5 << 16)

endw:

    li $v0, 0       #return 0
    jr $ra
