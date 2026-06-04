#include <detpic32.h>

void delay(unsigned int ms){
    resetCoreTimer();
    while(readCoreTimer() < 20000 * ms);
}

int main(void){
    unsigned char segment;
    // 1111 1111 1011 1111
    TRISD = TRISD & 0xFF9F;
    TRISB = TRISB & 0x80FF;  
    LATD = (LATD & 0xFFDF) | 0x0040;    //LATDbits.LATD5 = 1;
                                        //LATDbits.LATD6 = 0;
    while(1){
        segment = 1;
        int i = 0;
        for(;i < 7; i++){
            LATB = (LATB & 0x80FF) | (segment << 8);
            delay(10); // 10 = 100Hz, 20 = 50Hz, 100 = 10Hz
            segment = segment << 1;
        }
        LATD = (LATD & 0xFFBF) | 0x0020;    //LATDbits.LATD5 = 0;
                                            //LATDbits.LATD6 = 1;
    }
    return 0;
}
