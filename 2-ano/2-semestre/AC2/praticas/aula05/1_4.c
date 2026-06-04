#include <detpic32.h>

void delay(unsigned int ms){
    resetCoreTimer();
    while(readCoreTimer() < ms * 20000);
}

void send2displays(unsigned char value){
    static const char disp7Scodes[] = {0x3F, 0x06, 0x5B,
                                0x4F, 0x66, 0x6D, 
                                0x7D, 0x07, 0x7F,
                                0x6F, 0x77, 0x7C,
                                0x39, 0x5E, 0x79, 0x71 };

    static char displayFlag = 0;        // static guarda o valor entre chamadas
    int digitLow = value & 0x0F;
    int digitHigh = value >> 4;

    if(displayFlag==0){
        LATDbits.LATD5 = 1;
        LATDbits.LATD6 = 0;
        LATB = (LATB & 0x80FF) | (disp7Scodes[digitLow] << 8);
    } else {
        LATDbits.LATD5 = 0;
        LATDbits.LATD6 = 1;
        LATB = (LATB & 0x80FF) | (disp7Scodes[digitHigh] << 8);
    }
    displayFlag = !displayFlag;
}

int main(void){
    TRISB = TRISB & 0x80FF;     // RB-RB14 as outputs
    TRISD = TRISD & 0xFF9F;     //RD5-RD6 as outputs  1111 1111 101 1111

    while(1){
        send2displays(0x15);
        delay(10); // 50 ->20Hz, 20-> 50Hz, 10 -> 100Hz
    }
    return 0;
}
