#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --gres=gpu:a100:1
#SBATCH --partition=a100 -C a100_40
#SBATCH --time=00:30:00
#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

module load cuda
module load nvhpc

rm -rf exe
rm -rf simdata

mkdir exe
mkdir simdata

make


echo "--------------------------------------------------------------"
echo  "varying thread size simulation start":
echo "--------------------------------------------------------------"

for start in 1 8 16 24 32
do
  echo "#threads kernelbandwidth(GB/s)" > ./simdata/kernelBW_threadvar$start-dat
  for((i=$start; i <= 1024; i+=32))
  do
    echo "$i of 1024  start"
    tottime=$(srun ./exe/benchmark 32000000 16 864 $i)
    kernelbandwidth=$(echo $tottime | awk '{print $2}')
    echo "$i $kernelbandwidth" >> ./simdata/kernelBW_threadvar$start-dat
  done
done

gnuplot 6bgpuplot.sh

echo "--------------------------------------------------------------"
echo  "varying thread size simulation end":
echo "--------------------------------------------------------------"


echo "#Numelements kernelbandwidth(GB/s)" > ./simdata/kernelBW_sizevar-dat
echo "#Numelements HtoDbandwidth(GB/s)" > ./simdata/htodBW_sizevar-dat

echo "--------------------------------------------------------------"
echo  "varying problem size simulation start":
echo "--------------------------------------------------------------"


val12pow=116
for((i=0; i <= $val12pow; i+=4))
do
  echo "$i of $val12pow start"
  numelem=$(echo "12^$i/10^$i" | bc)
  tottime=$(srun ./exe/benchmark $numelem 24 3456 256)
  
  kernelbandwidth=$(echo $tottime | awk '{print $2}')
  echo "$numelem $kernelbandwidth" >> ./simdata/kernelBW_sizevar-dat
  HDbandwidth=$(echo $tottime | awk '{print $6}')
  echo "$numelem $HDbandwidth" >> ./simdata/htodBW_sizevar-dat

done

echo "--------------------------------------------------------------"
echo  "varying problem size simulation end":
echo "--------------------------------------------------------------"


gnuplot 6cgpuplot.sh
