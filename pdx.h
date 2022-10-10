/*
 * This file contains types and definitions for Portland State University.
 * The contents are intended to be visible in both user and kernel space.
 */

#ifndef PDX_INCLUDE
#define PDX_INCLUDE

//added in P2

#define TRUE 1
#define FALSE 0
#define RETURN_SUCCESS 0
#define RETURN_FAILURE -1

#define NUL 0
#ifndef NULL
#define NULL NUL
#endif  // NULL

#define _setuid 0
#define _setgid 0

#ifdef CS333_P4
#define DEFAULT_BUDGET (1*TPS)
#define DEFAULT_PRIORITY MAXPRIO
#define TICKS_TO_PROMOTE (3*TPS)
#define PRIO_MIN 0
#define PER_LINE 15
#define MAXPRIO 6
#define BUDGET 300
#endif //CS333_P4


#define TPS 1000   // ticks-per-second
#define SCHED_INTERVAL (TPS/100)  // see trap.c

#define NPROC  64  // maximum number of processes -- normally in param.h //for uint max (getprocs()), set max = to NPROC in ps.c; when it enters getprocs(), perform if conditional (if max >NPROC) set max = NPROC 

#define min(a, b) ((a) < (b) ? (a) : (b))
#define max(a, b) ((a) > (b) ? (a) : (b))

#endif  // PDX_INCLUDE
