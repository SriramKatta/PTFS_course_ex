#include <stdio.h>
#include <omp.h>
#include <time.h>

#define N 2e9
#define MAX_THREADS 18
#define BINS 16

double getTimeStamp()
{
  struct timespec ts;
  clock_gettime(CLOCK_MONOTONIC, &ts);
  return (double)ts.tv_sec + (double)ts.tv_nsec * 1.e-9;
}

int main(int argc, char const *argv[])
{
  unsigned int seed = 1;
  long hist[MAX_THREADS][BINS];
  // bogus parallel region
  int numthreads = 0;
#pragma omp parallel
  {
    #if _OPENMP
    numthreads = omp_get_num_threads();
    #endif
#pragma omp for collapse(2)
    for (int thread = 0; thread < MAX_THREADS; ++thread)
    for (int i = 0; i < BINS; ++i)
      hist[thread][i] = 0;
  }

  double start = getTimeStamp();
#pragma omp parallel for private(seed)
  for (long i = 0; i < N; ++i)
  {
    hist[omp_get_thread_num()][rand_r(&seed) & 0xf]++;
  }
  double end = getTimeStamp();

//check for proper parallelization
  long res = 0;
  for (size_t threads = 0; threads < MAX_THREADS; threads++)
  for (size_t i = 0; i < BINS; i++)
  {
    res += hist[threads][i];
  }
  
  if (res != N)
  {
    printf("your program failed\n");
    return 1;
  }
  double calctimesec = end - start;
  double milloniterpersec = (double)(N) / (calctimesec * 1e6);
  printf("%d %f\n", numthreads, milloniterpersec);

  return 0;
}
