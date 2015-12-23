
#include "main.h"


int main(void)
{
  volatile int i  = 12;
  volatile float f = 1.2;
  volatile float r = 0;

  while (1)
  {
    i++;
    r = (float)i / f;

  }

}

