#include <stdio.h>

int contador1 = -1; // iniciamos os contadores a -1
int contador2 = -1; // para contarmos apenas chamadas recursivas
int contador3 = -1;  // ou seja, ignoramos a primeira chamada(que é nao recursiva)

int T1 (int n){
    contador1++;
    if (n == 1){return 1;}

    else if (n>1){
        return T1(n/2) + n;
    }
    else{ return -1;}
}

int T2 (int n){
    contador2++;
    if (n==1){return 1;}
    else if(n > 1){
        return T2(n/2) + T2((n+1)/2) + n;
    }
    else{ return -1;}
}

int T3(int n){
    contador3++;
    if(n == 1){return 1;}
    else if(n%2 == 0){
        return T3(n/2) + T3((n+1)/2) + n;}
    else{ return 2*T3(n/2) +n;
    }
}

int main(void){
    int n = 3;
    int result1 = T1(n);
    printf("T(%d) = %d, chamada %d vezes\n", n, result1, contador1);

    int result2 = T2(n);
    printf("T(%d) = %d, chamada %d vezes\n", n, result2, contador2);

    int result3 = T3(n);
    printf("T(%d) = %d, chamada %d vezes\n", n, result3, contador3);

    return 0;
}