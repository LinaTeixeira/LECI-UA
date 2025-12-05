#include <stdio.h>

int main(void){
    //int int_type;
    //char char_type;
    printf("Size of Int: %ld\n",sizeof(int));  /*ld para long*/
    printf("Size of Char: %ld\n", sizeof(char));
    printf("Size of void: %ld\n", sizeof(void *));
    printf("Size of long: %ld\n", sizeof(long));
    printf("Size of double: %ld\n", sizeof(double));
    printf("Size of float: %ld\n", sizeof(float));
}