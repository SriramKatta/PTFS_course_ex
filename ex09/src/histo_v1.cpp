#include <iostream>
#include <chrono>
#include <omp.h>
#include <numeric>

#define N 2e7

using Time = std::chrono::high_resolution_clock;

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

  auto start = Time::now();
#pragma omp parallel for private(seed)
  for (long i = 0; i < N; ++i)
  {
#pragma omp atomic
    hist[rand_r(&seed) & 0xf]++;
  }
  auto end = Time::now();

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
  double calctimesec = std::chrono::duration<double>(end - start).count();
  double milloniterpersec = static_cast<double>(N) / (calctimesec * 1e6);
  std::cout << numthreads << " " << milloniterpersec << std::endl;

  return 0;
}
