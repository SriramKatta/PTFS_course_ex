#include<iostream>
#include<iomanip>
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
    if(omp_get_num_threads()==0) 
      printf("Hello");


  auto start = Time::now();
#if privateactive
  std::cout << "private activated" << std::endl;
  #pragma omp parallel for reduction(+:sum) private(x)
#endif
#if privatedeactive
  std::cout << "private deactivated" << std::endl;
  #pragma omp parallel for reduction(+:sum) private(x)
#endif
  for(int i=0; i<N; i++) {
     x = (i + 0.5) * delta_x;
     sum = sum + 4.0 * std::sqrt(1.0 - x * x);
  }

  auto end = Time::now();
  sum /= N;
  double picalctimesec = std::chrono::duration<double, mintime>(end - start).count() / mintime::den ;
  double gflopspersec = (N * 2) / (picalctimesec * std::giga::num);

  std::cout << std::setprecision(15) << sum << " " << gflopspersec << std::endl;
  
  return 0;
}
