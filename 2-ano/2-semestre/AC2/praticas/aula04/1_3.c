#include<detpic32.h>

int main(void){
    // RE6-RE3 como saídas
    TRISE = (TRISE & 0xFF87);      // 1111 1111 1000 0111

    int cnt = 0;
    while(1){
        // merge com cnt na posicao certa
        LATE = (LATE & 0xFF87) | cnt << 3;

        resetCoreTimer();
        while(readCoreTimer() < 7407407);  // freq de 2.7Hz ( 20000000 / 2.7)

        cnt = (cnt - 1 + 10) % 10;  //decremento do contador

    }
    return 0;
}
