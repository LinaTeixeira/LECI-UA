#include<detpic32.h>

int main(void){
    // configuracao timer T3 com freq de 2Hz
    T3CONbits.TCKPS= 7;     // K = 20M / (65536 * 2) = 152 --> escolhemos 256
    PR3 = 39061;                  // PR3 = (20M/256/2)-1 = 39061,5
    TMR3 = 0;
    T3CONbits.TON = 1;

    // configuracao interrupcoes
    IPC3bits.T3IP = 2;  // interrupts priority
    IEC0bits.T3IE = 1;  // enable T3 interrupts
    IFS0bits.T3IF = 0;  // reset T3 interrup flag

    EnableInterrupts();
    while(1){
        IdleMode();
    }
    return 0;
}

void _int_(12) isr_T3(void){
    putChar('.');
    IFS0bits.T3IF = 0;
}
