#!/bin/bash -l

##   This file is intended to serve as a template to be downloaded and modified for your use case.
##   For more information, refer to the following resources whenever referenced in the script-
##   README- https://github.com/ubccr/ccr-examples/tree/main/slurm/README.md
##   DOCUMENTATION- https://docs.ccr.buffalo.edu/en/latest/hpc/jobs
##   GPU DOCUMENTATION- https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#slurm-directives-partitions-qos (CCR Staff: Needs to be updated)

##   Select a cluster, partition, qos and account that is appropriate for your use case
##   Available options and more details are provided in README
#SBATCH --cluster=[cluster]
#SBATCH --partition=[partition]
#SBATCH --qos=[qos]
#SBATCH --account=[SlurmAccountName]

##   Job runtime limit, the job will be canceled once this limit is reached. Format- dd:hh:mm
#SBATCH --time=01:30:00

##   Refer to DOCUMENTATION for details on the next two directives

##   Specify the number of tasks (for parallelism)
#SBATCH --ntasks=1

##   Allocate CPUs per task
#SBATCH --cpus-per-task=32

##   #Need information here. Refer to GPU DOCUMENTATION
#SBATCH --gres=gpu:1

module load easybuild

##   Set this to somewhere in your projects directory where you'd like to
##   build custom modules
export CCR_BUILD_PREFIX=$SLURMTMPDIR/easybuild

##   This is so that lmod can find your modules. Also can add paths to
##   ~/.ccr/modulepaths
export CCR_CUSTOM_BUILD_PATHS="$CCR_BUILD_PREFIX:$CCR_CUSTOM_BUILD_PATHS"

##   Run the build with easybuild
eb PETSc-3.19.knepley.83c5a5bb-foss-2021b-CUDA-11.8.0.eb
