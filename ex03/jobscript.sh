#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --time=00:30:00
#SBATCH --job-name=loopbenchmark
#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

module load intel

make

echo "#stride updatedpersec\n" > ./stride-dat

for i in 1 2 4 8
do 
  srun --cpu-freq=2400000-2400000 \
          ./vector_update_benchmark_exe \
          $i >> ./stride-dat

done

for i in {1..13};
do
  srun --cpu-freq=2400000-2400000 \
          ./vector_update_benchmark_exe \
          $(echo 8*1.2^$i | bc) >> ./stride-dat
done

make clean

#gnuplot -e "title_str='loop performance in MFlops/s ($STR)' \
#            ;opfname='plot_stream_daxpy_($STR).png'" \
#            plotjob.sh
