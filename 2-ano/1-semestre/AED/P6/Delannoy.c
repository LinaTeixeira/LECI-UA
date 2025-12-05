#include <stdio.h>
#define SIZE 12
int add_counter = 0;
long long unsigned int Delannoy_Cache[SIZE][SIZE];

void initialize_Cache(void){  // inizializar a tabela a 0
    for(unsigned int i = 0; i < SIZE; i++){
        for (unsigned int j = 0; j < SIZE; j++){
            Delannoy_Cache[i][j] = 0;
        }
    }
}

long long unsigned int Delannoy(int n, int m){
    if (Delannoy_Cache[n][m] != 0) return Delannoy_Cache[n][m];
    long long unsigned int r;

    if (n == 0 || m == 0){
        r = 1;
    } else{
        add_counter += 2;
        r = Delannoy(n-1, m)+ Delannoy(n-1, m-1)+ Delannoy(n, m-1);
    }

    Delannoy_Cache[n][m] = r;
    return r;
}

int main(void){
    printf("Initialized matrix:\n");
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            printf("%lld ", Delannoy_Cache[i][j]);
        }
        printf("\n");
    }

    long long unsigned int n = 0, m = 0;
    printf("Introduza o n: ");
    scanf("%llu", &n);
    printf("introduza o m: ");
    scanf("%llu", &m);
    printf("D(%5llu, %5llu) = %10llu, somas:%d\n", n, m, Delannoy(n,m), add_counter);

    printf("Delanoy's Matrix - Recursive Function:\n");
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            printf("%5llu ", Delannoy_Cache[i][j]);
        }
        printf("\n");
    }

    return 0;

}