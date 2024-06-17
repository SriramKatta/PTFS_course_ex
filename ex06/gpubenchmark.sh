#!/bin/bash -l
#
#SBATCH --nodes=1
#SBATCH --gres=gpu:a100:1
#SBATCH --partition=a100 -C a100_40
#SBATCH --time=00:30:00
#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

module load cuda

rm -rf exe
rm -rf simdata

mkdir exe
mkdir simdata

make

#echo "#threads kerneltime(sec)" > ./simdata/kernaltime_threadvar-dat
#echo "#threads HtoDtime(sec)" > ./simdata/htodtime_threadvar-dat
#echo "#threads DtoHtime(sec)" > ./simdata/dtohtime_threadvar-dat
#echo "#threads HtoDbandwidth(GB/s)" > ./simdata/htodBW_threadvar-dat
#echo "#threads DtoHbandwidth(GB/s)" > ./simdata/dtohBW_threadvar-dat

echo "#threads kernelbandwidth(GB/s)" > ./simdata/kernelBW_threadvar-dat

echo "--------------------------------------------------------------"
echo  "varying thread size simulation start":
echo "--------------------------------------------------------------"

MAX=1024
for((i=1; i <= $MAX; i+=1))
do
  echo "$i of $MAX  start"
  
  tottime=$(srun ./exe/benchmark 32000000 16 864 $i)
  
  #kerneltime=$(echo $tottime | awk '{print $1}')
  #DHtime=$(echo $tottime | awk '{print $3}')
  #HDtime=$(echo $tottime | awk '{print $5}')
  #echo "$i $kerneltime" >> ./simdata/kernaltime_threadvar-dat
  #echo "$i $DHtime" >> ./simdata/dtohtime_threadvar-dat
  #echo "$i $HDtime" >> ./simdata/htodtime_threadvar-dat

  
  kernelbandwidth=$(echo $tottime | awk '{print $2}')
  echo "$i $kernelbandwidth" >> ./simdata/kernelBW_threadvar-dat
  #DHbandwidth=$(echo $tottime | awk '{print $4}')
  #HDbandwidth=$(echo $tottime | awk '{print $6}')
  #echo "$i $DHbandwidth" >> ./simdata/dtohBW_threadvar-dat
  #echo "$i $HDbandwidth" >> ./simdata/htodBW_threadvar-dat

done

echo "--------------------------------------------------------------"
echo  "varying thread size simulation end":
echo "--------------------------------------------------------------"


#echo "#Numelements kerneltime(sec)" > ./simdata/kernaltime_sizevar-dat
#echo "#Numelements HtoDtime(sec)" > ./simdata/htodtime_sizevar-dat
#echo "#Numelements DtoHtime(sec)" > ./simdata/dtohtime_sizevar-dat
#echo "#Numelements DtoHbandwidth(GB/s)" > ./simdata/dtohBW_sizevar-dat
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

  #kerneltime=$(echo $tottime | awk '{print $1}')
  #DHtime=$(echo $tottime | awk '{print $3}')
  #HDtime=$(echo $tottime | awk '{print $5}')
  #echo "$numelem $kerneltime" >> ./simdata/kernaltime_sizevar-dat
  #echo "$numelem $DHtime" >> ./simdata/dtohtime_sizevar-dat
  #echo "$numelem $HDtime" >> ./simdata/htodtime_sizevar-dat

  
  kernelbandwidth=$(echo $tottime | awk '{print $2}')
  echo "$numelem $kernelbandwidth" >> ./simdata/kernalBW_sizevar-dat
  HDbandwidth=$(echo $tottime | awk '{print $6}')
  echo "$numelem $HDbandwidth" >> ./simdata/htodBW_sizevar-dat
  #DHbandwidth=$(echo $tottime | awk '{print $4}')
  #echo "$numelem $DHbandwidth" >> ./simdata/dtohBW_sizevar-dat

done

echo "--------------------------------------------------------------"
echo  "varying problem size simulation end":
echo "--------------------------------------------------------------"


#gnuplot 6bgpuplot.sh
#gnuplot 6cgpuplot.sh
