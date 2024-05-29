#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --time=00:30:00
#SBATCH --job-name=loopbenchmark
#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

module load intel

make

echo "#stride updatedpersec\n" > ./stride8_1_2pow-dat
echo "#stride updatedpersec\n" > ./stride2pow-dat

for ((i=0; i <= 20; i+=1));
do 
  echo "$(echo 2^$i | bc)"
  srun --cpu-freq=2400000-2400000 \
          ./vector_update_benchmark_exe \
          $(echo 2^$i | bc) >> ./stride2pow-dat

done

for ((i=0; i <= 70; i+=1));
do
  echo "$(echo 8*1.2^$i | bc)"
  srun --cpu-freq=2400000-2400000 \
          ./vector_update_benchmark_exe \
          $(echo 8*1.2^$i | bc) >> ./stride8_1_2pow-dat
done

make clean

gnuplot plotjob.sh
