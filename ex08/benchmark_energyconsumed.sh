#!/bin/bash -l
#SBATCH --nodes=1 -C hwperf
#SBATCH -p singlenode
#SBATCH --time=00:10:00
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=bmweirdpicalc
#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

module load intel
module load likwid

make

[ ! -d "exe" ] && mkdir -p exe
[ ! -d "simdata" ] && mkdir -p simdata

for frequency in 2400000 1600000
do
  fname=./simdata/tesfile_$frequency
  echo -n > $fname
  for threads in {1..36}
  do 
    srun --cpu-freq=${frequency}-${frequency} \
          likwid-perfctr --stats\
          -C N:0-$((threads - 1)) \
          -g ENERGY \
          -m ./exe/picalcexe \
          | grep -e "Energy \[J\] STAT" -e "performance"  \
          | tr '\n' ' ' \
          | awk '{printf "%s %s\n", $3, $9}' >> $fname
    echo "$frequency $threads done"
  done
done

gnuplot plotjob.sh