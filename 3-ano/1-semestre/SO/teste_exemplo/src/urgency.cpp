/**
 * @file
 *
 * \brief A hospital pediatric urgency with a Manchester triage system.
 */

#include <pthread.h>
#include  <stdio.h>
#include  <stdlib.h>
#include  <string.h>
#include  <libgen.h>
#include  <unistd.h>
#include  <sys/wait.h>
#include  <sys/types.h>
#include  <math.h>
#include  <stdint.h>
#include  <signal.h>
#include  <utils.h>
#include <iostream>
#include <dbc.h>
#include <hdp.h>
#include  "settings.h"
#include  "pfifo.h"

/* DO NOT CHANGE THE FOLLOWING VALUES, run program with option -h to set a different values */

/**
 * Simulation parameters (immutable during concurrent execution):
 */
static int NUM_PATIENTS = 4;
static int NUM_NURSES = 1;
static int NUM_DOCTORS = 1;
static int MIN_RANDOM_WAIT_MS = 0;
static int MAX_RANDOM_WAIT_MS = 100;

#define USAGE "Synopsis: %s [options]\n" \
   "\t----------+-------------------------------------------------------------\n" \
   "\t  Option  |          Description                                        \n" \
   "\t----------+-------------------------------------------------------------\n" \
   "\t -p num   | number of patients (dfl: %d, min: %d, max: %d)              \n" \
   "\t -n num   | number of nurses (dfl: %d, min: %d, max: %d)                \n" \
   "\t -d num   | number of doctors (dfl: %d, min: %d, max: %d)               \n" \
   "\t -w num   | minimum random wait (dfl: %dms)                             \n" \
   "\t -W num   | maximum random wait (dfl: %dms)                             \n" \
   "\t -h       | this help                                                   \n" \
   "\t----------+-------------------------------------------------------------\n", \
   basename(argv[0]), NUM_PATIENTS, 1, MAX_PATIENTS, NUM_NURSES, 1, MAX_NURSES, NUM_DOCTORS, 1, MAX_DOCTORS, \
   MIN_RANDOM_WAIT_MS, MAX_RANDOM_WAIT_MS

// TODO point: changes may be required in these date structures

/**
 * \brief Patient data structure
 */
typedef struct
{
   char name[MAX_NAME+1];
   int done; // 0: waiting for consultation; 1: consultation finished
} Patient;

typedef struct
{
   int num_patients;
   Patient all_patients[MAX_PATIENTS];
   PriorityFIFO triage_queue;
   PriorityFIFO doctor_queue;

   pthread_mutex_t patient_mtx;
   pthread_cond_t isDone_cv;
} HospitalData;

HospitalData * hd = NULL;

// TODO point: if necessary, add module variables here


/**
 *  \brief verification tests:
 */
#define check_valid_patient(id) do { check_valid_patient_id(id); check_valid_name(hd->all_patients[id].name); } while(0)
#define check_valid_nurse(id) do { check_valid_nurse_id(id); } while(0)
#define check_valid_doctor(id) do { check_valid_doctor_id(id); } while(0)

int random_manchester_triage_priority();
void new_patient(Patient* patient); // initializes a new patient
void random_wait();                 // a random pause in [MIN_RANDOM_WAIT_MS;MAX_RANDOM_WAIT_MS] ms


/* ************************************************* */

void init_simulation(int np)
{
   printf("Initializing simulation\n");
   hd = (HospitalData*)Nu(malloc(sizeof(HospitalData)));
   memset(hd, 0, sizeof(HospitalData));
   hd->num_patients = np;
   init_pfifo(&hd->triage_queue);
   init_pfifo(&hd->doctor_queue);

   NZ(pthread_mutex_init(&hd->patient_mtx, NULL));
   NZ(pthread_cond_init(&hd->isDone_cv, NULL));
}

/* ************************************************* */

void term_simulation(int np) {
   // DO NOT WAIT THE TERMINATION OF ACTIVE ENTITIES IN THIS FUNCTION!
   // This function is just to release the allocated resources

   printf("Releasing resources\n");
   term_pfifo(&hd->doctor_queue);
   term_pfifo(&hd->triage_queue);

   NZ(pthread_cond_destroy(&hd->isDone_cv));
   NZ(pthread_mutex_destroy(&hd->patient_mtx));

   free(hd);
   hd = NULL;
}

/* ************************************************* */

int nurse_iteration(int id) // return value can be used to request termination
{
   check_valid_nurse(id);
   printf("\e[34;01mNurse %d: get next patient\e[0m\n", id);
   int patient = retrieve_pfifo(&hd->triage_queue);
   // TODO point: PUT YOUR NURSE TERMINATION CODE HERE:
   if (patient == -1){
       return 1;
   }
   check_valid_patient(patient);
   printf("\e[34;01mNurse %d: evaluate patient %d priority\e[0m\n", id, patient);
   int priority = random_manchester_triage_priority();
   printf("\e[34;01mNurse %d: add patient %d with priority %d to doctor queue\e[0m\n", id, patient, priority);
   insert_pfifo(&hd->doctor_queue, patient, priority);

   return 0;
}

/* ************************************************* */

int doctor_iteration(int id) // return value can be used to request termination
{
   check_valid_doctor(id);
   printf("\e[32;01mDoctor %d: get next patient\e[0m\n", id);
   int patient = retrieve_pfifo(&hd->doctor_queue);
   // TODO point: PUT YOUR DOCTOR TERMINATION CODE HERE:
   if (patient == -1){
       return 1;
   }
   check_valid_patient(patient);
   printf("\e[32;01mDoctor %d: treat patient %d\e[0m\n", id, patient);
   random_wait();
   printf("\e[32;01mDoctor %d: patient %d treated\e[0m\n", id, patient);
   // TODO point: PUT YOUR PATIENT CONSULTATION FINISHED NOTIFICATION CODE HERE:
   NZ(pthread_mutex_lock(&hd->patient_mtx));
   hd->all_patients[patient].done = 1;
   NZ(pthread_cond_broadcast(&hd->isDone_cv));
   NZ(pthread_mutex_unlock(&hd->patient_mtx));

   return 0;
}

/* ************************************************* */

void patient_goto_urgency(int id)
{
   new_patient(&hd->all_patients[id]);
   check_valid_name(hd->all_patients[id].name);
   printf("\e[30;01mPatient %s (number %d): get to hospital\e[0m\n", hd->all_patients[id].name, id);
   insert_pfifo(&hd->triage_queue, id, 1); // all elements in triage queue with the same priority!
}

void patient_wait_end_of_consultation(int id)
{
   check_valid_name(hd->all_patients[id].name);
   // TODO point: PUT YOUR WAIT CODE FOR FINISHED CONSULTATION HERE:
   NZ(pthread_mutex_lock(&hd->patient_mtx));
   while(hd->all_patients[id].done ==0) {
       NZ(pthread_cond_wait(&hd->isDone_cv, &hd->patient_mtx));
   }
   check(hd->all_patients[id].done == 1, "consultation not done");
   printf("\e[30;01mPatient %s (number %d): health problems treated\e[0m\n", hd->all_patients[id].name, id);
   NZ(pthread_mutex_unlock(&hd->patient_mtx));
}

void patient_life(int id)
{
   patient_goto_urgency(id);
   //nurse_iteration(0);  // TODO point: to be commented/deleted in concurrent version
   //doctor_iteration(0); // TODO point: to be commented/deleted in concurrent version
   patient_wait_end_of_consultation(id);
   memset(&(hd->all_patients[id]), 0, sizeof(Patient)); // patient finished
}

/* ************************************************* */

// TODO point: if necessary, add extra functions here:
void *patient_thread(void* arg){
    patient_life(*(int*) arg);
    return NULL;
}

void *doctor_thread(void* arg){
    while (doctor_iteration(*(int*) arg) == 0);
    return NULL;
}

void *nurse_thread(void* arg){
    while(nurse_iteration(*(int*) arg) == 0);
    return NULL;
}


/* ************************************************* */

int main(int argc, char *argv[])
{
   /* command line processing */
   int option;
   while ((option = getopt(argc, argv, "p:n:d:w:W:h")) != -1)
   {
      switch (option)
      {
         case 'p':
            NUM_PATIENTS = atoi(optarg);
            if (NUM_PATIENTS < 1 || NUM_PATIENTS > MAX_PATIENTS)
            {
               fprintf(stderr, "Invalid number of patients!\n");
               return EXIT_FAILURE;
            }
            break;

         case 'n':
            NUM_NURSES = atoi(optarg);
            if (NUM_NURSES < 1 || NUM_NURSES > MAX_NURSES)
            {
               fprintf(stderr, "Invalid number of nurses!\n");
               return EXIT_FAILURE;
            }
            break;

         case 'd':
            NUM_DOCTORS = atoi(optarg);
            if (NUM_DOCTORS < 1 || NUM_DOCTORS > MAX_DOCTORS)
            {
               fprintf(stderr, "Invalid number of doctors!\n");
               return EXIT_FAILURE;
            }
            break;

         case 'w':
            MIN_RANDOM_WAIT_MS = atoi(optarg);
            if (MIN_RANDOM_WAIT_MS < 0 || MIN_RANDOM_WAIT_MS > MAX_RANDOM_WAIT_MS)
            {
               fprintf(stderr, "Invalid minimum random wait!\n");
               return EXIT_FAILURE;
            }
            break;

         case 'W':
            MAX_RANDOM_WAIT_MS = atoi(optarg);
            if (MAX_RANDOM_WAIT_MS < 0 || MAX_RANDOM_WAIT_MS < MIN_RANDOM_WAIT_MS)
            {
               fprintf(stderr, "Invalid maximum random wait!\n");
               return EXIT_FAILURE;
            }
            break;

         case 'h':
            printf(USAGE);
            return EXIT_SUCCESS;

         default:
            fprintf(stderr, "Non valid option!\n");
            fprintf(stderr, USAGE);
            return EXIT_FAILURE;
      }
   }

   /* start random generator */
   srand(getpid());

   /* init simulation */
   init_simulation(NUM_PATIENTS);

   // TODO point: REPLACE THE FOLLOWING DUMMY CODE WITH code to launch
   // active entities and code to properly terminate the simulation.
   /* dummy code to show a very simple sequential behavior

   for(int i = 0; i < NUM_PATIENTS; i++)
   {
      printf("\n");
      random_wait(); // random wait for patience creation
      patient_life(i);
   }
   end of dummy code */

   //------------CREATE-------------------
   pthread_t tpatient[NUM_PATIENTS];
   pthread_t tnurses[NUM_NURSES];
   pthread_t tdoctors[NUM_DOCTORS];

   int p_id[NUM_PATIENTS], n_id[NUM_NURSES], d_id[NUM_DOCTORS];

   for (int i = 0; i < NUM_PATIENTS; i++){
       p_id[i] = i;
       NZ(pthread_create(&tpatient[i], NULL, patient_thread, &p_id[i]));
   }

   for (int i = 0; i < NUM_NURSES; i++){
       n_id[i] = i;
       NZ(pthread_create(&tnurses[i], NULL, nurse_thread, &n_id[i]));
   }

   for (int i = 0; i < NUM_DOCTORS; i++){
       d_id[i] = i;
       NZ(pthread_create(&tdoctors[i], NULL, doctor_thread, &d_id[i]));
   }

   //------------JOIN-------------------

   for (int i =0; i< NUM_PATIENTS; i++){
       NZ(pthread_join(tpatient[i], NULL));
       random_wait();
   }

   /* close fifos */
   close_pfifo(&hd->triage_queue);
   close_pfifo(&hd->doctor_queue);

   for (int i =0; i< NUM_NURSES; i++){
       NZ(pthread_join(tnurses[i], NULL));
   }

   for (int i =0; i< NUM_DOCTORS; i++){
       NZ(pthread_join(tdoctors[i], NULL));
   }

   /* terminate simulation */
   term_simulation(NUM_PATIENTS);

   return EXIT_SUCCESS;
}


/* IGNORE THE FOLLOWING CODE */

int random_manchester_triage_priority()
{
   int result;
   int perc = random_int(0, 100);
   if (perc < 10)
      result = RED;
   else if (perc < 30)
      result = ORANGE;
   else if (perc < 50)
      result = YELLOW;
   else if (perc < 75)
      result = GREEN;
   else
      result = BLUE;
   return result;
}

static char **names = (char *[]) {
   "Ana", "Miguel", "Luis", "Joao",
   "Artur", "Maria", "Luisa", "Mario",
   "Augusto", "Antonio", "Jose", "Alice",
   "Almerindo", "Gustavo", "Paulo", "Paula",
   NULL};
static int names_len = 16;

char* random_name()
{
   return names[random_int(0, names_len-1)];
}

void new_patient(Patient* patient)
{
   strcpy(patient->name, random_name());
   patient->done = 0;
}

void random_wait()
{
   usleep(1000*random_int(MIN_RANDOM_WAIT_MS, MAX_RANDOM_WAIT_MS));
}
