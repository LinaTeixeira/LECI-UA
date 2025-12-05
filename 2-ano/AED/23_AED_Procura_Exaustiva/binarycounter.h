//
// Algoritmos e Estruturas de Dados --- 2024/2025
//
// J. Madeira, June 2010
//
// Binary Counter
//
// Can be used to generate all sub-sets of a set of n elements
//

#ifndef _BINARY_COUNTER_
#define _BINARY_COUNTER_

#include <stdio.h>
#include <stdlib.h>

int* createBinCounter(int size);
/* Cria o contador binário com dimensão size, inicializado a zeros */

void copyBinCounter(int* original, int* copy, int size);
/* Copia o contador actual */

void destroyBinCounter(int** binCounter);
/* Destroi o contador */

void printBinCounter(int* binCounter, int size);
/* Imprime o contador */

int increaseBinCounter(int* binCounter, int size);
/* Incrementa o contador */

#endif  // _BINARY_COUNTER_
