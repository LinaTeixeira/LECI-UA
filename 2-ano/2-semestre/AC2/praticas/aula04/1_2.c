#include <detpic32.h> 

int main(void){

    TRISE = TRISE & 0xFF87; // RE6-RE3 como saídas
    int counter = 0;

    while(1){
        LATE = (LATE & 0xFF87) | counter << 3;  // reset dos bits que vamos atualizar e merge
        resetCoreTimer();
        while(readCoreTimer() < 4347826); // 1/4,6 * 20000000
        counter = (counter + 1) % 10;
    }

    return 0;
}
