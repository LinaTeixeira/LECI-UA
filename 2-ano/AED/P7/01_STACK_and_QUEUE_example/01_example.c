//
// TO DO : desenvolva um algoritmo para verificar se um numero inteiro positivo
//         e uma capicua
//         Exemplos: 12321 e uma capiacua, mas 123456 nao e
//         USE uma PILHA DE INTEIROS (STACK) e uma FILA DE INTEIROS (QUEUE)
//
// TO DO : design an algorithm to check if the digits of a positive decimal
//         integer number constitue a palindrome
//         Examples: 12321 is a palindrome, but 123456 is not
//         USE a STACK of integers and a QUEUE of integers
//

#include <stdio.h>

#include "IntegersQueue.h"
#include "IntegersStack.h"

int main(void) { 
    int size = 0;
    int n = 0;
    printf("Introduza o tamanho: ");
    scanf("%d", &size);
    Queue* q1 = QueueCreate(size);
    Stack* s1 =StackCreate(size);

    printf("Introduza o n: ");
    scanf("%d", &n);

    while (n != 0) {
    int digit = n % 10;

    StackPush(s1, digit);
    QueueEnqueue(q1, digit);
    n /= 10;;
    }

    // checking for palindromes
    int equal =1;
    while ((equal ==1 ) && (StackIsEmpty(s1)==0)){
        equal = StackPop(s1) == QueueDequeue(q1);
    }

    if (equal == 0){
        printf("not a palindrome!\n");
    }else{ 
        printf("palindrome!");
    }

    //destroy
    StackDestroy(&s1);
    QueueDestroy(&q1);
    
    return 0; }
