#include <detpic32.h>

unsigned char toBcd(unsigned char value) {
    return ((value / 10) << 4) | (value % 10);
}

void send2disp(unsigned char val){
    static const char disp7Scodes[] = {0x3F, 0x06, 0x5B,
                                0x4F, 0x66, 0x6D, 
                                0x7D, 0x07, 0x7F,
                                0x6F, 0x77, 0x7C,
                                0x39, 0x5E, 0x79, 0x71 };

    static char dispFlag = 0;
    int valHigh = val >> 4;
    int valLow = val & 0x0F;
    if(dispFlag == 0){
        // display low
        LATD = (LATD & 0xFFBF) | 0x0020;   // 1111 1111 1101 1111
        LATB = (LATB & 0x80FF) | (disp7Scodes[valLow] << 8);
    } else{
        //dispHigh
        LATD = (LATD & 0xFFDF) | 0x0040;   // 1111 1111 1011 1111
        LATB = (LATB & 0x80FF) | (disp7Scodes[valHigh] << 8);
    }
    dispFlag = !dispFlag;
}


int counter = 0;
int main (void){
    TRISB = TRISB & 0x80FF;
    TRISD = TRISD & 0xFF9F;        // FF 1001 F

    // configuracoes T1 1Hz -> 2Hz
    T1CONbits.TCKPS = 3;     // K = 20000000/65536/2 = 152 -> 256
    PR1 = 39061;                 // PR1 = 20M/256/2 - 1 = 39061????
    TMR1 = 0;
    T1CONbits.TON = 1;

    IPC1bits.T1IP = 3;
    IEC0bits.T1IE = 1;
    IFS0bits.T1IF = 0;


    //configuracoes T2 -> 100Hz
    T2CONbits.TCKPS = 3; // 3 ->8
    PR2 = 24999;             // PR2 = 
    TMR2 = 0;
    T2CONbits.TON = 1;

    IPC2bits.T2IP = 2;
    IEC0bits.T2IE = 1;
    IFS0bits.T2IF = 0;

    EnableInterrupts();
    while(1){
        IdleMode();
    }

    return 0;
}

void _int_(4) isr_T1(void){
    static char T1flag = 0;
    if (T1flag == 1){
        counter = (counter + 1) % 30;
    }
    T1flag = !T1flag;
    IFS0bits.T1IF = 0;
}

void _int_(8) isr_T2(void){
    send2disp(toBcd(counter));
    IFS0bits.T2IF = 0;
}
