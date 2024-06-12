#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH -p singlenode
#SBATCH --time=00:45:00
#SBATCH --job-name=picalcspeedup
#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

module load intel
module load likwid

#seqential executeable generation
icx -O1 -no-vec picalc.c timing.c timing.h
rm *.o *.gch
mv a.out picalcseq
seqtime=$(./picalcseq | head -n 1)
#seqential executeable generation end
fixfreqseqtime=$(srun --cpu-freq=2400000-2400000 ./picalcseq | head -n 1) 
turbofreqseqtime=$(srun --cpu-freq=performance ./picalcseq | head -n 1) 


#parallel executeable generation
icx -O1 -no-vec -qopenmp picalc.c timing.c timing.h
rm *.o *.gch
mv a.out picalcpara
#parallel executeable generation end

echo "#threads speedup" > ./simfix-dat
echo "#threads speedup" > ./simturbo-dat
for threads in {1..36};
do
  fixfreqtime=$(srun --cpu-freq=2400000-2400000 likwid-pin -q -C S0:0-$(($threads - 1)) ./picalcpara | head -n 1) 
  turbofreqtime=$(srun --cpu-freq=performance likwid-pin -q -C S0:0-$(($threads - 1)) ./picalcpara | head -n 1) 
  speedupfix=$(echo $fixfreqtime/$fixfreqseqtime | bc -l) 
  speedupturbofreq=$(echo $turbofreqtime/$turbofreqseqtime | bc -l) 
  echo "$threads $speedupfix" >> ./simfix-dat
  echo "$threads $speedupturbofreq" >> ./simturbo-dat
  echo "$threads of 36 elements are done"
done
echo  >> ./simfix-dat
echo  >> ./simturbo-dat

gnuplot plotjob.sh
