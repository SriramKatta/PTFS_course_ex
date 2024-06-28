#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <chrono>
#include <cmath>
#include <omp.h>
#ifdef LIKWID_PERFMON
#include <likwid-marker.h>
#else
#define LIKWID_MARKER_INIT
#define LIKWID_MARKER_THREADINIT
#define LIKWID_MARKER_SWITCH
#define LIKWID_MARKER_REGISTER(regionTag)
#define LIKWID_MARKER_START(regionTag)
#define LIKWID_MARKER_STOP(regionTag)
#define LIKWID_MARKER_CLOSE
#define LIKWID_MARKER_GET(regionTag, nevents, events, time, count)
#endif

#define N 2e9

using Time = std::chrono::high_resolution_clock;
using mintime = std::nano;

int main(int argc, char const *argv[])
{

  double x{0.0}, sum{0.0}, delta_x{1.0 / N};
  // bogus parallel region
  LIKWID_MARKER_INIT;
#pragma omp parallel
  {
    LIKWID_MARKER_REGISTER("COMPUTE");
  }

  auto start = Time::now();
#pragma omp parallel
  {
    LIKWID_MARKER_START("COMPUTE");
#pragma omp for reduction(+ : sum) private(x)
    for (int i = 0; i < N; i++)
    {
      x = (i + 0.5) * delta_x;
      sum = sum + 4.0 * std::sqrt(1.0 - x * x);
    }
    LIKWID_MARKER_STOP("COMPUTE");
  }
  LIKWID_MARKER_CLOSE;
  auto end = Time::now();
  sum /= N;
  double picalctimesec = std::chrono::duration<double, mintime>(end - start).count() / mintime::den;
  double gflopspersec = (N * 7.0) / (picalctimesec * std::giga::num); // assuming sqrt as 1 flop

  std::cout << std::setprecision(15) << "performance : " << gflopspersec << std::endl;

  return 0;
}
