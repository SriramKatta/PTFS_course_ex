#include <stdio.h>
#include <omp.h>
#include "timing.h"
#include <tgmath.h>

#define N 1
#define BINS 16

int main()
{
  unsigned int seed = 1;
  long hist[BINS];

  // bogus parallel region
  int threadscount = 0;
#pragma omp parallel
  {
#if _OPENMP
    threadscount = omp_get_num_threads();
#endif
#pragma omp for
    for (int i = 0; i < BINS; ++i)
      hist[i] = 0;
  }

  long NITER = 1;
  double start, end;

  do
  {
    start = getTimeStamp();
    for (int k = 0; k < NITER; k++)
    {
#pragma omp parallel for private(seed) reduction(+ : hist)
      for (int j = 0; j < N; ++j)
      {
        hist[rand_r(&seed) & 0xf]++;
      }
    }
    end = getTimeStamp();
    NITER *= 2;
  } while (end - start < 0.2);
  NITER /= 2;

  double calctimesecpara = (end - start) / NITER;

  // reset bins
  for (size_t i = 0; i < BINS; i++)
  {
    hist[i] = 0;
  }

  NITER = 1;
  do
  {
    start = getTimeStamp();
    for (int k = 0; k < NITER; k++)
    {
      for (int j = 0; j < N; ++j)
      {
        hist[rand_r(&seed) & 0xf]++;
      }
    }
    end = getTimeStamp();
    NITER *= 2;
  } while (end - start < 0.2);
  NITER /= 2;
  
  double calctimesecseq = (end - start) / NITER;

  printf("threadcount : %d\n", threadscount);
  printf("parallel calc time : %lf\n", calctimesecpara);
  printf("sequential calctime : %lf\n", calctimesecseq);
  printf("parallel overhead in cycles: %lf\n", 2e6 * fabs(calctimesecseq - calctimesecpara));

  return 0;
}
