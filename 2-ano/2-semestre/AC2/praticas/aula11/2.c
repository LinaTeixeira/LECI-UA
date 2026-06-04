#include<detpic32.h>
typedef struct{
    char mem[100];  // storage
    int nchar;
    int posrd;
} t_buf;

volatile t_buf txbuf;

void putStrInt(char *s){
    while(txbuf.nchar > 0);
    int i = 0;
    while(*s != '\0'){
        txbuf.mem[i] = *s;
        txbuf.nchar++;
        i++;
        s++;
    }
    txbuf.posrd = 0;
    IEC1bits.U2TXIE = 1;    // enable TX ints
}

int main(void){

    U2BRG=10;
    U2MODEbits.BRGH = 0;
    U2MODEbits.PDSEL = 0;
    U2MODEbits.STSEL = 0;
    U2STAbits.UTXEN = 1;
    U2STAbits.URXEN = 1;
    U2MODEbits.ON = 1;

    IEC1bits.U2RXIE = 0;    // disable RX ints
    IEC1bits.U2TXIE = 0;    // disable TX ints
    IPC8bits.U2IP = 2;      // priority
    IFS1bits.U2RXIF = 0;    // clear int flag
    U2STAbits.URXISEL = 0;  // RX interrupt mode

    EnableInterrupts();
    txbuf.nchar = 0;
    while(1){
        putStrInt("Test string wich can be as long as you like, up to a maximum of 100 characters\n");
    }
    return 0;
}

void _int_(32) isr_uart2(void){
    if(IFS1bits.U2TXIF == 1){
        if(txbuf.nchar > 0){
            U2TXREG = txbuf.mem[txbuf.posrd];
            txbuf.posrd++;
            txbuf.nchar--;
        } else{
            IEC1bits.U2TXIE = 0;    // disable TX ints
        }
        IFS1bits.U2TXIF = 0;
    }
}
