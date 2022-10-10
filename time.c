//Natasha Needham
//CS333 Fall 2020
//Project 2
#include "types.h"
#include "user.h"
#include "date.h"

int
main (int argc, char *argv[])
{
  int start;
  start = uptime();

  int pid = fork();
  if (pid < 0) 
  {
    printf(2, "Error: Invalid PID\n");
    exit();
  }
  if (pid > 0)
    wait();
  if (pid == 0) 
  {
    if (exec(argv[1], argv + 1) < 0) 
    {
      exit();
    }
  }

  int end = uptime();

  int sec = (end - start)/1000;
  int milli = (end - start)%1000;
  
  printf(1, "%s", argv[1]);
  printf(1, " ran in %d.", sec);
  if (milli < 10)
    printf(1, "0");
  printf(1, "%d\n", milli);
  exit();
}
