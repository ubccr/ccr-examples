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

## Job runtime limit, the job will be canceled once this limit is reached. Format- dd-hh:mm:ss
#SBATCH --time=00:20:00

## NOTE: R uses only one core, unless you specifically use functions that take
##       advantage of multiple cores, such as the 'parallel' package.
##       This example allocates 6 cores, so apptainer has a thread for itself,
##       plus a thread for each bind mount, leaving one core for the R process
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=36GB

R_version="4.5.1"

# Run containerized R
apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 R_rocker_${R_version}-$(arch).sif \
 Rscript estimate_pi.R

