#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --time=00:30:00
#SBATCH --job-name=loopbenchmark
#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

module load intel

if [ $1 == "r" ]
then
  make var=-DRAND
  STR="random Init"
  echo "augment detected"
else
  make
  STR="Zero Init"
  echo "augment undetected"
fi

for progend in stream daxpy
do 
  echo "--------------------------------------------------------------"
  echo  "scan_c_${progend}":
  echo "--------------------------------------------------------------"
  echo "#N MFLOPS/s \n" > ./${progend}-dat
  for i in {8..44};
  do
    srun --cpu-freq=2200000-2200000 \
          ./scan_c_${progend} \
          $(echo 1.5^$i | bc) >> ./${progend}-dat
  done
  echo >> ./${progend}-dat
done

make clean

gnuplot -e "title_str='loop performance in MFlops/s ($STR)' \
            ;opfname='plot_stream_daxpy_($STR).png'" \
            plotjob.sh
