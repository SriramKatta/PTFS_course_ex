// vector update benchmark
#include <stdio.h>
#include <stdlib.h>
#include "timing.h"

int main(int argc, char **argv)
{

  double wct_start, wct_end;
  unsigned int k, i;
  unsigned int stride;
  const unsigned int N = 1e8;
  
  if (argc != 2)
  {
    printf("Usage: %s <stride>\n", argv[0]);
    exit(1);
  }
  stride = atoi(argv[1]);

  double *a = (double *)malloc(N * sizeof(double));

  for (k = 0; k < N; ++k)
  {
    a[k] = 0.0;
  }

  const double s = 1.00000000001;

  // time measurement
  wct_start = getTimeStamp();

  // This is the benchmark loop
  for (i = 0; i < N; i+=stride)
  {
    a[i] = s * a[i];
  }
  // end of benchmark loop
  wct_end = getTimeStamp();

  //added to prevent eleimination of the loop
  if (a[N / 2] < 0.)
    printf("%lf", a[N / 2]);

  //double megaflopspersec = (2.0 * N ) / ((wct_end - wct_start) * 1000000);

  printf("%d %lf\n", N, wct_end - wct_start);
  free(a);

  return 0;
}
