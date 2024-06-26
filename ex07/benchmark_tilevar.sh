#!/bin/bash -l
#SBATCH --nodes=1
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

for ompmode in dynamic auto static 
do
  fname=./simdata/raytra_tilesizevar_$ompmode
  echo "#tilesize performnce(MPX/s)" > $fname
  echo "----------------------------------"
  echo $ompmode
  echo "----------------------------------"
  for ((tilesize=10; tilesize <= 5000; tilesize+=1))
  do
    if [ $(echo "$imagesize % $tilesize == 0" | bc) -eq 1 ]
    then
      paratime=$(OMP_SCHEDULE=$ompmode srun --cpu-freq=2400000-2400000 likwid-pin -q -C 0-71 ./exe/raytracer_par $imagesize $tilesize 2>&1 | tail -n 1 | awk '{print $2}') 
      performance=$(echo "$imagesize ^ 2 / ($paratime * 10^6)" | bc -l)
      echo "$tilesize $performance " >> $fname
      echo "$tilesize of 5000 : performance = $performance"
    fi
  done
done

gnuplot tilesizeplot.sh

    
