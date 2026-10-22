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
#SBATCH --time=14:00:00

##   Refer to DOCUMENTATION for details on the next three directives

##   Number of nodes
#SBATCH --nodes=1

##  One task for OpenMP
#SBATCH --ntasks-per-node=1

##   Allocate CPUs per task (OpenMP threads)
#SBATCH --cpus-per-task=16

##   Specify real memory required per node. Default units are megabytes
#SBATCH --mem=128000

# set the path ot your projects directory
export PROJECTS_DIR="/projects/academic/[YourGroupName]"

if ! [ -d "VM-LSDYNA-EMAG-001" ]
then
  unzip "VM-LSDYNA-EMAG-001.zip"
fi
cd "VM-LSDYNA-EMAG-001"

##  Replace with your model file name
MODEL="i_team3_richardson.k"

##  For single precision use this
#apptainer run --nv --no-env=XDG_DATA_DIRS --writable-tmpfs \
# --bind "/util":"/util","/scratch":"/scratch" \
# --bind "${PROJECTS_DIR}":"${PROJECTS_DIR}" \
# --bind "/util/software/licenses/ansyslmd.ini":"/opt/ansys_inc/shared_files/licensing/ansyslmd.ini":ro \
# /util/software/containers/x86_64/ANSYS-2026_R1-x86_64.sif \
# lsdyna ncpu=-${SLURM_JOB_CPUS_PER_NODE} i="${MODEL}"

##  For double precision use this, uncommenting the next line and commenting out the line above
apptainer run --nv --no-env=XDG_DATA_DIRS --writable-tmpfs \
 --bind "/util":"/util","/scratch":"/scratch" \
 --bind "${PROJECTS_DIR}":"${PROJECTS_DIR}" \
 --bind "/util/software/licenses/ansyslmd.ini":"/opt/ansys_inc/shared_files/licensing/ansyslmd.ini":ro \
 /util/software/containers/x86_64/ANSYS-2026_R1-x86_64.sif \
 lsdyna -dp ncpu=-${SLURM_JOB_CPUS_PER_NODE} i="${MODEL}"

echo 'all done'

