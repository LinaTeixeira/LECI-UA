#include <detpic32.h>

void delay(unsigned int ms){
    resetCoreTimer();
    while(readCoreTimer() < ms * 20000);
}

void putc(char byte){
    while(U2STAbits.UTXBF);
    U2TXREG = byte;
}

void putStr(char *str){
    while(*str != '\0'){
        putc(*str);
        str++;
    }
}

int main(void){

    // UART2 (115200, N, 8, 1)
    U2BRG = 10;  // baudrate 115200
    U2MODEbits.BRGH = 0;    // 16
    U2MODEbits.PDSEL = 0;   // 8 bit, no parity
    U2MODEbits.STSEL = 0;   // 1 stop bit
    U2STAbits.UTXEN = 1;
    U2STAbits.URXEN = 1;
    U2MODEbits.ON = 1;

    while(1){
        putStr("String de teste\n");
        delay(1000);
    }
    return 0;
}
