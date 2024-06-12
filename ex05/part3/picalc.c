#include <stdio.h>
#include <math.h>
#include "timing.h"

int main(){
  long int SLICES = 2*1e9;
  double sum=0., delta_x = 1.0/SLICES;
  double wcTime,wcTimeStart,wcTimeEnd;
  wcTimeStart = getTimeStamp();

  #pragma omp parallel
  {
  }

  #pragma omp parallel for reduction(+:sum)
  for (int i=0; i < SLICES; ++i) {
    double x = (i+0.5)*delta_x;
    sum += 4.0 * sqrtf(1.0 - x * x);
  }

  wcTimeEnd = getTimeStamp();
  wcTime = wcTimeEnd-wcTimeStart;
  
  double Pi = sum * delta_x;
  printf("%f\n",wcTime);
  printf("value of PI %.31f \n",Pi);
  return 0;
}