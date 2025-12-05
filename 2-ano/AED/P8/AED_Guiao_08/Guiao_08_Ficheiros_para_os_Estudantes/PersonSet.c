//
// Algoritmos e Estruturas de Dados --- 2024/2025
//
// Joaquim Madeira, Nov 2023, Nov 2024
//

// Complete the functions (marked by ...)
// so that they pass all tests.

#include "PersonSet.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Definition of the structure
struct _PersonSet_ {
  int capacity;    // the current capacity of the array
  int size;        // the number of elements currently stored
  Person **array;  // points to an array of pointers to persons
};

#define INITIAL_CAPACITY 4

// You may add auxiliary definitions and declarations here, if you need to.

// Create a PersonSet.
PersonSet *PersonSetCreate() {
  // You must allocate space for the struct and for the array.
  // The array should be created with INITIAL_CAPACITY elements.
  // (The array will be reallocated if necessary, when elements are appended.)

  // COMPLETE ...
  PersonSet* p = (PersonSet*)malloc(sizeof(PersonSet));
  if (p ==NULL) return NULL;
  p->capacity = INITIAL_CAPACITY;
  p->size = 0;
  p->array = (void**)malloc(INITIAL_CAPACITY * sizeof(void*)); 
  if (p->array == NULL){
    free(p);
    abort();
  }
  return p;
}

// Destroy PersonSet *pps
void PersonSetDestroy(PersonSet **pps) {
  assert(*pps != NULL);
  PersonSet* p = *pps;
  free(p->array);
  free(p);
  *pps = NULL;
  // COMPLETE ...
}

int PersonSetSize(const PersonSet *ps) { return ps->size; }

int PersonSetIsEmpty(const PersonSet *ps) { return ps->size == 0; }

void PersonSetPrint(const PersonSet *ps) {
  printf("{\n");
  for (int i = 0; i < ps->size; i++) {
    Person *p = ps->array[i];
    PersonPrintf(p, ";\n");
  }
  printf("}(size=%d, capacity=%d)\n", ps->size, ps->capacity);
}

// Find index in ps->array of person with given id.
// (INTERNAL function.)
static int search(const PersonSet *ps, int id) {
  // COMPLETE ...
  for (int i = 0; i < ps->size; i++) {
    PersonSet *p = ps->array[i];
    if(PersonSetContains( ps, id)){
      return i;
    }
  }
  return -1;
}

// Append person *p to *ps, without verifying presence.
// Use only when sure that *p is not contained in *ps!
// (INTERNAL function.)
static void append(PersonSet *ps, Person *p) {
  // MODIFY the function so that if the array is full,
  // it uses realloc to double the array capacity!

  // COMPLETE ...
  if (ps->size == ps->capacity){
    ps = realloc(ps, ps->capacity);
  }

  ps->array[ps->size] = p;
  ps->size++;
}

// Add person *p to *ps.
// Do nothing if *ps already contains a person with the same id.
void PersonSetAdd(PersonSet *ps, Person *p) {
  // You may call the append function here!
  for(int i=0; i <= ps->size; i++){
    Person *p1 = ps->array[i];
    if(p1->id !=  p ->id){
      append(ps, p);
    }
  }
  // COMPLETE ...
}

// Pop one person out of *ps.
Person *PersonSetPop(PersonSet *ps) {
  assert(!PersonSetIsEmpty(ps));
  // It is easiest to pop and return the person in the last position!
  // COMPLETE ...
  return ps->array[--(ps->size)];
  return NULL;
}

// Remove the person with given id from *ps, and return it.
// If no such person is found, return NULL and leave set untouched.
Person *PersonSetRemove(PersonSet *ps, int id) {
  // You may call search here!
  int foundId = search(ps, id);
  if (foundId != -1){ 
    PersonSet *p = ps->array[foundId];
    ps->array[foundId] == NULL;
    return p;
  }
  // COMPLETE ...
  return NULL;
}

// Get the person with given id of *ps.
// return NULL if it is not in the set.
Person *PersonSetGet(const PersonSet *ps, int id) {
  // You may call search here!
  int foundID = search(ps, id);
  Person *p = ps->array[foundID];
  if (foundID != -1){
    return p;
  }
  return NULL;
}

// Return true (!= 0) if set contains person wiht given id, false otherwise.
int PersonSetContains(const PersonSet *ps, int id) {
  return search(ps, id) >= 0;
}

// Return a NEW PersonSet with the union of *ps1 and *ps2.
// Return NULL if allocation fails.
// NOTE: memory is allocated.  Client must call PersonSetDestroy!
PersonSet *PersonSetUnion(const PersonSet *ps1, const PersonSet *ps2) {
  PersonSet *ps = PersonSetCreate();
  for(int i=0 ; ps1->capacity; i++){
    Person *p1 = ps1->array[i];
    PersonSetAdd(ps, p1);
  }
  for (int j = 0; ps2->capacity; j++){
    Person *p2 = ps2 ->array[j];
    PersonSetAdd(ps, p2);  
    }
  // COMPLETE ...

  return ps;
}

// Return a NEW PersonSet with the intersection of *ps1 and *ps2.
// Return NULL if allocation fails.
// NOTE: memory is allocated.  Client must call PersonSetDestroy!
PersonSet *PersonSetIntersection(const PersonSet *ps1, const PersonSet *ps2) {
  // COMPLETE ...
  PersonSet *ps = PersonSetCreate();
  for(int i=0 ; ps1->capacity; i++){
    Person *p1 = ps1->array[i];
    for (int j=0; ps2->capacity;j++){
      Person *p2 = ps2->array[i];
      if (PersonCompareByBirth(p1, p2) == 0 && PersonCompareByLastFirstName(p1, p2) == 00){
        PersonSetAdd(ps,p1);
    }
  }
  return NULL;
}

// Return a NEW PersonSet with the set difference of *ps1 and *ps2.
// Return NULL if allocation fails.
// NOTE: memory is allocated.  Client must call PersonSetDestroy!
PersonSet *PersonSetDifference(const PersonSet *ps1, const PersonSet *ps2) {
  // COMPLETE ...

  return NULL;
}

// Return true iff *ps1 is a subset of *ps2.
int PersonSetIsSubset(const PersonSet *ps1, const PersonSet *ps2) {
  // COMPLETE ...

  return 0;
}

// Return true if the two sets contain exactly the same elements.
int PersonSetEquals(const PersonSet *ps1, const PersonSet *ps2) {
  // You may call PersonSetIsSubset here!

  // COMPLETE ...

  return 0;
}
