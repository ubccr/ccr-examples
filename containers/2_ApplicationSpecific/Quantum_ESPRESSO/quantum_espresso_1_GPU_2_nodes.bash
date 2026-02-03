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
## Note: The Quantum ESPRESSO container verison 7.3.1 does not support L40S
##       GPU - this may be resolved in newer versions compiled with "-gpu=cc89"
##
###############################################################################
## Infiniband connected GPU nodes
##----------------------------------------------------------------------------
##
## Infininband constraints
##   [EMERALD-RAPIDS-IB|SAPPHIRE-RAPIDS-IB|ICE-LAKE-IB|CASCADE-LAKE-IB]
##
## Similar GPUs on both nodes:
##   [A100|H100|V100]"
## 
## The constraint should be:
##   --constraint="[EMERALD-RAPIDS-IB|SAPPHIRE-RAPIDS-IB|ICE-LAKE-IB|CASCADE-LAKE-IB]&[A100|H100|V100]"
##
## ...but multiple square bracket "exclusive or" sections are not supported
##
## Hence, pick one of:
##
#SBATCH --constraint="EMERALD-RAPIDS-IB&H100"
##
##SBATCH --constraint="SAPPHIRE-RAPIDS-IB&H100"
##
##SBATCH --constraint="ICE-LAKE-IB&A100"
##
##SBATCH --constraint="CASCADE-LAKE-IB&V100"
##
##----------------------------------------------------------------------------
## Non Infiniband connected GPU nodes (MPI over Ethernet)
##----------------------------------------------------------------------------
##
##SBATCH --constraint="[A16|A40|GH200]"
##
###############################################################################

###############################################################################
## "faculty" cluster constraints
###############################################################################
##
## Note: The Quantum ESPRESSO container verison 7.3.1 does not support L40S
##       GPU - this may be resolved in newer versions compiled with "-gpu=cc89"
##
###############################################################################
## Infiniband connected GPU nodes
##----------------------------------------------------------------------------
##
## The only Infiniband connected GPU nodes [at the time of writing] have A100
## GPUs:
##
## Infininband constraints
##   IB
##
## GPU constraints
##   A100
##
##SBATCH --constraint="IB&A100"
##
##----------------------------------------------------------------------------
## Non Infiniband connected GPU nodes (MPI over Ethernet)
##----------------------------------------------------------------------------
##
## Similar GPUs on both nodes:
##   [A2|A40|A100|H100|T4|V100]
##
##SBATCH --constraint="[A2|A40|A100|H100|T4|V100]"
##
###############################################################################

#SBATCH --nodes=2
#SBATCH --gpus-per-node=1
## One MPI task per GPU on each node
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=40
## Note: Use "--exclusive" for shared memory/shared namespace with apptainer
#SBATCH --exclusive

## BASE_DIR == directory with the Quantum ESPRESSO container image
BASE_DIR="/projects/academic/[CCRgroupname]/QE"

TIMESTAMP="$(date "+%F_%T")"

## use Global Scratch for run files
GS="/vscratch/[CCRgroupname]/QE/${TIMESTAMP}"

qe_version="7.3.1"


qe_url="docker://nvcr.io/hpc/quantum_espresso:qe-${qe_version}"
container_image="quantum_espresso-${qe_version}-$(arch).sif"
## Fetch the Quantum ESPRESSO container, if necessary
pushd "${BASE_DIR}" > /dev/null
if ! test -f "${container_image}"
then
  apptainer pull "${container_image}" "${qe_url}"
fi
popd > /dev/null

## Use the OpenMPI UCX Point-to-point Messaging Layer
export OMPI_MCA_pml=ucx

## requerted MPIx environment variables for authentication (or srun can fail)
export PMIX_MCA_psec=native && export PMIX_MCA_gds=hash

## report the GPUs in the job
srun --export=ALL --ntasks-per-node=1 --nodes="${SLURM_JOB_NUM_NODES}" -- bash -c 'printf "hostname: %s\n%s\n\n" "$(hostname -s)" "$(nvidia-smi -L)"'
echo

export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}

BASE=ausurf
INFILE=${BASE}.in

## Get the test files if necessary...
if ! [ -f "benchmarks/AUSURF112/${INFILE}" ]
then
  git clone "https://github.com/QEF/benchmarks.git"
fi

cd "benchmarks/AUSURF112"

OUTFILE="${SLURM_SUBMIT_DIR}/${BASE}_${TIMESTAMP}.out"
echo "OUTFILE=${OUTFILE}"

mkdir -p "${GS}"
sed -E -i "/^[[:space:]]*outdir/s|^([[:space:]]*).*$|\1outdir = '${GS}'|" "${INFILE}"

## There are several options to save data file and the charge density files to
## disk - in this case the files will be written to the scratch space defined above
## Generally, the more data written to disk, the lower the RAM requiremenets
##
## see:
##   https://www.quantum-espresso.org/Doc/INPUT_PW.html#id20
##
## This problem requires about 21000 MiB of GPU ram to run in GPU memory
## Using the disk_io = 'high' will reduce this requirement, but the job still
## fails in our tests on a sinlge GPU with ~15000 MiB of GPU ram
##
total_gpu_memory="$(expr $(echo $(srun --export=ALL --ntasks-per-node=1 --nodes="${SLURM_JOB_NUM_NODES}" -- nvidia-smi --query-gpu=memory.total --format=csv,noheader | awk '{print $1, "+"}') 0))"
if [ ${total_gpu_memory} -lt 21000 ]
then
  # Set disk_io to "high" to minimise needed GPU RAM
  sed -E -i "/^[[:space:]]*disk_io/s|^([[:space:]]*).*$|\1disk_io = 'high'|" "${INFILE}"
  echo "Warning: This job requires about 21000 MiB of GPU RAM and will likley fail" >&2
  echo "         with a cuMemAlloc Out of memory error" >&2
else
  # Set "disk_io" to the default setting of "low"
  sed -E -i "/^[[:space:]]*disk_io/s|^([[:space:]]*).*$|\1disk_io = 'low'|" "${INFILE}"
fi

## Run Quantum ESPRESSO
srun --mpi=pmix \
 --export=ALL \
 apptainer exec \
  -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --sharens \
 --nv \
 "${BASE_DIR}/${container_image}" \
 pw.x -in "${INFILE}" > "${OUTFILE}"

## Optional:
##   If the "disk_io" optoin is set to anything other than "none"  a .save
##   directory is created - move this directory from scratch space
if test -d "${SLURMTMPDIR}/${BASE}.save"
then
  mv "${SLURMTMPDIR}/${BASE}.save" "${SLURM_SUBMIT_DIR}/${BASE}_${TIMESTAMP}.save"
fi

## Cleanup - Remove run files
if [ -d "${GS}" ]
then
  rm -rf "${GS}"
fi

