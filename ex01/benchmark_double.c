#include <stdio.h>
#include <math.h>
#include "timing.h"

int main(){
  double freq = 2.4e9;
  int SLICES = 1000000000;
  double sum=0.0, delta_x = 1.0/SLICES;
  double wcTime,wcTimeStart,wcTimeEnd;
  wcTimeStart = getTimeStamp();

  for (int i=0; i < SLICES; ++i) {
    double x = (i+.5)*delta_x;
    sum += 4.0 * sqrt(1.0 - x * x);
  }
  wcTimeEnd = getTimeStamp();
  wcTime = wcTimeEnd-wcTimeStart;
  
  double Pi = sum * delta_x;
  printf("Walltime: %f s\n",wcTime);
  printf("value of PI %.15f \n",Pi);
  return 0;
}
