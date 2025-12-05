#include <stdio.h>
#include <math.h>

int main(void){
    int size;
    printf("numero de linhas?");
    scanf("%d", &size);
    puts("numero |  quadrado |  raiz");
    for (int i = 1 ; i <= (size); i++){
        printf("%6d | %9d |  %.4f \n", i, i*i, sqrt(i));
    }

    return 0;
}