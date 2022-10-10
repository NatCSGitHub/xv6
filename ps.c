//Natasha Needham
//CS333 Fall 2020
//Project 2
//add to defs.h and runoff list

#ifdef CS333_P2
#include "types.h"
#include "user.h"
#include "uproc.h"
#ifdef CS333_P4
#define HEADER "\nPID\tName         UID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\n"
#elif CS333_P2
#define HEADER "\nPID\tName         UID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n"
#endif

int
main(int argc, char * argv[])		
{
  int max;
  max = atoi(argv[1]);

  struct uproc * table; 
  table =  (struct uproc *)  malloc(max * sizeof(struct uproc));	
  int get = getprocs(max, table); 
  if(get == -1)
    printf(1, "Error\n");
  
  if(get>-1)
  { 
    int i;
    printf(1, HEADER);
    for(i = 0; i < get; ++i)
    {
      printf(1, "%d\t%s\t\t%d\t%d\t%d\t", table[i].pid, table[i].name, table[i].uid, table[i].gid, table[i].ppid);
#ifdef CS333_P4
      printf(1, "%d\t", table[i].priority);
#endif //CS333_P4
      printf(1, "%d.%d%d%d\t", table[i].elapsed_ticks/1000, table[i].elapsed_ticks%1000/100, table[i].elapsed_ticks%100/10, table[i].elapsed_ticks%10);
      printf(1, "0.0%d\t", table[i].CPU_total_ticks);
      printf(1, "%s\t%d\n", table[i].state, table[i].size);
    }
    printf(1, "\n");
  }

  free(table);
  exit();
}
#endif //CS333_P2
