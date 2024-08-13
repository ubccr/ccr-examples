#!/bin/bash -l

#SBATCH --partition=general-compute
#SBATCH --qos=general-compute
#SBATCH --clusters=ub-hpc
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --gpus-per-node=1

module load foss niftypet ipython

# Optionally remove ~/.niftypet. This just ensures NiftyPET re-generates
# resources.py.
rm -rf $HOME/.niftypet/

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# NOTE: if you require the proprietary hardware mu-maps and have to be obtained
# them from Siemens Biograph mMR scanner, you can set this env variable:
# export HMUDIR=/path/to/mmr_hardware_mumaps

# Execute NiftyPET demo notebook from the command line.
# See here: https://niftypet.readthedocs.io/en/latest/tutorials/demo/
#
# NOTE: The demo.ipynb has been modified slightly to not use the hardware
# mu-maps per:
# https://github.com/NiftyPET/NiftyPET/issues/4#issuecomment-1202090669

# 
# This will execute demo.ipynb and save the results to a new notebook 
# named: demo.nbconvert.ipynb
srun jupyter nbconvert --execute --to notebook demo.ipynb
