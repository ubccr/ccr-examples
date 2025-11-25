#!/bin/bash -l

## This file is intended to serve as a template to be downloaded and modified for your use case.
## For more information, refer to the following resources whenever referenced in the script-
## README- https://github.com/ubccr/ccr-examples/tree/main/slurm/README.md
##  DOCUMENTATION- https://docs.ccr.buffalo.edu/en/latest/hpc/jobs

## Select a cluster, partition, qos and account that is appropriate for your use case
## Available options and more details are provided in CCR's documentation:
##   https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#slurm-directives-partitions-qos
#SBATCH --cluster="[cluster]"
#SBATCH --partition="[partition]"
#SBATCH --qos="[qos]"
#SBATCH --account="[SlurmAccountName]"

## NOTE: This is tested with the ccrsoft/2024.04 software release
##       The ccrsoft/2023.01 software release needs several work-rounds and will not
##       run on the emerald rapids or sapphire rapids nodes over Infiniband 

## Job runtime limit, the job will be canceled once this limit is reached. Format- dd-hh:mm:ss
#SBATCH --time=00:30:00

## This example uses two nodes with four cores each node
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --tasks-per-node=10

## Specify memory required per node.
#SBATCH --mem=120GB

###############################################################################
# OpenFOAM container setup
###############################################################################
if [ "${APPTAINER_NAME}" = "" ]
then
  # Launch the container with this script
  exec apptainer exec -B /util:/util,/scratch:/scratch,/vscratch:/vscratch,/projects:/projects \
   /projects/academic/[YourGroupName]/OpenFOAM/OpenFOAM-13-$(arch).sif \
   bash "$(scontrol show job $SLURM_JOB_ID | awk -F= '/Command=/{print $2}')"
fi
# Inside the container - OpenFOAM setup:
source /opt/openfoam13/etc/bashrc && mkdir -p "${FOAM_RUN}" "${FOAM_JOB_DIR}"
###############################################################################

# You can run the same OpenFOAM commands you would run from
# the "Apptainer> " prompt here:

cd "${FOAM_RUN}" || exit 1

# Example info here:
#   https://doc.cfd.direct/openfoam/user-guide-v13/backwardstep

# remove any prior run dir
rm -rf "pitzDailySteady"

# copy the exam[ple
cp -r "${FOAM_TUTORIALS}/incompressibleFluid/pitzDailySteady" .
cd "pitzDailySteady"

echo "run blockMesh"
blockMesh

echo "run foamRun"
foamRun

