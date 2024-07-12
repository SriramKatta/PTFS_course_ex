#include <stdio.h>
#include <omp.h>
#include <numeric>
#include <time.h>

#define N 2e7

double getTimeStamp()
{
  struct timespec ts;
  clock_gettime(CLOCK_MONOTONIC, &ts);
  return (double)ts.tv_sec + (double)ts.tv_nsec * 1.e-9;
}

int main(int argc, char const *argv[])
{
  unsigned int seed = 1;
  long hist[16];
  // bogus parallel region
  int numthreads = 0;
#pragma omp parallel
  {
    #if _OPENMP
    numthreads = omp_get_num_threads();
    #endif
#pragma omp for
    for (int i = 0; i < 16; ++i)
      hist[i] = 0;
  }

  double start = getTimeStamp();
#pragma omp parallel for private(seed)
  for (long i = 0; i < N; ++i)
  {
#pragma omp atomic
    hist[rand_r(&seed) & 0xf]++;
  }
  double end = getTimeStamp();

  //check for proper parallelization
  if (std::accumulate(hist, hist + 16, 0) != N)
  {
    std::cout << "your program failed" << std::endl;
    std::exit(1);
  }
  for (int i = 0; i < 16; ++i)
  {
    std::cout << "hist[" << i << "]=" << hist[i] << std::endl;
  }
  double calctimesec = end - start;
  double milloniterpersec = static_cast<double>(N) / (calctimesec * 1e6);
  std::cout << numthreads << " " << milloniterpersec << std::endl;

  return 0;
}
