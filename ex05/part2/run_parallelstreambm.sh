#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH -p singlenode
#SBATCH --time=02:30:00
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=ompbasics2
#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

module load intel
module load likwid

mkdir exe
mkdir simdata

#seqcode 
icx -O3 -xHost -fno-alias -c stream.c timing.c timing.h
icx -O3 -xHost -o streamseq stream.o timing.o
mv streamseq exe/
make clean

echo "--------------------------------------------------------------"
echo  "scan_c_omp_seq":
echo "--------------------------------------------------------------"
echo "#N MFLOPS/s" > ./simdata/simseq-dat
for i in {0..89};
do
  elems=$(echo 10*1.2^$i | bc)
  srun --cpu-freq=2000000-2000000 ./exe/streamseq $elems >> ./simdata/simseq-dat
  echo "$i of 89 elements are done"
done
echo >> ./simseq-dat
#seqcode end

make
mv stream exe/
make clean

for threads in 1 2 4 8 12 16 18
do
  echo "--------------------------------------------------------------"
  echo  "scan_c_omp_$threads":
  echo "--------------------------------------------------------------"
  echo "#N MFLOPS/s" > ./simdata/sim$threads-dat
  for i in {0..89};
  do
    elems=$(echo 10*1.2^$i | bc)
    srun --cpu-freq=2000000-2000000 likwid-pin -q -C S0:0-$(($threads - 1)) ./exe/stream $elems >> ./simdata/sim$threads-dat
    echo "$i of 89 elements are done"
  done
  echo >> ./simdata/sim$threads-dat
done


gnuplot plotjob.sh


echo "#numcores gflops/sec" > ./simscaling-dat
for numcores in {0..17}
do 
  elems=$(echo 10^8 | bc)
  gflops=$(srun --cpu-freq=2000000-2000000 likwid-pin -q -C N:0-$numcores ./exe/stream $elems | awk '{print $NF}')
  echo "$numcores $gflops">> ./simdata/simscaling-dat
  echo "$numcores of 17 done"
done
echo  >> ./simdata/simscaling-dat

gnuplot plotjob2.sh