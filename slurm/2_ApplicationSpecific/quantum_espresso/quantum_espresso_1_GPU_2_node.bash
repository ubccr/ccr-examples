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
## Infiniband with ccrsoft/2023.01 :-
##   [ICE-LAKE-IB|CASCADE-LAKE-IB]
##
## Similar tested GPUs on both nodes:
##   [A16|A40|A100]
## 
## CUDA version of Quantum ESPRESSO only (currenlty) built for AVX512 :-
##   AVX512
##
## The constraint should be:
##   --constraint="[ICE-LAKE-IB|CASCADE-LAKE-IB]&[A16|A40|A100]&AVX512"
##
## ...but multiple square bracket "exclusive or" sections are not supported
##
## The ICE-LAKE-IB nodes with a GPU are all A100
## The CASCADE-LAKE-IB nodes with a GPU are all V100
## The V100 does not work with Quantum ESPRESSO, hence we can use the following 
## for two nodes with similar tested GPUs:
#SBATCH --constraint="ICE-LAKE-IB&[A16|A40|A100]&AVX512"
##
###############################################################################

###############################################################################
## "faculty" cluster constraints
###############################################################################
##
## Infiniband
##   IB
##
## Similar tested GPUs on both nodes:
##   [A2|A40|A100]
##
## CUDA version of Quantum ESPRESSO only (currenlty) built for AVX512 :-
##   AVX512
##
##SBATCH --constraint="IB&[A2|A40|A100]&AVX512"
##
###############################################################################

#SBATCH --nodes=2
#SBATCH --gpus-per-node=1
## One MPI task per GPU on each node
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=40
#SBATCH --exclusive

module load ccrsoft/2023.01

# GPU version
module load nvhpc/22.7-CUDA-11.8.0 openmpi/4.1.4 quantumespresso/7.2 ucx/1.13.1

# report the GPUs in the job
srun --ntasks-per-node=1 --nodes="${SLURM_JOB_NUM_NODES}"  bash -c 'printf "hostname: %s\n%s\n\n" "$(hostname -s)" "$(nvidia-smi -L)"'
echo

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

# OpenMPI environment variables for PMIx over shared memory, then
#  CUDA shared memory and finally over OpenFabrics Interface (Infiniband)
export OMPI_MCA_pml=ucx && export OMPI_MCA_btl="self,vader,smcuda,ofi"
export PMIX_MCA_psec=native && export PMIX_MCA_gds=hash

# Run Quantum ESPRESSO
LD_LIBRARY_PATH=/opt/software/slurm/lib64 srun --mpi=pmix pw.x -in "${INFILE}" > "${OUTFILE}"

# Optional - save the config files for the run:
mv "${GS}/${BASE}.save" "${SLURM_SUBMIT_DIR}/${BASE}_${TIMESTAMP}.save"

# Cleanup - Remove run files
if [ -d "${GS}" ]
then
  rm -rf "${GS}"
fi

