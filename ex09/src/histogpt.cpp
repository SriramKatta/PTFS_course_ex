#include <iostream>
#include <omp.h>
#include <numeric>
#include <chrono>
#include <cstdlib>

#define N  2e7
long hist[16];

int main() {
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

  // Start timing
  auto start = std::chrono::high_resolution_clock::now();

  // Parallel region
  #pragma omp parallel
  {
    unsigned int seed = omp_get_thread_num();
    #pragma omp for
    for (long i = 0; i < N; ++i) {
      #pragma omp atomic
      hist[rand_r(&seed) & 0xf]++;
    }
  }

  // End timing
  auto end = std::chrono::high_resolution_clock::now();

  // Check for proper parallelization
  if (std::accumulate(hist, hist + 16, 0) != N) {
    std::cout << "your program failed" << std::endl;
    std::exit(1);
  }

  // Output results
  for (int i = 0; i < 16; ++i) {
    std::cout << "hist[" << i << "]=" << hist[i] << std::endl;
  }
  double calctimesec = std::chrono::duration<double>(end - start).count();
  double milloniterpersec = static_cast<double>(N) / (calctimesec * 1e6);
  std::cout << numthreads << " " << milloniterpersec << std::endl;

  return 0;
}