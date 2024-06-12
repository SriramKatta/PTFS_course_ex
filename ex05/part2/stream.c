// stream
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
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
  double *d = (double *)malloc(N * sizeof(double));

  #pragma omp parallel for
  for (k = 0; k < N; ++k)
  {
    a[k] = 0.0;
    b[k] = (double)RAND_MAX/rand();
    d[k] = (double)RAND_MAX/rand();
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
      #pragma omp parallel for
      for (i = 0; i < N; ++i)
      {
        a[i] = b[i] + s * d[i];
      }
      // end of benchmark loop
      if (a[N / 2] < 0.)
        printf("%lf", a[N / 2]);
    }
    wct_end = getTimeStamp();
    NITER = NITER * 2;
  } while (wct_end - wct_start < 0.2); // at least 200 ms

  NITER = NITER / 2;

  double Gflopspersec = (2.0 * N * NITER) / ((wct_end - wct_start) * 1000000000);

  // Adapt this to print any other interesting metrics, e.g., performance
  printf("%d %f\n", N, Gflopspersec);
  free(a);
  free(b);
  free(d);

  return 0;
}
