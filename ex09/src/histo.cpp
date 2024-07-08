#include <iostream>
#include <chrono>
#include <omp.h>
#include <numeric>

#define N 2e9

using Time = std::chrono::high_resolution_clock;
using mintime = std::nano;

int main(int argc, char const *argv[])
{
  unsigned int seed = 1;
  long hist[16];
  // bogus parallel region
  int numthreads = 0;
#pragma omp parallel
  {
    numthreads = omp_get_num_threads();
#pragma omp for
    for (int i = 0; i < 16; ++i)
      hist[i] = 0;
  }

  auto start = Time::now();
#if atomicupdate
#pragma omp parallel for
#else
#pragma omp parallel for reduction(+ : hist)
#endif
  for (long i = 0; i < N; ++i)
  {
#if atomicupdate
#pragma omp atomic
#endif
    ++hist[rand_r(&seed) & 0xf];
  }
  auto end = Time::now();
  if (std::accumulate(hist, hist + 16, 0) != N)
  {
    std::cout << "your program failed" << std::endl;
    std::exit(1);
  }
  for (int i = 0; i < 16; ++i)
  {
    std::cout << "hist[" << i << "]=" << hist[i] << std::endl;
  }
  double calctimesec = std::chrono::duration<double, mintime>(end - start).count() / mintime::den;

  std::cout << numthreads << " " << static_cast<double>(N) / calctimesec << std::endl;

  return 0;
}
