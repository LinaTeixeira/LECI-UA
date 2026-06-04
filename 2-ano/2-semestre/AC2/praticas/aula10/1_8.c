#include <detpic32.h>

void delay(unsigned int ms){
    resetCoreTimer();
    while(readCoreTimer() < ms * 20000);
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

    // UART2 (115200, N, 8, 1)
    U2BRG = 10;  // baudrate 115200
    U2MODEbits.BRGH = 0;    // 16
    U2MODEbits.PDSEL = 0;   // 8 bit, no parity
    U2MODEbits.STSEL = 0;   // 1 stop bit
    U2STAbits.UTXEN = 1;
    U2STAbits.URXEN = 1;
    U2MODEbits.ON = 1;

    int counter = 0;
    while(1){
        int i;
        for (i=3; i >= 0; i--)
        if ((counter & (1 << i)) != 0) {
            putc('1');
        } else {
            putc('0');
        }
        putc('\n');
        delay(200);
        counter = (counter +1 ) %10;      

    }
    return 0;
}
