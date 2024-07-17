#!/bin/bash -l
#SBATCH --nodes=1 
#SBATCH --partition singlenode
#SBATCH --time=06:00:00
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=bmomptask
#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

module load intel
module load likwid


[ ! -d "simdata" ] && mkdir -p simdata
[ ! -d "exe" ] && mkdir -p exe

make clean
make

for version in "" "_task"
do
  fname="./simdata/ompparallel$version"
  echo "#tilesize performance" > $fname
  for tilesize in 1 2 3 4 5 6 8 10 12 15 20 24 25 30 40 50 60 75 100 120 125 150 200 250 300 375 500 600 625 750 1000 1250 1500 1875 2500 3000
  do
    echo "Running with tilesize $tilesize and version $version"
    perfval=$(srun --cpu-freq=2000000-2000000  \
              likwid-pin -q -c S0:0-35 \
              ./exe/raytrace$version 15000 $tilesize 2>&1 | tail -n 1 | awk '{print $(NF-1)}')
    echo $tilesize $perfval >> $fname
  done
done

gnuplot plotjob.sh

