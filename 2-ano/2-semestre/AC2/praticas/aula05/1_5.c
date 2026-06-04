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
    TRISD = TRISD & 0xFF9F;     // RD5-RD6 saídas
    TRISB = TRISB & 0x80FF;     // RB8-RB14 saídas

    unsigned int i = 0;
    int count = 0;
    while(1){
        send2displays(count);
        delay(20); // 50 Hz = 20ms
        i = (i+1) % 10; // 5Hz = 200ms ->10*20ms = 200ms
        if(i == 0){
            count = (count +1) % 256;
        }

    }

    return 0;
}
