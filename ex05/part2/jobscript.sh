#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH -p singlenode
#SBATCH --time=02:30:00
#SBATCH --job-name=ompbasics
#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

module load intel
module load likwid

#seqcode 
icx -xHost -fno-alias -c stream.c timing.c timing.h
icx -xHost -o streamseq stream.o timing.o
rm *.o

echo "--------------------------------------------------------------"
echo  "scan_c_omp_seq":
echo "--------------------------------------------------------------"
echo "#N MFLOPS/s" > ./simseq-dat
for i in {0..89};
do
  elems=$(echo 10*1.2^$i | bc)
  srun --cpu-freq=2000000-2000000 ./streamseq $elems >> ./simseq-dat
  echo "$i of 89 elements are done"
done
echo >> ./simseq-dat
#seqcode end


make
make clean

for threads in 1 2 4 8 12 16 18
do
  echo "--------------------------------------------------------------"
  echo  "scan_c_omp_$threads":
  echo "--------------------------------------------------------------"
  echo "#N MFLOPS/s" > ./sim$threads-dat
  for i in {0..89};
  do
    elems=$(echo 10*1.2^$i | bc)
    srun --cpu-freq=2000000-2000000 likwid-pin -q -C S0:0-$(($threads - 1)) ./stream $elems >> ./sim$threads-dat
    echo "$i of 89 elements are done"
  done
  echo >> ./sim$threads-dat
done


gnuplot plotjob.sh
