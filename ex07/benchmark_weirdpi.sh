#!/bin/bash -l
#SBATCH --nodes=1 -C hwperf
#SBATCH -p singlenode
#SBATCH --time=00:30:00
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=bmweirdpicalc
#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

module load intel
module load likwid

[ ! -d "exe" ] && mkdir -p exe
[ ! -d "simdata/picalc" ] && mkdir -p simdata/picalc

for varstate in privateactive privatedeactive
do
  make picalc extraflag=-D$varstate
  for version in a b
  do
    for threads in {1..4}
    do
      fname=./simdata/picalc/sim_${version}_${threads}_${varstate}
      echo -n >  $fname
      echo "version ${version} num threads ${threads}"
      for intrun in {1..10}
      do
        srun --cpu-freq=2000000-2000000 likwid-pin -q -C S0:0-$(($threads - 1)) ./exe/picalc$version | tail -n 1 >> $fname
      done
    done
  done
done
