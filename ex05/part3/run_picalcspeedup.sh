#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH -p singlenode
#SBATCH --time=00:45:00
#SBATCH --job-name=picalcspeedup
#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

module load intel
module load likwid

mkdir exe
mkdir simdata

#seqential executeable generation
icx -O1 -no-vec picalc.c timing.c timing.h
rm *.o *.gch
mv a.out picalcseq
mv picalcseq exe/
seqtime=$(./picalcseq | head -n 1)
#seqential executeable generation end
fixfreqseqtime=$(srun --cpu-freq=2400000-2400000 ./exe/picalcseq | head -n 1) 
turbofreqseqtime=$(srun --cpu-freq=performance ./exe/picalcseq | head -n 1) 


#parallel executeable generation
icx -O1 -no-vec -qopenmp picalc.c timing.c timing.h
rm *.o *.gch
mv a.out picalcpara
mv picalcpara exe/
#parallel executeable generation end

echo "#threads speedup" > ./simdata/simfix-dat
echo "#threads speedup" > ./simdata/simturbo-dat
for threads in {1..36}
do
  fixfreqtime=$(srun --cpu-freq=2400000-2400000 likwid-pin -q -C S0:0-$(($threads - 1)) ./exe/picalcpara | head -n 1) 
  speedupfix=$(echo $fixfreqseqtime/$fixfreqtime | bc -l) 
  turbofreqtime=$(srun --cpu-freq=performance likwid-pin -q -C S0:0-$(($threads - 1)) ./exe/picalcpara | head -n 1) 
  speedupturbofreq=$(echo $turbofreqseqtime/$turbofreqtime | bc -l) 
  echo "$threads $speedupfix" >> ./simdata/simfix-dat
  echo "$threads $speedupturbofreq" >> ./simdata/simturbo-dat
  echo "$threads of 36 elements are done"
done
echo  >> ./simdata/simfix-dat
echo  >> ./simdata/simturbo-dat

gnuplot picalcplot.sh
