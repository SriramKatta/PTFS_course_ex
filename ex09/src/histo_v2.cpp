#include <iostream>
#include <chrono>
#include <omp.h>
#include <numeric>

#define N 2e9

#define maxcores 18
#define bins 16

using Time = std::chrono::high_resolution_clock;
using mintime = std::nano;

int main(int argc, char const *argv[])
{
  unsigned int seed = 1;
  long hist_temp[maxcores][bins] = {0};
  long hist[bins] = {0};
  int numthreads = 0;
  // bogus parallel region
#pragma omp parallel
  {
    numthreads = omp_get_num_threads();
    if (numthreads == 0)
    {
      printf("hello");
    }
  }

  int tid = 0;
  auto start = Time::now();
  #pragma omp parallel for 
  for (long iter = 0; iter < N; ++iter)
  {
    hist_temp[omp_get_thread_num()][rand_r(&seed) & 0xf]++;
  }
  auto end = Time::now();

  for (int bin = 0; bin < bins; ++bin)
  {
    for (int core = 0; core < maxcores; ++core)
    {
      hist[bin] += hist_temp[core][bin];
    }
  }

// check for proper parallelization
  if (std::accumulate(hist, hist + bins, 0) != N)
  {
    std::cout << "your program failed" << std::endl;
    std::exit(1);
  }

  for (int bin = 0; bin < 16; ++bin)
  {
    std::cout << "hist[" << bin << "]=" << hist[bin] << std::endl;
  }

  double calctimesec = std::chrono::duration<double, mintime>(end - start).count() / mintime::den;

  std::cout << numthreads << " " << static_cast<double>(N) / calctimesec << std::endl;

  return 0;
}
