#include<detpic32.h>

void delay(unsigned ms){
    resetCoreTimer();
    while(readCoreTimer() < 20000 * ms);
}

int main(void){

    TRISEbits.TRISE0 = 0;   // LED0
    TRISDbits.TRISD8 = 1;   // INT1

    LATEbits.LATE0 = 0;

    while(1){
        if (PORTDbits.RD8 == 0){
            LATEbits.LATE0 = 1;
            delay(3000);
            LATEbits.LATE0 = 0;
        }
    }


    return 0;
}
