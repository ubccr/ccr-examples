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

##   Allocate CPUs per task (number of threads)
#SBATCH --cpus-per-task=24

##   Single task for a shared memory job
#SBATCH --ntasks-per-node=1

##   Specify real memory required per node. Default units are megabytes
#SBATCH --mem=64000

module load ccrsoft/2023.01
module load ansys
export LSTC_LICENSE=ansys
echo "LS-DYNA running on ${SLURM_CPUS_PER_TASK} cores"

cd VM-LSDYNA-EMAG-001

##   Replace with your model file name
MODEL=i_team3_richardson.k

##   For single precision use this
#"${EBROOTANSYS}/v231/ansys/bin/linx64/lsdyna_sp.e" ncpu=-${SLURM_CPUS_PER_TASK} i=$MODEL

##   For double precision use this, uncommenting the next line and commenting out the line above
"${EBROOTANSYS}/v231/ansys/bin/linx64/lsdyna_dp.e" ncpu=-${SLURM_CPUS_PER_TASK} i=$MODEL

echo 'all done'
exit

