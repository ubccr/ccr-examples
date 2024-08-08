#!/bin/bash -l

#SBATCH --qos=general-compute
#SBATCH --clusters=ub-hpc
#SBATCH --time=01:00:00
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 32
#SBATCH --mem=64G
#SBATCH --gres=gpu:1

# By default data is cached in your homedir. Set this to cache data 
# in your project space or scratch space:
export TORCH_HOME=$SLURMTMPDIR/cache/torch

module load foss sentence-transformers
srun python3 evaluation_stsbenchmark.py
