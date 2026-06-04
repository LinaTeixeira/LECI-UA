#include <detpic32.h>

void putc(unsigned char byte){
    while(U2STAbits.UTXBF==1);
    U2TXREG = byte;
}

void putStr(char *s){
    while(*s != '\0'){
        putc(*s);
        s++;
    }
}

int main(void){

    // 115200, N, 8, 1
    U2BRG = 10;
    U2MODEbits.BRGH = 0;
    U2MODEbits.PDSEL = 0;
    U2MODEbits.STSEL = 0;
    U2STAbits.UTXEN = 1;
    U2STAbits.URXEN = 1;
    U2MODEbits.ON = 1;

    IEC1bits.U2RXIE = 1;    // enable TX ints
    IEC1bits.U2TXIE = 0;    // disable TX ints
    IPC8bits.U2IP = 2;      // priority
    IFS1bits.U2RXIF = 0;    // clear int flag
    U2STAbits.URXISEL = 0;  // RX interrupt mode

    TRISCbits.TRISC14 = 0;
    EnableInterrupts();
    while(1){
        IdleMode();
    }

    return 0;
}

void _int_(32) isr_uart2(void){
    char c;
    if (IFS1bits.U2RXIF){
        c = U2RXREG;
        if (c == '?'){
            putStr("AC2-Guiao 11");
        }else if(c == 't'){
            LATCbits.LATC14 = 0;
        } else if(c == 'T'){
            LATCbits.LATC14 = 1;
        } else{
            putc(c);
        }
        IFS1bits.U2RXIF = 0;
    }
}
