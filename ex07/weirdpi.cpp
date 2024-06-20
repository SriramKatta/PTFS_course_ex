#include<iostream>
#include<cstdlib>
#include<chrono>
#include<cmath>
#include<omp.h>

#define N 1000000000

using Time = std::chrono::high_resolution_clock;
using mintime = std::nano;

int main(int argc, char const *argv[])
{

  double x{0.0}, sum{0.0}, delta_x{1.0/N};
  // bogus parallel region
  #pragma omp parallel
  if(omp_get_thread_num()==0) printf("Hello");

  auto start = Time::now();
  #pragma omp parallel for reduction(+:sum) private(x)
  for(int i=0; i<N; i++) {
     x = (i + 0.5) * delta_x;
     sum = sum + 4.0 * std::sqrt(1.0 - x * x);
  }
  auto end = Time::now();

  double picalctimesec = std::chrono::duration<double, mintime>(end - start).count() / mintime::den ;
  
  return 0;
}
