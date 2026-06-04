#include<detpic32.h>

void setPWM(unsigned int dutyCycle){

    if ( dutyCycle <= 100){ // como dutyCycle é unsigned n vale a pena fazer dutyCycle >= 0
        OC1RS = ((PR3 +1)*dutyCycle)/100;
    }
}

int main(void){

    // T3 -> 100Hz
    T3CONbits.TCKPS = 2; // K = 20M/65536/100 = 3 -> K = 4
    PR3 = 49999;              // PR3 = 20M/100/4 -1 -> PR3 = 49999
    TMR3 = 0;
    T3CONbits.TON = 1;

    OC1CONbits.OCM = 6;
    OC1CONbits.OCTSEL = 1;   // use T3
    setPWM(10);  //  maior dutyCycle = LED com luz mais forte
    OC1CONbits.ON = 1;

    TRISCbits.TRISC14 = 0;  // RC14 saida (LED D11)

    while(1){
        LATCbits.LATC14 = PORTDbits.RD0;
    }

    return 0;
}
