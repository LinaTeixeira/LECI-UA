#include <detpic32.h>

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

void delay(unsigned int ms){
    resetCoreTimer();
    while(readCoreTimer() < ms * 20000);
}

unsigned char toBcd(unsigned char value){
    return ((value / 10) << 4) + (value % 10);
}
volatile int voltage = 0;
int main(void){
    TRISBbits.TRISB4 = 1;
    AD1PCFGbits.PCFG4 = 0;  //RB4 como input analog

    AD1CON1bits.SSRC = 7;
    AD1CON1bits.CLRASAM = 1;

    AD1CON3bits.SAMC = 16;
    AD1CON2bits.SMPI = 4-1; //interrupt after 4 sample

    AD1CHSbits.CH0SA = 4;   // input analog channel = 4

    AD1CON1bits.ON = 1; //enable ADC

    // ADC interrupts
    IPC6bits.AD1IP = 2; // prioriy
    IEC1bits.AD1IE = 1; // enable interurpts
    IFS1bits.AD1IF = 0; // reset ADC interrupt flag

    // T1 -> 5Hz
    T1CONbits.TCKPS = 2; //K = 20M/65536/5 = 61 -> K = 64
    PR1= 62499;               // PR1 = (20M/64/5) -1 -> PR1 = 62499
    TMR1 = 0;
    T1CONbits.TON = 1;
    // T1 interrupts
    IPC1bits.T1IP = 2;  // interrupt priority
    IEC0bits.T1IE = 1;  // enable T1 interrupts
    IFS0bits.T1IF = 0;  // reset T1 flag

    // T3 -> 100Hz
    T3CONbits.TCKPS = 2; // K = 20M/65536/100 = 3 -> K = 4
    PR3= 49999;               // PR3 = (20M/4/100) -1 -> PR3 = 49999
    TMR3= 0;
    T3CONbits.TON = 1;
    // T3 interrupts
    IPC3bits.T3IP = 2;  // interrupt priority
    IEC0bits.T3IE = 1;  // enable T3 interrupts
    IFS0bits.T3IF = 0;  // reset T3 flag

    TRISB = (TRISB & 0x80FF);
    TRISD = (TRISD & 0xFF9F);

    TRISBbits.TRISB0 = 1;
    TRISBbits.TRISB1 = 1;

    EnableInterrupts();
    while(1){
        if ((PORTBbits.RB1 == 1) && (PORTBbits.RB0 == 0)){
            IEC0bits.T1IE = 1;
        }else IEC0bits.T1IE = 0;

    }
    return 0;
}

void _int_(4) isr_T1(void){
    AD1CON1bits.ASAM = 1; // start conversion
    IFS0bits.T1IF = 0;  // reset T1 flag
}

void _int_(12) isr_T3(void){
    send2disp(toBcd((unsigned char) voltage));
    IFS0bits.T3IF = 0;  // reset T3 flag
}

void _int_(27) isr_AD1(void){
    int *p = (int*)(&ADC1BUF0); // ponteiro para o inicio do buffer
    int i, soma = 0;
    for (i=0; i < 4; i++){
        soma = soma + p[i*4];
    }
    int media = soma/4;
    voltage = (media * 33 + 511) / 1023;

    IFS1bits.AD1IF = 0;
}
