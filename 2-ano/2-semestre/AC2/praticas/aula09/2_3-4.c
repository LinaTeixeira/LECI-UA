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
    setPWM(65);  // dutyCycle de 65%
    OC1CONbits.ON = 1;

    while(1){
        IdleMode();
    }

    return 0;
}
