#!/bin/bash -l
#SBATCH --nodes=1 --time=00:30:00
#SBATCH --job-name=TEST01
#SBATCH --export=NONE
unset SLURM_EXPORT_ENV

module load intel
cc=icx
ite=1
echo > res.txt
for cflags in "-O1 -fno-vectorize" "-O3 -xSSE4.2" "-O3 -xCORE-AVX2" "-O3 -xCORE-AVX512 -qopt-zmm-usage=high"
do 
  $cc $cflags -c benchmark_double.c timing.h
  $cc $cflags -c timing.c timing.h
  $cc $cflags -o benchmark$ite timing.o benchmark_double.o
  echo $cflags >> res.txt
  srun --cpu-freq=2400000-2400000 ./benchmark$ite >> res.txt
  echo >> res.txt
  ite+=1
  rm -r *.o* *.gch
done
