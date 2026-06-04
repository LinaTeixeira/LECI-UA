#include<detpic32.h>
void putc(unsigned char byte){
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
    // 115200, N, 8,1
    U2BRG = 10;
    U2MODEbits.BRGH = 0;
    U2MODEbits.PDSEL = 0;
    U2MODEbits.STSEL = 0;
    U2STAbits.UTXEN = 1;
    U2STAbits.URXEN = 1;
    U2MODEbits.ON = 1;

    TRISDbits.TRISD11 = 0;
    while(1){
        while(U2STAbits.TRMT == 0);
        LATDbits.LATD11 = 1;
        putStr("12345");
        LATDbits.LATD11 = 0;
    }
    return 0;
}
