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
#SBATCH --time=05:00:00

##   Refer to DOCUMENTATION for details on the next three directives

##   Number of nodes
#SBATCH --nodes=2

##   Allocate CPUs per task (1 thread per MPI process)
#SBATCH --cpus-per-task=1

##   Number of "tasks" per node (MPI processeses per node)
#SBATCH --ntasks-per-node=24

##   Specify real memory required per node. Default units are megabytes
#SBATCH --mem=64000

##   Request Inifinband nodes on the "ub-hpc" cluster
#SBATCH --constraint="[EMERALD-RAPIDS-IB|SAPPHIRE-RAPIDS-IB|ICE-LAKE-IB|CASCADE-LAKE-IB]"
##   Request Inifinband nodes on the "faculty" cluster
##SBATCH --constraint="IB"

##   Inifinband interconnect with Intel MPI
export FI_PROVIDER=verbs
export I_MPI_FABRICS=shm:ofi
export I_MPI_PMI_LIBRARY=/opt/software/slurm/lib64/libpmi2.so

module load ccrsoft/2023.01
module load ansys
module load intel
export LSTC_LICENSE=ansys
source "${EBROOTIMPI}/mpi/latest/env/vars.sh" -i_mpi_library_kind=release

cd VM-LSDYNA-EMAG-001

##  Replace with your model file name
MODEL=i_team3_richardson.k

##   For single precision use this
#mpiexec -ppn ${SLURM_NTASKS_PER_NODE} -np ${SLURM_NTASKS} "${EBROOTANSYS}/v231/ansys/bin/linx64/lsdyna_sp_mpp.e" ncpu=-${SLURM_CPUS_PER_TASK} i=$MODEL

##   For double precision use this, uncommenting the next line and commenting out the line above
mpiexec -ppn ${SLURM_NTASKS_PER_NODE} -np ${SLURM_NTASKS} "${EBROOTANSYS}/v231/ansys/bin/linx64/lsdyna_dp_mpp.e" ncpu=-${SLURM_CPUS_PER_TASK} i=$MODEL

echo 'all done'

