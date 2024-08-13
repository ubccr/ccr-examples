#!/bin/bash -l

#SBATCH --qos=general-compute
#SBATCH --clusters=ub-hpc
#SBATCH --time=01:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --gres=gpu:1

module load easybuild

# Set this to somewhere in your projects directory where you'd like to
# build custom modules
export CCR_BUILD_PREFIX=$SLURMTMPDIR/easybuild

# This is so that lmod can find your modules. Also can add paths to
# ~/.ccr/modulepaths
export CCR_CUSTOM_BUILD_PATHS="$CCR_BUILD_PREFIX:$CCR_CUSTOM_BUILD_PATHS"

# Run the build with easybuild
eb PETSc-3.19.knepley.83c5a5bb-foss-2021b-CUDA-11.8.0.eb
