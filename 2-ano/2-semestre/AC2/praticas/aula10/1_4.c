#include<detpic32.h>

void delay(unsigned int ms){
    resetCoreTimer();
    while(readCoreTimer() < 20000 * ms);
}

void putc(char byte){
    while(U2STAbits.UTXBF == 1);    // wait while transmitter is full
    U2TXREG = byte;
}

int main(void){
// (115200, N, 8,1)
    U2BRG = 42; // U2BRG = (20M + (2*115200)) / (4* 115200) -1 = 42
    U2MODEbits.BRGH = 1;    // fator sobreamostragem 4
    U2MODEbits.PDSEL = 0;   // 8 bit, no parity
    U2MODEbits.STSEL = 0;   // 1 stop bits
    U2STAbits.URXEN = 1;        // enable receiver module
    U2STAbits.UTXEN = 1;        // enable transmiter
    U2MODEbits.ON = 1;      // enbale UART

    while(1){
        putc('+');
        delay(1000);
    }


    return 0;
}
