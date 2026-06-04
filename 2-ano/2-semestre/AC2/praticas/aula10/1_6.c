#include<detpic32.h>

void delay(unsigned int ms){
    resetCoreTimer();
    while (readCoreTimer() < 20000 * ms);
}

void putc(char byte){
    while(U2STAbits.UTXBF);
    U2TXREG = byte;
}

void putStr(char *s){
    while(*s != '\0'){
        putc(*s);
        s++;
    }
}

int main(void){
/*
    // 600, N, 8, 1
    U2BRG = 2082;   // (20M + 8*600)/16*600 -1
    U2MODEbits.BRGH = 0;
    U2MODEbits.PDSEL = 0;
    U2MODEbits.STSEL = 0;
*/
/*   // 1200, O, 8, 2
    U2BRG = 1041;        // ((20000000 + 8*1200) / 16*1200)-1
    U2MODEbits.BRGH = 0;
    U2MODEbits.PDSEL = 2;
    U2MODEbits.STSEL = 1;
*/
/*
    // 9600, E, 8, 1
    U2BRG = 129;        // ((20000000 + 8*9600) / 16*9600)-1
    U2MODEbits.BRGH = 0;
    U2MODEbits.PDSEL = 1;
    U2MODEbits.STSEL = 0;
*/
/*
    // 19200, N, 8, 2
    U2BRG = 64;        // ((20000000 + (8*19200)) / (16*19200))-1
    U2MODEbits.BRGH = 0;
    U2MODEbits.PDSEL = 0;
    U2MODEbits.STSEL = 1;
*/
/*
    // 115200, E, 8, 1
    U2BRG = 10;        // ((20000000 + (8*115200)) / (16*115200))-1
    U2MODEbits.BRGH = 0;
    U2MODEbits.PDSEL = 1;
    U2MODEbits.STSEL = 0;
*/
/*
    // 230400, E, 8, 2
    U2BRG = 21;        // ((20000000 + (2*230400)) / (4*230400))-1
    U2MODEbits.BRGH = 1;    // para baudrates maiores que 115200 usamos fator sobreamostragem 4
    U2MODEbits.PDSEL = 1;
    U2MODEbits.STSEL = 1;
*/
/*
    // 460800, O, 8, 1
    U2BRG = 10;        // ((20000000 + (2*460800)) / (4*460800))-1
    U2MODEbits.BRGH = 1;    // para baudrates maiores que 115200 usamos fator sobreamostragem 4
    U2MODEbits.PDSEL = 2;
    U2MODEbits.STSEL = 0;
*/
    // 576000, N, 8, 1
    U2BRG = 8;        // ((20000000 + (2*576000)) / (4*576000))-1
    U2MODEbits.BRGH = 1;    // para baudrates maiores que 115200 usamos fator sobreamostragem 4
    U2MODEbits.PDSEL = 0;
    U2MODEbits.STSEL = 0;
    U2STAbits.UTXEN = 1;
    U2STAbits.URXEN = 1;
    U2MODEbits.ON = 1;

    while(1){
        putStr("String de teste\n");
        delay(1000);
    }
    return 0;
}
