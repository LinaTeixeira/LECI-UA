#include<detpic32.h>

int main(void){
    // configuracao timer T3 com freq de 2Hz
    T3CONbits.TCKPS= 7;     // K = 20M / (65536 * 2) = 152 --> escolhemos 256
    PR3 = 39061;                  // PR3 = (20M/256/2)-1 = 39061,5
    TMR3 = 0;
    T3CONbits.TON = 1;

    while(1){
        while(IFS0bits.T3IF == 0);
        IFS0bits.T3IF = 0;
        putChar('.');
    }
    return 0;

}
