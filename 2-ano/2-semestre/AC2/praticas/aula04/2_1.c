#include<detpic32.h>

int main(void){
    // RB8 - RB14 e RD5,RD6 como saídas
    TRISB = TRISB  & 0x80FF;         // 1000 0000 1111 1111
    TRISD = TRISD & 0xFF9F;              // 1111 1111 1001 1111

    // selecionar display menos significativo
    LATDbits.LATD5 = 1;
    LATDbits.LATD6 = 0; 

    while(1){
        char ch = getChar();

        if (ch == 'a') LATB = (LATB & 0x80FF) | (1 << 8);
        if (ch == 'b') LATB = (LATB & 0x80FF) | (1 << 9);
        if (ch == 'c') LATB = (LATB & 0x80FF) | (1 << 10);
        if (ch == 'd') LATB = (LATB & 0x80FF) | (1 << 11);
        if (ch == 'e') LATB = (LATB & 0x80FF) | (1 << 12);
        if (ch == 'f') LATB = (LATB & 0x80FF) | (1 << 13);
        if (ch == 'g') LATB = (LATB & 0x80FF) | (1 << 14);

    }
    return 0;
}
