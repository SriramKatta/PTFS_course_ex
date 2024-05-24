// daxpy
#include <stdio.h>
#include <stdlib.h>
#include "timing.h"

int main(int argc, char **argv)
{

  double wct_start, wct_end;
  int id, nt, k, i;
  int NITER, N;
  double t = 0;

  if (argc != 2)
  {
    printf("Usage: %s <size>\n", argv[0]);
    exit(1);
  }
  N = atoi(argv[1]);

  double *a = (double *)malloc(N * sizeof(double));
  double *b = (double *)malloc(N * sizeof(double));

  for (k = 0; k < N; ++k)
  {
#ifdef RAND
    a[k] = 0.0 ;
    b[k] = 0.0 ;
#else
    a[k] = (double)RAND_MAX/rand();
    b[k] = (double)RAND_MAX/rand();
#endif
  }

  const double s = 1.00000000001;

  NITER = 1;
  do
  {
    // time measurement
    wct_start = getTimeStamp();

    // repeat measurement often enough
    for (k = 0; k < NITER; ++k)
    {
      // This is the benchmark loop
      for (i = 0; i < N; ++i)
      {
        a[i] = s * b[i] + a[i];
      }
      // end of benchmark loop
      if (a[N / 2] < 0.)
        printf("%lf", a[N / 2]);
    }
    wct_end = getTimeStamp();
    NITER = NITER * 2;
  } while (wct_end - wct_start < 0.1); // at least 100 ms

  NITER = NITER / 2;

  double megaflopspersec = (2.0 * N * NITER) / ((wct_end - wct_start) * 1000000);

  // Adapt this to print any other interesting metrics, e.g., performance
  printf("%d %f\n", N, megaflopspersec);
  free(a);
  free(b);

  return 0;
}
