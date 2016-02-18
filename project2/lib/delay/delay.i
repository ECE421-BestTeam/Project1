%module Delay
%{ /* Header files or function prototypes go here in be included in the wrapper code*/
#include <time.h>
#include <sys/time.h>
extern double cputime();
extern double somethingsilly(char *var);
%}

/* Parse the function prototypes to generate wrappers */
extern double cputime();
extern double somethingsilly(char *var);