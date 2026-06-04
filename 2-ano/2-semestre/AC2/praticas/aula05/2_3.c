#include<detpic32.h>
void send2displays(unsigned char value){
    static const char disp7Scodes[] = {0x3F, 0x06, 0x5B,
                                0x4F, 0x66, 0x6D, 
                                0x7D, 0x07, 0x7F,
                                0x6F, 0x77, 0x7C,
                                0x39, 0x5E, 0x79, 0x71 };
    static char displayFlag = 0;
    int dLow = (value % 10);
    int dHigh = (value / 10);

    if (displayFlag==0){
        LATDbits.LATD5 = 1;
        LATDbits.LATD6 = 0;
        LATB = (LATB & 0x80FF) | (disp7Scodes[dLow] << 8);
    } else {
        LATDbits.LATD5 = 0;
        LATDbits.LATD6 = 1;
        LATB = (LATB & 0x80FF) | (disp7Scodes[dHigh] << 8);
    }
    displayFlag = !displayFlag;
}

unsigned char toBCD(unsigned char value){
    return ((value / 10) << 4) + (value % 10);
}

int main(void){
    TRISD = (TRISD & 0xFF9F);   //RD5-RD6 saídas
    TRISB = (TRISB & 0x80FF) | 0x0001;;  // RB8-RB14 saídas e RD0 entrada 
    TRISE = TRISE & 0xFF00;     // RE7-RE0
    unsigned int i=0;
    unsigned char count = 0;
    int up;
    while(1){
        send2displays(count);
        LATE = (LATE & 0xFF00) | toBCD(count);
        resetCoreTimer();
        while(readCoreTimer() < 200000); // 100Hz = 10ms
        up = PORTBbits.RB0;
        if (up){
            i = (i+1) % 20;// 200ms = 10 * 20
            if (i == 0){
                count = (count +1) % 60;
            }
        }else if(!up){
            i = (i+1) % 50; // 500ms = 10 *50
            if(i == 0){
                count = (count -1 +60) %60;
            }
        } 
    }
    return 0;
}
