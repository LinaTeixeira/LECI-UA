#include <stdio.h>

int main(void){

    char name[30];  //aqui "name" funciona como um pointer
    puts("Digite o seu nome");
    //fgets(name ,sizeof(name), stdin);
    scanf("%s", name);
    printf("Hello %s\n", name);
}
