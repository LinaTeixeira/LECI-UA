#include<detpic32.h>

void delay(unsigned int ms){
    resetCoreTimer();
    while(readCoreTimer() < 20000*ms);
}

void putc1(unsigned char byte){
    while(U1STAbits.UTXBF ==1);
    U1TXREG = byte;
}

int main(void){
    // 115200, E, 8, 1
    U1BRG = 10;
    U1MODEbits.BRGH = 0;
    U1MODEbits.PDSEL = 1;
    U1MODEbits.STSEL = 0;
    U1STAbits.UTXEN = 1;
    U1STAbits.URXEN = 1;
    U1MODEbits.ON = 1;

    while(1){
        putc1(0x5A);
        delay(10);
    }
    return 0;
}
