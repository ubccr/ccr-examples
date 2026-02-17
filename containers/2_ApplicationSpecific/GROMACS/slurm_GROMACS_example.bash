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

## Request Inifinband nodes
#SBATCH --constraint="[EMERALD-RAPIDS-IB|SAPPHIRE-RAPIDS-IB|ICE-LAKE-IB|CASCADE-LAKE-IB]"

## Job runtime limit, the job will be canceled once this limit is reached. Format- dd-hh:mm:ss
#SBATCH --time=00:30:00

## Refer to DOCUMENTATION for details on the following Slurm directives
## This example uses two nodes with thirty cores on each node
#SBATCH --nodes=2
#SBATCH --gpus-per-node=2
#SBATCH --tasks-per-node=2
#SBATCH --cpus-per-task=14
## Using conainer shared namespace, so ask for the whole node (security measure)
#SBATCH --exclusive
## Use all the memory onm the node.
#SBATCH --mem=0

## Use the OpenMPI UCX Point-to-point Messaging Layer
export OMPI_MCA_pml=ucx

## requerted MPIx environment variables for authentication (or srun can fail)
export PMIX_MCA_psec=native && export PMIX_MCA_gds=hash

# Change the nvidia cache dir from ~/.nv/ComputeCache
export CUDA_CACHE_PATH="${SLURMTMPDIR:-/var/tmp}/nv_$(id -nu)"
mkdir -p "${CUDA_CACHE_PATH}"

## Enable the direct GPU communication capabilities of MPI
export GMX_ENABLE_DIRECT_GPU_COMM=1


## CONTAINER_DIR == directory with the Quantum ESPRESSO container image
CONTAINER_DIR="/projects/academic/[CCRgroupname]/Containers"

# For the latest version of the GROMACS container see:
#   https://catalog.ngc.nvidia.com/orgs/hpc/containers/gromacs
gromacs_container_version="2023.2"

container_image="gromacs-${gromacs_container_version}-$(arch).sif"

# Fetch the nvidia GROMACS container, if necessary
gromacs_url="docker://nvcr.io/hpc/gromacs:${gromacs_container_version}"
test ! -d "${CONTAINER_DIR}" && mkdir "${CONTAINER_DIR}"
pushd "${CONTAINER_DIR}" > /dev/null
if ! test -f "${container_image}"
then
  apptainer pull "${container_image}" "${gromacs_url}"
fi
popd > /dev/null

## Note: "gmx grompp" does NOT run in parallel
## example to run "gmx grompp"
#apptainer run \
# -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
# --nv \
# /path/to/GROMACS-$(arch).sif \
# gmx grompp [...]


## Run GROMACS Equilibration first phase under an NVT ensemble with multiple
## nodes over Infiniband
## Use the path to your build of GROMACS-$(arch).sif in the following command
srun --mpi=pmix \
 --nodes=${SLURM_NNODES} \
 --ntasks-per-node=${SLURM_NTASKS_PER_NODE} \
 apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --sharens \
 --nv \
 /path/to/GROMACS-$(arch).sif \
 gmx_mpi mdrun -deffnm nvt

