#!/bin/bash -l

## This file is intended to serve as a template to be downloaded and modified for your use case.
## For more information, refer to the following resources whenever referenced in the script-
## README- https://github.com/ubccr/ccr-examples/tree/main/slurm/README.md
##  DOCUMENTATION- https://docs.ccr.buffalo.edu/en/latest/hpc/jobs

## Select a cluster, partition, qos and account that is appropriate for your use case
## Available options and more details are provided in CCR's documentation:
##   https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#slurm-directives-partitions-qos
#SBATCH --cluster=[cluster]
#SBATCH --partition=[partition]
#SBATCH --qos=[qos]
#SBATCH --account=[SlurmAccountName]

## NOTE: This is tested with the ccrsoft/2024.04 software release
##       The ccrsoft/2023.01 software release needs several work-rounds and will not
##       run on the emerald rapids or sapphire rapids nodes over Infiniband 

## Request Inifinband nodes
#SBATCH --constraint="[EMERALD-RAPIDS-IB|SAPPHIRE-RAPIDS-IB|ICE-LAKE-IB|CASCADE-LAKE-IB]"

## Job runtime limit, the job will be canceled once this limit is reached. Format- dd-hh:mm:ss
#SBATCH --time=00:30:00

## Refer to DOCUMENTATION for details on the following Slurm directives
## This example uses two nodes with thirty cores on each node
#SBATCH --nodes=2
#SBATCH --cpus-per-task=1
#SBATCH --tasks-per-node=30
## Using conainer shared namespace, so ask for the whole node (security measure)
#SBATCH --exclusive

## Specify memory required per node.
#SBATCH --mem=100GB

## Use Infiniband
export OMPI_MCA_pml="ucx"
export OMPI_MCA_btl="self,vader,ofi"

## Avoid possible auth & gds issues:
export PMIX_MCA_psec="native"
export PMIX_MCA_gds="hash"

# Change the nvidia cache dir from ~/.nv/ComputeCache
export CUDA_CACHE_PATH="${SLURMTMPDIR:-/var/tmp}/nv_$(id -nu)"
mkdir -p "${CUDA_CACHE_PATH}"

## Run GROMACS Equilibration first phase under an NVT ensemble with multiple
## nodes over Infiniband
## Use the path to your build of GROMACS-$(arch).sif in the following command
srun --mpi=pmix \
 --nodes=${SLURM_NNODES} \
 --ntasks-per-node=${SLURM_NTASKS_PER_NODE} \
 apptainer exec \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --sharens \
 /path/to/GROMACS-$(arch).sif \
 gmx_mpi mdrun -deffnm nvt

