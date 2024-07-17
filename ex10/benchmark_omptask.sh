#!/bin/bash -l
#SBATCH --nodes=1 
#SBATCH --partition spr1tb
#SBATCH --time=06:00:00
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=bmomptask
#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

module load intel
module load likwid


[ ! -d "simdata" ] && mkdir -p simdata
[ ! -d "exe" ] && mkdir -p exe

for version in "" "_task"
do
  fname="./simdata/ompparallel$version"
  echo "#tilesize performance" > $fname
  for i in {0..31}
  do
    tilesize=$(echo 'scale=0; 1.3^$i' | bc)
    perfval=$(srun --cpu-freq=2000000-2000000  \
              likwid-pin -q -c S0:0-35 \
              ./exe/raytrace$version 15000 $tilesize 2>&1 \
              | tail -n 1 | awk '{print $(NF-1)}')
    echo $tilesize $perfval >> $fname
  done
done

gnuplot plotjob.sh