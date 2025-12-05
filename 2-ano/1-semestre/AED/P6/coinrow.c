#include<stdio.h>

int coinrow(int *c, int c_size){
    if (c_size == 0) {return 0;}
    if (c_size == 1) {return c[0];}
    
    return(max(c[c_size] + coinrow( *c, c_size-2), coinrow( *c ,c_size-1)));
}

int main(void){
    int c_size = 0;
    printf("how many coins?\n");
    scanf("%d", c_size);
    int coins[c_size];
    for (int i=0; i< c_size; i++){
        printf("moeda #%d", i);
        scanf("%d", coins[i]);
    }

    printf("coinrow solution: %d", coinrow(*coins, c_size));
    return 0;
}