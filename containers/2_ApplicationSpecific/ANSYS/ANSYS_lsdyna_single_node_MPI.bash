#!/bin/bash -l

##   This file is intended to serve as a template to be downloaded and modified for your use case.
##   For more information, refer to the following resources whenever referenced in the script-
##   README- https://github.com/ubccr/ccr-examples/tree/main/README.md
##   DOCUMENTATION- https://docs.ccr.buffalo.edu/en/latest/hpc/jobs

##   Select a cluster, partition, qos and account that is appropriate for your use case
##   Available options and more details are provided in README
#SBATCH --cluster=[cluster]
#SBATCH --partition=[partition]
#SBATCH --qos=[qos]
#SBATCH --account=[SlurmAccountName]

##   Job runtime limit. Format- dd-hh:mm:ss
#SBATCH --time=08:00:00

##   Refer to DOCUMENTATION for details on the next three directives

##   Number of nodes
#SBATCH --nodes=1

##   Allocate CPUs per task (1 thread per MPI process)
#SBATCH --cpus-per-task=1

##   Number of "tasks" per node (MPI processeses per node)
#SBATCH --ntasks-per-node=16

##   Specify real memory required per node. Default units are megabytes
#SBATCH --mem=128000

# set the path ot your projects directory
export PROJECTS_DIR="/projects/academic/[YourGroupName]"

##   Intel MPI with Shared memory
module load iimpi
export FI_PROVIDER=shm
export I_MPI_FABRICS=shm
export I_MPI_SHM_LMT=shm
export I_MPI_PMI_LIBRARY=/opt/software/slurm/lib64/libpmi2.so

if ! [ -d "VM-LSDYNA-EMAG-001" ]
then
  unzip "VM-LSDYNA-EMAG-001.zip"
fi
cd "VM-LSDYNA-EMAG-001"

##  Replace with your model file name
MODEL="i_team3_richardson.k"

##  For single precision use this
#srun --mpi=pmi2 \
# --nodes=${SLURM_NNODES} \
# --ntasks-per-node=${SLURM_NTASKS_PER_NODE} \
# apptainer run --nv --no-env=XDG_DATA_DIRS --writable-tmpfs \
# --bind "/util":"/util","/scratch":"/scratch" \
# --bind "${PROJECTS_DIR}":"${PROJECTS_DIR}" \
# --bind "/util/software/licenses/ansyslmd.ini":"/opt/ansys_inc/shared_files/licensing/ansyslmd.ini":ro \
# "/util/software/containers/x86_64/ANSYS-2026_R1-x86_64.sif" \
# bash -c "LD_LIBRARY_PATH=/opt/ansys_inc/v261/tp/MPI/Intel/2018.3.222/linx64/lib \
#  exec lsdyna_sp_mpp.e ncpu=-${SLURM_CPUS_PER_TASK} i=${MODEL}"

##  For double precision use this, uncommenting the next line and commenting out the line above
srun --mpi=pmi2 \
 --nodes=${SLURM_NNODES} \
 --ntasks-per-node=${SLURM_NTASKS_PER_NODE} \
 apptainer run --nv --no-env=XDG_DATA_DIRS --writable-tmpfs \
 --bind "/util":"/util","/scratch":"/scratch" \
 --bind "${PROJECTS_DIR}":"${PROJECTS_DIR}" \
 --bind "/util/software/licenses/ansyslmd.ini":"/opt/ansys_inc/shared_files/licensing/ansyslmd.ini":ro \
 "/util/software/containers/x86_64/ANSYS-2026_R1-x86_64.sif" \
 bash -c "LD_LIBRARY_PATH=/opt/ansys_inc/v261/tp/MPI/Intel/2018.3.222/linx64/lib \
  exec lsdyna_dp_mpp.e ncpu=-${SLURM_CPUS_PER_TASK} i=${MODEL}"

echo 'all done'

