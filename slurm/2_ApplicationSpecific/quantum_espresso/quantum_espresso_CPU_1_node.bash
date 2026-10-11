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
#SBATCH --nodes=1
## One MPI task per core
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

# Use ${SLURMTMPDIR} for run files
sed -E -i "/^[[:space:]]*outdir/s|^([[:space:]]*).*$|\1outdir = '${SLURMTMPDIR}'|" "${INFILE}"

# OpenMPI environment variables for PMIx over shared memory
export OMPI_MCA_pml=ucx && export OMPI_MCA_btl="self,vader"
export PMIX_MCA_psec=native && export PMIX_MCA_gds=hash

# Run Quantum ESPRESSO
srun --mpi=pmix pw.x -in "${INFILE}" > "${OUTFILE}"

# Optional - save the config files for the run:
mv "${SLURMTMPDIR}/${BASE}.save" "${SLURM_SUBMIT_DIR}/${BASE}_${TIMESTAMP}.save"

