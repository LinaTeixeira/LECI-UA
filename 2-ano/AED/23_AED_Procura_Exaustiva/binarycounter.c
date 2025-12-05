//
// Algoritmos e Estruturas de Dados --- 2024/2025
//
// J. Madeira, June 2010
//
// Binary Counter
//
// Can be used to generate all sub-sets of a set of n elements
//

#include "binarycounter.h" /* header file */

#include <stdio.h>
#include <stdlib.h>

int* createBinCounter(int size) { return (int*)calloc(size, sizeof(int)); }

void copyBinCounter(int* original, int* copy, int size) {
  int i;

  for (i = 0; i < size; i++) {
    copy[i] = original[i];
  }
}

void destroyBinCounter(int** binCounter) {
  free(*binCounter);
  *binCounter = NULL;
}

void printBinCounter(int* binCounter, int size) {
  int i;

  for (i = size - 1; i >= 0; i--) {
    printf("%d", binCounter[i]);
  }

  printf("\n");
}

int increaseBinCounter(int* binCounter, int size) {
  int i = 0;

  while ((i < size) && (binCounter[i] == 1)) {
    binCounter[i] = 0;
    i++;
  }

  if (i < size) {
    binCounter[i] = 1;
    return 1;
  }

  /* Overflow */

  return 0;
}
