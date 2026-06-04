#include <detpic32.h>

unsigned char toBcd(unsigned char value) {
    return ((value / 10) << 4) | (value % 10);
}

void send2displays(unsigned char value){
    static const char disp7Scodes[] = {0x3F, 0x06, 0x5b, 0x4F, 0x66,
                                        0x6d, 0x7d, 0x07, 0x7F, 0x6F};
    static char displayFlag = 0;  
    int dl = value & 0x0F;                                  
    int dh = value >> 4;
    
    if (displayFlag == 0){
        LATDbits.LATD6 = 0; // select display low
        LATDbits.LATD5 = 1;

        LATB = (LATB & 0x80FF) | (disp7Scodes[dl] << 8);

        displayFlag = 1;

    } else {
        LATDbits.LATD6 = 1; // select display high
        LATDbits.LATD5 = 0;
        
        LATB = (LATB & 0x80FF) | (disp7Scodes[dh] << 8);

        displayFlag = 0;
    }
}

volatile char UP;
volatile char PLAY;

int counter = 0;
int main (void){
    TRISB = TRISB & 0x80FF;
    TRISD = TRISD & 0xFF9F;        // FF 1001 F

    // configuracoes T1 1Hz -> 2Hz
    T1CONbits.TCKPS = 3;     // K = 20000000/65536/2 = 152 -> 256
    PR1 = 39061;                 // PR1 = 20M/256/2 - 1 = 39061????
    TMR1 = 0;
    T1CONbits.TON = 1;

    IPC1bits.T1IP = 3;
    IEC0bits.T1IE = 1;
    IFS0bits.T1IF = 0;


    //configuracoes T2 -> 100Hz
    T2CONbits.TCKPS = 3; // 3 ->8
    PR2 = 24999;             // PR2 = 
    TMR2 = 0;
    T2CONbits.TON = 1;

    IPC2bits.T2IP = 2;
    IEC0bits.T2IE = 1;
    IFS0bits.T2IF = 0;

    // RB3 e RB0 entradas
    TRISB = TRISB | 0x0009;       //000 1001

    EnableInterrupts();
    while(1){
        IdleMode();
    }

    return 0;
}

void _int_(4) isr_T1(void){
    static char T1flag = 0;
    if (T1flag == 1){
        if (PLAY){
            if(UP){
                counter = (counter + 1) % 30;
            }else{
                counter = (counter + 29) % 30;
            }
        }
    }
    T1flag = !T1flag;
    IFS0bits.T1IF = 0;
}

void _int_(8) isr_T2(void){
    UP = PORTBbits.RB0;
    PLAY = PORTBbits.RB3;
    send2displays(toBcd(counter));
    IFS0bits.T2IF = 0;
}
