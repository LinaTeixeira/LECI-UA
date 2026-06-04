#include <detpic32.h>

void delay(unsigned int ms){
    resetCoreTimer();
    while(readCoreTimer() < ms * 20000);
}

unsigned char toBCD(unsigned char value){
    return ((value / 10) << 4) + (value % 10);
}

void send2displays(unsigned char value){
    static const char disp7Scodes[] = {0x3F, 0x06, 0x5B,
                                0x4F, 0x66, 0x6D, 
                                0x7D, 0x07, 0x7F,
                                0x6F, 0x77, 0x7C,
                                0x39, 0x5E, 0x79, 0x71 };

    static char displayFlag = 0;
    int digitLow = value % 10; // unidades
    int digitHigh = value / 10;  // dezenas

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
    TRISB = TRISB & 0x80FF; // RB8-RB14 como saídas (7segmentos)
    TRISD = TRISD & 0xFF9F; //RD5-RD6 como saídas (display)
    TRISE = TRISE & 0xFF00; //RE0-RE7 como saídas (LEDs)
    unsigned int i=0;
    int count = 0;
    while(1){

        LATE = (LATE & 0xFF00) | toBCD((unsigned char)count);
        send2displays(count);
        delay(10); // 100Hz = 10ms
        i = (i+1) % 50; // 2Hz = 500ms -> 10*50
        if (i == 0){
            count = (count+1) % 60; //modulo 60
        }
    }
    return 0;
}

