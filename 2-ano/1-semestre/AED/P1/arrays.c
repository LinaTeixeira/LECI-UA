#include <stdio.h>

void printArray(char s, int array[]){
    printf("%s:\n", s);
    for (int i = 0; i < sizeof(array); i++){  //iterar sobre o array 
        printf("%d ", array[i]);   // e printar cada elemento
    }

}


int main(void){
    int a [12] = {31,28,31,30,31,30,31,31,30,31,30,31};
    printArray("a", a);
}
