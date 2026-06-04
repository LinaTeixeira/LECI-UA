#include <detpic32.h>

int main(void){
    static int disp7Scodes[] = {0x3F, 0x06, 0x5B,
                                0x4F, 0x66, 0x6D, 
                                0x7D, 0x07, 0x7F,
                                0x6F, 0x77, 0x7C,
                                0x39, 0x5E, 0x79,
                                0x71 };

    TRISB = TRISB & 0x80FF; // RB8-RB14 como saídas
    TRISB = TRISB | 0x000F;  // RB3-RB0 como entradas
    TRISD = TRISD & 0xFF9F; // RD5 e RD6 saídas

    // 1111 1111 1011 1111
    LATD = (LATD & 0xFFBF) | 0x0020;    //display low active
    int dips, code;
    while(1){
        dips = PORTB & 0x000F;      // read dip-switch(bits 3-0)
        code = disp7Scodes[dips];
        LATB = (LATB & 0x80FF) | (code << 8);

    }
    return 0;
}
