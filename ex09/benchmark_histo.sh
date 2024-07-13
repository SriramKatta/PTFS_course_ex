#!/bin/bash -l
#SBATCH --nodes=1 
#SBATCH -p singlenode
#SBATCH --time=00:30:00
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=bmhisto
#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

module load intel
module load likwid

[ ! -d "exe" ] && mkdir -p exe
[ ! -d "simdata" ] && mkdir -p simdata

make

for ver in v2 v1
do 
  fname=./simdata/sim_$ver
  echo "#cores it/sec" > $fname
  for threads in {0..17}
  do 
    echo "$ver | $threads of 18 start"
    srun --cpu-freq=2000000-2000000 \
    likwid-pin -q -c M0:0-$threads \
    ./exe/histo_$ver | tail -n 1 >> $fname
    echo "$ver | $threads of 18 done"
  done
done

gnuplot plotjob.sh

srun --cpu-freq=2000000-2000000 likwid-pin -q -c M0:0-17 ./exe/histo_v2_barrier_estimate