#include<stdio.h>
#include<assert.h>

 void checkSum(int* array, int n){
    assert(n>2);
    int* p = array;
    int num = 0;
    int comp=0;
    for(int i = 1; i < n-1; i++ ){
        p++;
        int* bfore = p-1; 
        int* aftr= p+1;
        //printf("p:%d\n", *p);
        //printf("p-1:%d\n", *bfore);
        //printf("p+1:%d\n", *aftr);
        comp++;
        if (*bfore + *aftr == *p){
            num++;
            }
    }
    printf("numero de elementos que respeitam a propriedade:%d\n", num);
    printf("numero de comparacoes :%d\n", comp);
}


int main(void){
    int my_array[10]={0,0,0,0,0,0,0,0,0,0};
    checkSum(my_array, 2);

    return 0;
}