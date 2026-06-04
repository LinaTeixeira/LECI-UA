#include <detpic32.h>
void send2displays(unsigned char val){
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

unsigned char toBcd(unsigned char value) {
    return ((value / 10) << 4) | (value % 10);
}

void delay(unsigned ms){
    resetCoreTimer();
    while(readCoreTimer() < 20000 * ms);
}

volatile unsigned char voltage = 0;
int main(void){
    unsigned int cnt = 0;

    // configuracao do modulo AD
    TRISBbits.TRISB4 = 1;
    AD1PCFGbits.PCFG4 = 0;
    AD1CON1bits.SSRC = 7;

    AD1CON1bits.CLRASAM = 1;    // stop conversion when the 1st A/D interrupt is generated
    AD1CON3bits.SAMC = 16;      // sample time is 16 TAD (TAD = 100 ns)
    AD1CON2bits.SMPI = 7;       // 7 amostras

    AD1CHSbits.CH0SA = 4;       // input analog channel
    AD1CON1bits.ON = 1;         // enable ADC

    // configuracao do sistema de interrupcoes
    IPC6bits.AD1IP = 2;     // prioridade das interrupcoes do A/D
    IFS1bits.AD1IF = 0;     // clear interrupt flag
    IEC1bits.AD1IE = 1;     // enable A/D interrupts

    //configuracao dos displays
    TRISD = TRISD & 0xFF9F;      // RD5 e RD6 output
    TRISB = TRISB & 0x80FF;     // RB14 - RB8 outputs

    EnableInterrupts();
    while(1){
        if(cnt == 0){
            AD1CON1bits.ASAM = 1;   // comecar conversao
        }
        send2displays(voltage);
        cnt = (cnt + 1) % 20;        // 5Hz freq de amostragem -> 0.2s = 200ms -> 10*20 = 200ms
        delay(10);               // 100Hz refresh -> 0.01s = 10ms
    }

    return 0;

}


void _int_(27) isr_adc(void){       // family data sheet procurar por "interrupt IRQ"
    int *p = (int *)(&ADC1BUF0);
    int i, average = 0;
    for(i = 0; i < 8; i++){         // 8 samples
        average = average + p[i*4];
    }
    average = average/8;        // media
    voltage = toBcd((average * 33 + 511) / 1023);
    
    IFS1bits.AD1IF = 0;             // reset
}    
