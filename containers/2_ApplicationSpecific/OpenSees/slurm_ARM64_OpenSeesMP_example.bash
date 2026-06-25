#!/bin/bash -l

## This file is intended to serve as a template to be downloaded and modified for your use case.
## For more information, refer to the following resources whenever referenced in the script-
## README- https://github.com/ubccr/ccr-examples/tree/main/README.md
##  DOCUMENTATION- https://docs.ccr.buffalo.edu/en/latest/hpc/jobs


#SBATCH --cluster=ub-hpc
#SBATCH --partition=arm64
#SBATCH --qos=arm64
#SBATCH --account=[SlurmAccountName]

#SBATCH --constraint=ARM64
## NOTE: this line is requred to avoid odd X86_64 errors
#SBATCH --export=HOME,TERM,SHELL

## NOTE: This is tested with the ccrsoft/2024.04 software release
##       The ccrsoft/2023.01 software release does not support ARM64 nodes

## Job runtime limit, the job will be canceled once this limit is reached. Format- dd-hh:mm:ss
#SBATCH --time=00:30:00

## Refer to DOCUMENTATION for details on the following Slurm directives
## This example uses two nodes with thirty cores on each node
#SBATCH --nodes=2
#SBATCH --cpus-per-task=1
#SBATCH --tasks-per-node=30

## Specify memory required per node.
#SBATCH --mem=100GB

## Get the OpenSeesMP example code
if ! [ -d OpenSees ]
then
  git clone -q -b master https://github.com/OpenSees/OpenSees
fi
cd ./OpenSees/EXAMPLES/SmallMP

## Avoid possible auth & gds issues:
export PMIX_MCA_psec="native"
export PMIX_MCA_gds="hash"

## Run the OpenSeesMP example
## Use the path to your build of OpenSees-$(arch).sif in the following command
srun --mpi=pmix \
 --nodes=${SLURM_NNODES} \
 --ntasks-per-node=${SLURM_NTASKS_PER_NODE} \
 $(which apptainer) exec \
 -B /util:/util,/scratch:/scratch,/projects:/projects \
 --sharens \
 /path/to/OpenSees-$(arch).sif \
 OpenSeesMP Example.tcl

