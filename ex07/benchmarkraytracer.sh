#!/bin/bash -l
#SBATCH --nodes=1 -C hwperf
#SBATCH -p singlenode
#SBATCH --time=00:30:00
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=bmraytracer
#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

module load intel
module load likwid

make raytracer

fname=./simdata/raytra


echo "#threads time" > $fname
seqtime=$(srun --cpu-freq=2400000-2400000 ./exe/raytracer_seq 15000 5000 2>&1 | awk '{print $2}') 

for threads in 72 64 32 16 8 4 2 1
do
  time=$(srun --cpu-freq=2400000-2400000 likwid-pin -q -C S0:0-$(($threads - 1)) ./exe/raytracer_par 15000 5000 2>&1 | awk '{print $2}') 
  speedup=$(echo "$seqtime/$time" | bc -l)
  echo "$threads $time $speedup" >> $fname
done
    
