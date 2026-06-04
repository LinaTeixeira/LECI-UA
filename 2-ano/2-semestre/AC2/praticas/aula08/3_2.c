#include <detpic32.h>
volatile int t2_cnt = 0;

int main(void){
    // T2 3Hz
    T2CONbits.TCKPS= 7;  // K = 20M/65536/3 = 101 -> 256
    PR2 = 26040;               // PR2 = 20M/256/3 -1 = 26040
    TMR2 = 0;
    T2CONbits.TON = 1;

    // T2 interrupts
    IPC2bits.T2IP = 2;
    IEC0bits.T2IE = 1;
    IFS0bits.T2IF = 0;

    // INT1 interrupts

    INTCONbits.INT1EP = 0;  // falling edge
    IFS0bits.INT1IF = 0;
    IEC0bits.INT1IE = 1;
    IPC1bits.INT1IP = 3;

    TRISEbits.TRISE0 = 0;   // LED0
    TRISDbits.TRISD8 = 1;   // INT1

    LATEbits.LATE0 = 0;

    EnableInterrupts();
    while(1){
        IdleMode();
    }

    return 0;
}

void _int_(8) isr_T2(void){
    t2_cnt = (t2_cnt +1) % 9;
    if(t2_cnt == 0){
        LATEbits.LATE0 = 0;
    }
    IFS0bits.T2IF = 0;
}

void _int_(7) isr_INT1(void){   // executada ao clicar no botao
    LATEbits.LATE0 = 1;
    IFS0bits.T2IF = 1;
    IFS0bits.INT1IF = 0;
    t2_cnt = 0;
}
