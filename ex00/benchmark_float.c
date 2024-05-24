#include <stdio.h>
#include <math.h>
#include "timing.h"

int main(){
  int SLICES = 10000000;
  float sum=0., delta_x = 1.0/SLICES;
  double wcTime,wcTimeStart,wcTimeEnd;
  wcTimeStart = getTimeStamp();

  for (int i=0; i < SLICES; ++i) {
    float x = (i+0.5f)*delta_x;
    sum += 4.0f * sqrtf(1.0f - x * x);
  }

  wcTimeEnd = getTimeStamp();
  wcTime = wcTimeEnd-wcTimeStart;
  
  float Pi = sum * delta_x;
  printf("Walltime: %f s\n",wcTime);
  printf("value of PI %.31f \n",Pi);
  return 0;
}
