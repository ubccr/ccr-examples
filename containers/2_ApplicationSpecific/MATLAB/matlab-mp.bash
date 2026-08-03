#!/bin/bash -l

## This file is intended to serve as a template to be downloaded and modified for your use case.
## For more information, refer to the following resources whenever referenced in the script-
## README- https://github.com/ubccr/ccr-examples/tree/main/slurm/README.md
## DOCUMENTATION- https://docs.ccr.buffalo.edu/en/latest/hpc/jobs

## Select a cluster, partition, qos and account that is appropriate for your use case
## Available options and more details are provided in CCR's documentation:
##   https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#slurm-directives-partitions-qos
#SBATCH --cluster="[cluster]"
#SBATCH --partition="[partition]"
#SBATCH --qos="[qos]"
#SBATCH --account="[SlurmAccountName]"

## Job Name
#SBATCH --job-name="matlab-mp"

## Job runtime limit, the job will be canceled once this limit is reached. Format- dd-hh:mm:ss
#SBATCH --time=00:02:00

#SBATCH --nodes=1                       # one node
#SBATCH --tasks-per-node=1              # one task
#SBATCH --cpus-per-task=16              # sixteen cores per task
#SBATCH --mem=64G                       # 64GB RAM

## change to the MATLAB directory
cd /projects/academic/[YourGroupName]/MATLAB

apptainer run --no-env=XDG_DATA_DIRS --writable-tmpfs \
 --bind /util:/util,/scratch:/scratch \
 --bind /vscratch/grp-[YourGroupName]:/vscratch/grp-[YourGroupName] \
 --bind /projects/academic/[YourGroupName]:/projects/academic/[YourGroupName] \
 --bind /util/software/licenses/matlab.lic:/MATLAB/licenses/licenses.lic:ro \
 /util/software/containers/x86_64/MATLAB-R2025b-all_licenced_products-x86_64.sif \
 matlab -nojvm -nodisplay -nosplash -r for_loop

