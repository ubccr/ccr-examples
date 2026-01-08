#!/bin/bash -l

## This file is intended to serve as a template to be downloaded and modified for your use case.
## For more information, refer to the following resources whenever referenced in the script-
## README- https://github.com/ubccr/ccr-examples/tree/main/slurm/README.md
## DOCUMENTATION- https://docs.ccr.buffalo.edu/en/latest/hpc/jobs

## NOTE: This Slurm script was tested with the ccrsoft/2024.04 software release

## Select a cluster, partition, qos and account that is appropriate for your use case
## Available options and more details are provided in CCR's documentation:
##   https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#slurm-directives-partitions-qos
#SBATCH --cluster="[cluster]"
#SBATCH --partition="[partition]"
#SBATCH --qos="[qos]"
#SBATCH --account="[SlurmAccountName]"

#SBATCH --time=01:00:00

###############################################################################
## "ub-hpc" cluster constraints
###############################################################################
##
## Infiniband with ccrsoft/2023.01
##   [ICE-LAKE-IB|CASCADE-LAKE-IB]
##
## Use all AVX512 nodes or all AVX2 nodes (so both nodes are running the same
## Quantum Espresso binary)
##   [AVX512|AVX2]
##
## The constraint should be:
##   --constraint="[ICE-LAKE-IB|CASCADE-LAKE-IB]&[AVX512|AVX2]"
##
## ...but multiple square bracket "exclusive or" sections are not supported,
##
## All the ICE-LAKE-IB and CASCADE-LAKE-IB nodes are AVX512
## Hence this is sufficient to guarantee we get two Infiniband nodes with AVX512
## CPUs:
#SBATCH --constraint="[ICE-LAKE-IB|CASCADE-LAKE-IB]"
###############################################################################

###############################################################################
## "faculty" cluster constraints
###############################################################################
##
## Infiniband
##   IB
##
## Use all AVX512 nodes or all AVX2 nodes (so both nodes are running the same
## Quantum Espresso binary)
##   [AVX512|AVX2]
##
##SBATCH --constraint="IB&[AVX512|AVX2]"
###############################################################################

#SBATCH --nodes=2
## One MPI task per core on each node
#SBATCH --ntasks-per-node=64
#SBATCH --cpus-per-task=1
#SBATCH --exclusive

module load ccrsoft/2023.01

# CPU version
module load gcc/11.2.0 openmpi/4.1.1 quantumespresso/7.1 ucx/1.13.1

export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}

BASE=ausurf
INFILE=${BASE}.in

# Get the test files if necessary...
if ! [ -f "benchmarks/AUSURF112/${INFILE}" ]
then
  git clone "https://github.com/QEF/benchmarks.git"
fi

cd "benchmarks/AUSURF112"

TIMESTAMP="$(date "+%F_%T")"

OUTFILE="${SLURM_SUBMIT_DIR}/${BASE}_${TIMESTAMP}.out"
echo "OUTFILE=${OUTFILE}"

# use Global Scratch for run files
GS="/vscratch/[CCRgroupname]/QE/${TIMESTAMP}"
mkdir -p "${GS}"
sed -E -i "/^[[:space:]]*outdir/s|^([[:space:]]*).*$|\1outdir = '${GS}'|" "${INFILE}"

# OpenMPI environment variables for PMIx over shared memory first, then
# OpenFabrics Interface (Infiniband)
export OMPI_MCA_pml=ucx && export OMPI_MCA_btl="self,vader,ofi"
export PMIX_MCA_psec=native && export PMIX_MCA_gds=hash

# Run Quantum ESPRESSO
srun --mpi=pmix pw.x -in "${INFILE}" > "${OUTFILE}"

# Optional - save the config files for the run:
mv "${GS}/${BASE}.save" "${SLURM_SUBMIT_DIR}/${BASE}_${TIMESTAMP}.save"

# Cleanup - Remove run files
if [ -d "${GS}" ]
then
  rm -rf "${GS}"
fi

