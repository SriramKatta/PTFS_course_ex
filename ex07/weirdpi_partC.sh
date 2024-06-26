#!/bin/bash -l
#SBATCH --nodes=1 -C hwperf
#SBATCH -p singlenode
#SBATCH --time=00:05:00
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=bmweirdpicalc_C
#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

module load intel
module load likwid


[ ! -d "simdata" ] && mkdir -p simdata

icx -O1 -no-vec -qopenmp ./picalc/refrenceWeirdPI.c
srun --cpu-freq=2000000-2000000 likwid-perfctr -g DATA -C 0 ./a.out > ./simdata/novec_ver
icx -O3 -xAVX -qopenmp ./picalc/refrenceWeirdPI.c
srun --cpu-freq=2000000-2000000 likwid-perfctr -g DATA -C 0 ./a.out > ./simdata/vec_ver
rm a.out
