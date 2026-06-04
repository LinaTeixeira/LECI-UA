#include <detpic32.h>

int main(void){
    // RB4 as analog input
    TRISBbits.TRISB4 = 1;
    AD1PCFGbits.PCFG4 = 0;  

    AD1CON1bits.SSRC = 7;
    AD1CON1bits.CLRASAM = 1;

    AD1CON3bits.SAMC = 16;
    AD1CON2bits.SMPI =1-1; //interupt after 1 sample

    AD1CHSbits.CH0SA = 4;   // input analog channel
    AD1CON1bits.ON = 1;     // enable ADC

    TRISDbits.TRISD11 = 0;  //TRISD11 saída

    volatile int aux;
    while(1){
        AD1CON1bits.ASAM = 1;   // start conversion
        resetCoreTimer();

        LATDbits.LATD11 = 1;
        while(IFS1bits.AD1IF == 0);     // wait while conversion no done

        aux = ADC1BUF0;     // read conversion result to aux
        printInt(readCoreTimer(), 10 | 3 << 16);
        printStr("\n");
        IFS1bits.AD1IF = 0;



    }
    return 0;
}

