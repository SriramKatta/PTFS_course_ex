#include <stdio.h>
#include <omp.h>
#include "timing.h"

#define N 2e9
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

  double start = getTimeStamp();

#pragma omp parallel for private(seed) reduction(+ : hist) 
  for (int j = 0; j < N; ++j)
  {
    hist[rand_r(&seed) & 0xf]++;
  }

  double end = getTimeStamp();

  // check for proper parallelization
  long res = 0;
  for (int i = 0; i < BINS; ++i)
  {
    res += hist[i];
  }

  if (res != N)
  {
    printf("your program failed\n");
    return 1;
  }

  double calctimesec = end - start;
  double milloniterpersec = (double)(N) / (calctimesec * 1e6);
  printf("%d %lf\n", threadscount, milloniterpersec);

  return 0;
}
