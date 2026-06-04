#include<detpic32.h>

int main(void){
    // timer 1  -> 5Hz
    T1CONbits.TCKPS = 2; //  K = 61,03515625 -> 64
    PR1 = 62499;             // PR1= 20M/64/5 -1 = 62499
    TMR1 = 0;
    T1CONbits.TON = 1;

    //interrupcoes T2
    IPC1bits.T1IP = 2;
    IEC0bits.T1IE = 1;
    IFS0bits.T1IF = 0;

    // timer 3 -> 25Hz
    T3CONbits.TCKPS = 4;     // K = 20M/65536/25 = 12,20703125 -> 16
    PR3 = 49999;             // PR3 = 20M/16/25 = 50000
    TMR3 = 0;
    T3CONbits.TON = 1;

    //interrupcoes T3
    IPC3bits.T3IP = 2;
    IEC0bits.T3IE = 1;
    IFS0bits.T3IF = 0;

    EnableInterrupts();
    while(1){
        IdleMode();
    }
    return 0;

}

void _int_(4) isr_T1(void){
    putChar('1');
    IFS0bits.T1IF = 0;
}

void _int_(12) isr_T3(void){
    putChar('3');
    IFS0bits.T3IF = 0;
}
