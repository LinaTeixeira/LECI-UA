#include <detpic32.h>
void send2displays(unsigned char value){
    static const char disp7Scodes[] = {0x3F, 0x06, 0x5B,
                                0x4F, 0x66, 0x6D, 
                                0x7D, 0x07, 0x7F,
                                0x6F, 0x77, 0x7C,
                                0x39, 0x5E, 0x79,
                                0x71 };

    int dh, dl;
    // select display high
    //TRISD = TRISD & 0xFF9F;
    LATDbits.LATD5 = 0;
    LATDbits.LATD6 = 1;

    dh = value >> 4;    // isolar 4 bits 
    LATB = (LATB & 0x80FF) | (disp7Scodes[dh] << 8);

    // select display low
    LATDbits.LATD5 = 1;
    LATDbits.LATD6 = 0;

    dl = value & 0x0f;
    LATB = (LATB & 0x80FF) | (disp7Scodes[dl] << 8);
}

int main(void){
    TRISB = TRISB & 0x80FF;     // RB-RB14 as outputs
    TRISD = TRISD & 0xFF9F;     //RD5-RD6 as outputs  1111 1111 101 1111

    while(1){
        send2displays(0x15);
        resetCoreTimer();
        while(readCoreTimer() < 4000000); // wait 0.2s
    }
    return 0;
}
