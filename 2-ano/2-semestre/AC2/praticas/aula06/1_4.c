#include <detpic32.h>

int main(void){
    TRISBbits.TRISB4 = 1;
    AD1PCFGbits.PCFG4 = 0;  //RB4 como input analog

    AD1CON1bits.SSRC = 7;
    AD1CON1bits.CLRASAM = 1;

    AD1CON3bits.SAMC = 16;
    AD1CON2bits.SMPI = 4-1; //interrupt after 1 sample

    AD1CHSbits.CH0SA = 4;   // input analog channel = 4

    AD1CON1bits.ON = 1; //enable ADC

    int i;
    while(1){
        AD1CON1bits.ASAM =  1; // start conversion

        int *p = (int*)(&ADC1BUF0); // ponteiro para o inicio do buffer

        while(IFS1bits.AD1IF == 0);     //wait for conversion to finish
        for ( i =0; i < 16; i++){
            printInt(p[i*4], 10 |4 << 16);
            printStr(" ");
        }
        printStr("\n");
        resetCoreTimer();
        while(readCoreTimer() < 200000);
        IFS1bits.AD1IF = 0;     // reset 
    }
    return 0;
}
