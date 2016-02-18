#include <stdio.h>
#include <time.h>
#include <sys/time.h>

double cputime() { 
    clock_t sec; 
    double ret;
    sec = clock();
    if (sec < 0) { ret = -1; return ret; }
        ret = sec / (double) CLOCKS_PER_SEC;
    return ret;
}
double somethingsilly(char *var) { 
    printf("Something from C: %s\n", var); 
    return 42.0; 
}
