#include<detpic32.h>

int main(void){

    // T3 -> 100Hz
    T3CONbits.TCKPS = 2; // K = 20M/65536/100 = 3 -> K = 4
    PR3 = 49999;              // PR3 = 20M/100/4 -1 -> PR3 = 49999
    TMR3 = 0;
    T3CONbits.TON = 1;

    // duty-cycle = 25%
    OC1CONbits.OCM = 6;
    OC1CONbits.OCTSEL = 1;   // use T3
    OC1RS = 12500;  // OC1RS = ((PR3 +1)*25)/100 -> OC1RS = 12500
    OC1CONbits.ON = 1;

    while(1){
        IdleMode();
    }

    return 0;
}
