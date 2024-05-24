// vector update benchmark
#include <stdio.h>
#include <stdlib.h>
#include "timing.h"

int main(int argc, char **argv)
{

  double wct_start, wct_end;
  unsigned int k, i, NITER;
  unsigned int stride;
  const unsigned int N = 1e8;
  const unsigned int limit = 1e6;

  if (argc != 2)
  {
    printf("Usage: %s <stride>\n", argv[0]);
    exit(1);
  }
  stride = atol(argv[1]);

  if (stride >= limit)
  {
    return 0;
  }

  double *a = (double *)malloc(N * sizeof(double));

  for (k = 0; k < N; ++k)
  {
    a[k] = (double)RAND_MAX/rand();
  }

  const double s = (double)RAND_MAX/rand();

  NITER = 1;
  do
  {
    // time measurement
    wct_start = getTimeStamp();

    for (k = 0; k < NITER; ++k)
    {

      // This is the benchmark loop
      for (i = 0; i < N; i += stride)
      {
        a[i] = s * a[i];
      }
      // end of benchmark loop
      if (a[N / 2] < 0.)
        printf("%lf", a[N / 2]); // prevent compiler from eliminating loop
    }
    wct_end = getTimeStamp();
    NITER = NITER * 2;
  } while (wct_end - wct_start < 0.1);
  NITER = NITER / 2;

  double updatespersec = (( N / stride ) * NITER ) / ((wct_end - wct_start) * 1000000);
  
  printf("%u %lf\n", stride, updatespersec);
  
  free(a);

  return 0;
}
