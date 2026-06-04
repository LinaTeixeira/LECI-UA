#include <detpic32.h>

void send2disp(unsigned char val){
    static const char disp7Scodes[] = {0x3F, 0x06, 0x5B,
                                0x4F, 0x66, 0x6D, 
                                0x7D, 0x07, 0x7F,
                                0x6F, 0x77, 0x7C,
                                0x39, 0x5E, 0x79, 0x71 };

    static char dispFlag = 0;
    int valHigh = val >> 4;
    int valLow = val & 0x0F;
    if(dispFlag == 0){
        // display low
        LATD = (LATD & 0xFFBF) | 0x0020;   // 1111 1111 1101 1111
        LATB = (LATB & 0x80FF) | (disp7Scodes[valLow] << 8);
    } else{
        //dispHigh
        LATD = (LATD & 0xFFDF) | 0x0040;   // 1111 1111 1011 1111
        LATB = (LATB & 0x80FF) | (disp7Scodes[valHigh] << 8);
    }
    dispFlag = !dispFlag;
}

void delay(unsigned int ms){
    resetCoreTimer();
    while(readCoreTimer() < ms * 20000);
}

unsigned char toBcd(unsigned char value){
    return ((value / 10) << 4) + (value % 10);
}

int main(void){
    TRISBbits.TRISB4 = 1;
    AD1PCFGbits.PCFG4 = 0;  //RB4 como input analog

    AD1CON1bits.SSRC = 7;
    AD1CON1bits.CLRASAM = 1;

    AD1CON3bits.SAMC = 16;
    AD1CON2bits.SMPI = 4-1; //interrupt after 4 sample

    AD1CHSbits.CH0SA = 4;   // input analog channel = 4

    AD1CON1bits.ON = 1; //enable ADC


    TRISB = (TRISB & 0x80FF);
    TRISD = (TRISD & 0xFF9F);
    int i = 0;
    int v;
    unsigned char v_bcd = 0;
    int *p = (int*)(&ADC1BUF0); // ponteiro para o inicio do buffer

    while(1){
        if(i == 0){ //freq 5Hz
            // convert analog input
            AD1CON1bits.ASAM = 1;
            while(IFS1bits.AD1IF == 0);

            int soma = 0;
            int j=0;
            for (; j < 4; j++){
                soma = soma + p[j*4];
            }
            int media = soma/4;
            v = (media * 33 + 511) / 1023;
            v_bcd = toBcd((unsigned char)v);

            IFS1bits.AD1IF = 0;
        }
        send2disp(v_bcd);
        delay(10);
        i = (i + 1) % 20; // 20 * 10ms = 200ms (5Hz)
    }

    return 0;
}
