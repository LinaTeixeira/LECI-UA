# include <detpic32.h>

int main(void){

    // configuracao do modulo AD
    TRISBbits.TRISB4 = 1;
    AD1PCFGbits.PCFG4 = 0;
    AD1CON1bits.SSRC = 7;

    AD1CON1bits.CLRASAM = 1;    // stop conversion when the 1st A/D interrupt is generated
    AD1CON3bits.SAMC = 16;      // sample time is 16 TAD (TAD = 100 ns)
    AD1CON2bits.SMPI = 0;       // 1 sample

    AD1CHSbits.CH0SA = 4;       // input analog channel
    AD1CON1bits.ON = 1;         // enable ADC

    // configuracao do sistema de interrupcoes
    IPC6bits.AD1IP = 2;     // prioridade das interrupcoes do A/D
    IFS1bits.AD1IF = 0;     // clear interrupt flag
    IEC1bits.AD1IE = 1;     // enable A/D interrupts

    TRISDbits.TRISD11 = 0;      // RD11 saída

    EnableInterrupts();
    AD1CON1bits.ASAM = 1;   // comecar conversao
    while(1){
        // tudo feito pela RSI
    }

    return 0;
}

void _int_(27) isr_adc(void){       // family data sheet procurar por "interrupt IRQ"
    LATDbits.LATD11 = 0;
    volatile int adc_value;
    adc_value = ADC1BUF0;
    LATDbits.LATD11 = 1;
    
    AD1CON1bits.ASAM = 1;           // start A/D Conversion
    IFS1bits.AD1IF = 0;             // reset
}
