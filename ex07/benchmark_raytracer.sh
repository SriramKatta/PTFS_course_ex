#!/bin/bash -l
#SBATCH --nodes=1 -C hwperf
#SBATCH -p singlenode
#SBATCH --time=00:55:00
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=bmraytracer
#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

module load intel
module load likwid

imagesize=15000
tilesize=100

[ ! -d "exe" ] && mkdir -p exe
[ ! -d "simdata" ] && mkdir -p simdata

make raytracer
#echo "----------------------------------"
#echo "seq"
#echo "----------------------------------"
#seqtime=$(srun --cpu-freq=2400000-2400000 ./exe/raytracer_seq $imagesize $tilesize 2>&1 | tail -n 1 | awk '{print $2}') 

for ompmode in dynamic static
do
  fname=./simdata/raytra_$ompmode
  echo "#threads performnce(MPX/s)" > $fname
  echo "----------------------------------"
  echo $ompmode
  echo "----------------------------------"
  for threads in 1 {2..72..2}
  do
    paratime=$(OMP_SCHEDULE=$ompmode srun --cpu-freq=2400000-2400000 likwid-pin -q -C 0-$(($threads - 1)) ./exe/raytracer_par $imagesize $tilesize 2>&1 | tail -n 1 | awk '{print $2}') 
    performance=$(echo "$imagesize ^ 2 / ($paratime * 10^6)" | bc -l)
    echo "$threads $performance " >> $fname
    echo "$threads of 72 perform : $performance"
  done
done

gnuplot 6plot.sh

    
