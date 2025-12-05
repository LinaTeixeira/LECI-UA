//
// Algoritmos e Estruturas de Dados --- 2024/2025
//
// J. Madeira, June 2010
//
// Generate all permutations of a set of n elements
//

#ifndef _PERMUTATION_
#define _PERMUTATION_

#include <stdio.h>
#include <stdlib.h>

int* createFirstPermutation(int n);
/* Cria o array de permutacoes com dimensao n, sendo a primeira permutacao
 * 123456...n */

void copyPermutation(int* original, int* copy, int n);
/* Copia a permutacao actual */

void destroyPermutation(int** p);
/* Destroi o array de permutacoes */

void printPermutation(int* p, int n);
/* Imprime a permutacao actual */

int nextPermutation(int* v, int n);
/* Cria a permutacao seguinte */

#endif  // _PERMUTATION_