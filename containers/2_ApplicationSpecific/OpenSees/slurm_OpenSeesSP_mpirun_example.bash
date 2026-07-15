#!/bin/bash -l

## This file is intended to serve as a template to be downloaded and modified for your use case.
## For more information, refer to the following resources whenever referenced in the script-
## README- https://github.com/ubccr/ccr-examples/tree/main/README.md
##  DOCUMENTATION- https://docs.ccr.buffalo.edu/en/latest/hpc/jobs

## Select a cluster, partition, qos and account that is appropriate for your use case
## Available options and more details are provided in README
#SBATCH --cluster=[cluster]
#SBATCH --partition=[partition]
#SBATCH --qos=[qos]
#SBATCH --account=[SlurmAccountName]

## NOTE: This is tested with the ccrsoft/2024.04 software release
##       The ccrsoft/2023.01 software release needs several work-rounds and will not
##       run on the emerald rapids or sapphire rapids nodes over Infiniband 

# Request Infiniband nodes
#SBATCH --constraint="[EMERALD-RAPIDS-IB|SAPPHIRE-RAPIDS-IB|ICE-LAKE-IB|CASCADE-LAKE-IB]"

## Job runtime limit, the job will be canceled once this limit is reached. Format- dd-hh:mm:ss
#SBATCH --time=00:30:00

## Refer to DOCUMENTATION for details on the following Slurm directives
## This example uses two nodes with four cores each node
#SBATCH --nodes=2
#SBATCH --cpus-per-task=1
#SBATCH --tasks-per-node=4 

## Specify memory required per node.
#SBATCH --mem=100GB

## Get the OpenSeesSP example code
if ! [ -d OpenSees ]
then
  git clone -q -b master https://github.com/OpenSees/OpenSees
fi
cd ./OpenSees/EXAMPLES/SmallSP

## Run the OpenSeesSP example over Infiniband
module load gcc openmpi
## Use the path to your build of OpenSees-$(arch).sif in the following command
mpirun --mca pml ucx --mca btl self,vader,ofi --map-by core \
 --mca orte_base_help_aggregate 0 \
 -np ${SLURM_NTASKS} apptainer exec \
 -B /util:/util,/scratch:/scratch,/projects:/projects \
 --sharens \
 /path/to/OpenSees-$(arch).sif \
 OpenSeesSP Example.tcl

