#!/bin/bash -l

## This file is intended to serve as a template to be downloaded and modified for your use case.
## For more information, refer to the following resources whenever referenced in the script-
## README- https://github.com/ubccr/ccr-examples/tree/main/slurm/README.md
##  DOCUMENTATION- https://docs.ccr.buffalo.edu/en/latest/hpc/jobs

## Select a Slurm account that is appropriate for your use case
## Available options and more details are provided in CCR's documentation:
##   https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#slurm-directives-partitions-qos
#SBATCH --cluster=ub-hpc
#SBATCH --partition=arm64
#SBATCH --qos=arm64
#SBATCH --account=[SlurmAccountName]

#SBATCH --constraint=ARM64
## NOTE: this line is requred to avoid odd X86_64 errors
#SBATCH --export=HOME,TERM,SHELL

## Job runtime limit, the job will be canceled once this limit is reached. Format- dd-hh:mm:ss
#SBATCH --time=00:20:00

## Refer to DOCUMENTATION for details on the following Slurm directives
## This example uses a node with (at least) one GPU
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --gpus-per-node=1
##SBATCH --cpus-per-task=28

## Using conainer shared namespace when running apptainer [...] gmx mdrun [...]
## so ask for the whole node (security measure)
#SBATCH --exclusive

## Use all the memory on the node.
#SBATCH --mem=0


## CONTAINER_DIR == directory with the GROMACS container image
CONTAINER_DIR="/projects/academic/[CCRgroupname]/Containers"

## For the latest version of the nvidia GROMACS container see:
##   https://catalog.ngc.nvidia.com/orgs/hpc/containers/gromacs
GROMACS_TAG="2023.2"

## Set the number of OpenMPI threads per task
## Use ${SLURM_CPUS_PER_TASK} if "#SBATCH --cpus-per-task=[...]" is used above,
## otherwise, divide the number of CPU cores by the number of GPUs allocated to the job
export OMP_NUM_THREADS="${SLURM_CPUS_PER_TASK:-$((${SLURM_JOB_CPUS_PER_NODE} / ${SLURM_GPUS_ON_NODE}))}"

## Change the nvidia cache dir from ~/.nv/ComputeCache
export CUDA_CACHE_PATH="${SLURMTMPDIR:-/var/tmp}/nv_$(id -nu)"
mkdir -p "${CUDA_CACHE_PATH}"

## Enable the direct GPU communication capabilities of MPI
export GMX_ENABLE_DIRECT_GPU_COMM=1

container_image="gromacs-${GROMACS_TAG}-$(arch).sif"

# make sure APPTAINER_TMPDIR is set to a sensible default
export APPTAINER_TMPDIR="${APPTAINER_TMPDIR:-${SLURMTMPDIR}/apptainer/tmp}"
mkdir -p "${APPTAINER_TMPDIR}"

## Fetch the nvidia GROMACS container, if necessary
gromacs_url="docker://nvcr.io/hpc/gromacs:${GROMACS_TAG}"
test ! -d "${CONTAINER_DIR}" && mkdir "${CONTAINER_DIR}"
pushd "${CONTAINER_DIR}" > /dev/null
if ! test -f "${container_image}"
then
  export APPTAINER_CACHEDIR="${APPTAINER_CACHEDIR:-${SLURMTMPDIR}/apptainer}"
  mkdir -p "${APPTAINER_CACHEDIR}"
  echo "Fetching the nvidia GROMACS container..."
  apptainer --silent pull "${container_image}" "${gromacs_url}"
  if test ! -f "${container_image}"
  then
    echo "apptainer pull failed - bailing!" >&2
    exit 1
  fi
  echo "container downloaded sucessfully:"
  ls -lh "${container_image}"
  echo
fi
popd > /dev/null

## Fetch the benchmarks
if [ ! -f "water_GMX50_bare.tar.gz" ]
then
  wget --no-verbose http://ftp.gromacs.org/pub/benchmarks/water_GMX50_bare.tar.gz
fi
gzip -dc water_GMX50_bare.tar.gz | tar xf -

cd water-cut1.0_GMX50_bare/0000.96/

apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --nv \
 "${CONTAINER_DIR}/${container_image}" \
 gmx grompp -f pme.mdp -o bench.tpr

apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --sharens \
 --nv \
 "${CONTAINER_DIR}/${container_image}" \
 gmx mdrun -ntmpi ${SLURM_GPUS_ON_NODE} -resethway -npme 0 -notunepme -noconfout -nsteps 1000 -v -s bench.tpr 

