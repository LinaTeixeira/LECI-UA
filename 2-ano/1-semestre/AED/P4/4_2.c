#include <stdio.h>
#include<assert.h>

int isGeometricSeq(int* array, int n){
    assert(n>2);
    int comp = 0;
    float r = array[1] / array[0];
    for (int i = 2; i < n; i++){
        if(array[i] !=(r * array[i-1])){
            comp++;
            printf("\n%d\n", comp);
            return 0;
        }
    }
    return 1;
}

int main(void){
    int array[10] = {1,2,4,8,5,6,7,8,9,10};
    printf("%d\n", isGeometricSeq(array, 10));

    return 0;
}