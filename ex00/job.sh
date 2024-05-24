#!/bin/bash -l
#SBATCH --nodes=1 --time=00:30:00
#SBATCH --job-name=TEST01
#SBATCH --export=NONE
unset SLURM_EXPORT_ENV

# load compiler module
module load intel

# do you stuff
make
echo "first question" > res.txt
echo "double version time and value" >> res.txt
srun --cpu-freq=2400000-2400000 ./benchmark_double >> res.txt
echo >> res.txt
echo "third question" >> res.txt
echo "float version time and value" >> res.txt
srun --cpu-freq=2400000-2400000 ./benchmark_float >> res.txt
echo >> res.txt
echo "fourth question" >> res.txt
echo "double version time and value with performance mode" >> res.txt
srun --cpu-freq=performance ./benchmark_double >> res.txt
echo >> res.txt

make clean
