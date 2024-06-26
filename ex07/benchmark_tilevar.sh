#!/bin/bash -l
#SBATCH --nodes=1 -C hwperf
#SBATCH -p singlenode
#SBATCH --time=00:45:00
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=bmraytracer_tilevar
#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

module load intel
module load likwid

imagesize=15000

[ ! -d "exe" ] && mkdir -p exe
[ ! -d "simdata" ] && mkdir -p simdata

make raytracer

for ompmode in dynamic static 
do
  fname=./simdata/raytra_tilesizevar_$ompmode
  echo "#tilesize performnce(MPX/s)" > $fname
  echo "----------------------------------"
  echo $ompmode
  echo "----------------------------------"
  for tilesize in 1 2 3 4 5 6 8 10 12 15 20 24 25 30 40 50 60 75 100 120 125 150 200 250 300 375 500 600 625 750 1000
  do
    paratime=$(OMP_SCHEDULE=$ompmode OMP_NUM_THREADS=72 OMP_PLACES=cores OMP_PROC_BIND=close srun --cpu-freq=2400000-2400000 ./exe/raytracer_par $imagesize $tilesize 2>&1 | tail -n 1 | awk '{print $2}' ) 
    performance=$(echo "$imagesize ^ 2 / ($paratime * 10^6)" | bc -l)
    echo "$tilesize $performance " >> $fname
    echo "$tilesize of 1000 : performance = $performance"
  done
done

gnuplot tilesizeplot.sh

