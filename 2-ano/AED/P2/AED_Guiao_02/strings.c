#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>


int checkChar (char *str){
    int charNum = 0;
    for (int i=0; i < strlen(str); i++){
        if (isalpha(str[i])){
            charNum++;
            }
        }return charNum;
}

int checkUpper (char *str){
    int charNum = 0;
    for (int i=0; i < strlen(str); i++){
        if (isupper(str[i])){
            charNum++;
            }
        }return charNum;
}

char* makeLower(char *str){
    for (int i=0; i < strlen(str); i++){
        if (isupper(str[i])){
            str[i] = tolower(str[i]);
        }
    }return str;
}

char* compStrs (char *str1, char *str2){
    int bigStr = strlen(str1);
    if (strlen(str1) < strlen(str2)){
        bigStr = strlen(str2);
        }

    for (int i = 0; i < bigStr; i++){
        if (!(str1[i] = str2[i])){
            qsort(str1, strlen(str1), sizeof(char), strcmp);
            qsort(str2, strlen(str2), sizeof(char), strcmp);

        } else{
            return "Sao iguais";
        }

    }
}


int main(void){
    char strs[2][21];


    printf("digite a primeira palavra\n");
    scanf("%20s", strs[0]);
    printf("digite a segunda palavra\n");
    scanf("%20s", strs[1]);

    printf("Numero de letras na primeira palavra: %d\n", checkChar(strs[0]));

    printf("Numero de letras maiusculas na segunda palavra: %d\n", checkUpper(strs[1]));

    printf("agora em minusculas: %s %s", makeLower(strs[0]), makeLower(strs[1]));

}

    
