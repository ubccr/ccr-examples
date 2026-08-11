#!/bin/bash -l

## This file is intended to serve as a template to be downloaded and modified for your use case.
## For more information, refer to the following resources whenever referenced in the script-
## README- https://github.com/ubccr/ccr-examples/tree/main/slurm/README.md
## DOCUMENTATION- https://docs.ccr.buffalo.edu/en/latest/hpc/jobs

## Select an account that is appropriate for your use case
## Available options and more details are provided in CCR's documentation:
##   https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#slurm-directives-partitions-qos
#SBATCH --account="[SlurmAccountName]"

#SBATCH --cluster="ub-hpc"
#SBATCH --partition="arm64"
#SBATCH --qos="arm64"
#SBATCH --export=HOME,TERM,SHELL
#SBATCH --constraint="GH200"
#SBATCH --time=01:00:00
#SBATCH --nodes=2
#SBATCH --gpus-per-node=1
## One MPI task per GPU on each node
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=40
## Note: Use "--exclusive" for shared memory/shared namespace with apptainer
#SBATCH --exclusive

## CONTAINER_DIR == directory with the Quantum ESPRESSO container image
CONTAINER_DIR="/projects/academic/[CCRgroupname]/QE"

TIMESTAMP="$(date "+%F_%T")"

## use Global Scratch for run files
GS="/vscratch/[CCRgroupname]/QE/${TIMESTAMP}"

qe_version="7.3.1"


qe_url="docker://nvcr.io/hpc/quantum_espresso:qe-${qe_version}"
container_image="quantum_espresso-${qe_version}-$(arch).sif"
## Fetch the Quantum ESPRESSO container, if necessary
pushd "${CONTAINER_DIR}" > /dev/null
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

## Set the output directory "outdir" to the Global Scratch directory "${GS}"
mkdir -p "${GS}"
sed -E -i "/^[[:space:]]*outdir/s|^([[:space:]]*).*$|\1outdir = '${GS}'|" "${INFILE}"

## Optional:
##
## Set "wfcdir" the directory to store per process files (*.wfc{N}, *.igk{N}, etc.)
## to ${SLURMTMPDIR} (local scratch on each node)
##
## Note: You probably don't want to do this if you are planning to use "restart"
##       or you need to perform further calculations using these files
if grep -E -q '^[[:space:]]*wfcdir([[:space:]]|=)' "${INFILE}"
then
  # modify "wfcdir" setting
  sed -E -i "/^[[:space:]]*wfcdir/s|^([[:space:]]*).*$|\1wfcdir = '${SLURMTMPDIR}'|" "${INFILE}"
else
  # add "wfcdir" setting
  sed -E -i "/^[[:space:]]*outdir/a \  wfcdir = '${SLURMTMPDIR}'" "${INFILE}"
fi

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
 "${CONTAINER_DIR}/${container_image}" \
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

