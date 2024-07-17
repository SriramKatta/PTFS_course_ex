#!/bin/bash -l
#SBATCH --nodes=1 
#SBATCH --partition spr1tb
#SBATCH --time=06:00:00
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=bmccnuma
#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

module load likwid

[ ! -d "simdata" ] && mkdir -p simdata

for version in "" "_avx" "_avx" "_avx_fma" "_avx512" "_avx512_fma"
do
  fname="./simdata/daxpy$version.csv"
  echo "mem\cpu,0,1,2,3,4,5,6,7" > $fname
  for memnode in {0..7} 
  do
    echo -n $memnode, >> $fname
    for cpunode in {0..7} 
    do 
      echo "version=$version, memnode=$memnode, cpunode=$cpunode"
      bandwidth=$(srun --cpu-freq=2000000-2000000 \
      numactl --membind $memnode \
      likwid-pin -c M${cpunode}:0-11 \
      likwid-bench -t daxpy_avx -w N:10MB:12 2>&1 | \
      grep MByte/s | awk '{print $2}') ;
      bandwidth=$(echo "scale=2; $bandwidth/1024" | bc -l)
      echo -n $bandwidth, >> $fname
    done
    echo >> $fname
  done
done