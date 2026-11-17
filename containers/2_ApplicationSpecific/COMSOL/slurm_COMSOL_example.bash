#!/bin/bash -l

## This file is intended to serve as a template to be downloaded and modified for your use case.
## For more information, refer to the following resources whenever referenced in the script-
## README- https://github.com/ubccr/ccr-examples/tree/main/slurm/README.md
## DOCUMENTATION- https://docs.ccr.buffalo.edu/en/latest/hpc/jobs

## Select a cluster, partition, qos and account that is appropriate for your use case
## Available options and more details are provided in CCR's documentation:
##   https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#slurm-directives-partitions-qos
#SBATCH --cluster="[cluster]"
#SBATCH --partition="[partition]"
#SBATCH --qos="[qos]"
#SBATCH --account="[SlurmAccountName]"

## Job Name
#SBATCH --job-name="COMSOL test"

## Job runtime limit, the job will be canceled once this limit is reached. Format- dd-hh:mm:ss
#SBATCH --time=00:10:00

#SBATCH --nodes=1                       # one node
#SBATCH --tasks-per-node=1              # one task
#SBATCH --cpus-per-task=16              # sixteen cores per task
#SBATCH --mem=64G                       # 64GB RAM

## change to the COMSOL directory
cd /projects/academic/[YourGroupName]/COMSOL

mph_file="hi_batch_reactor.mph"

# Download the COMSOL HI Batch Reactor example showing errors only
curl -LO --no-progress-meter --fail-with-body "https://www.comsol.com/model/download/1528251/${mph_file}"
curl -LO --no-progress-meter --fail-with-body "https://www.comsol.com/model/download/1528271/hi_batch_reactor_parameters.txt"
curl -LO --no-progress-meter --fail-with-body "https://www.comsol.com/model/download/1528281/hi_batch_reactor_variables.txt"

# Show the currently allocated license usage for the licenses we need to
# run this simulation in batch mode
echo "Liceses in use before the run:"
apptainer run \
 --bind /projects/academic/[YourGroupName]/COMSOL/COMSOL-SENS-license.dat:/COMSOL/license/license.dat:ro \
 --bind "${SLURMTMPDIR}":"${SLURMTMPDIR}" \
 /util/software/containers/x86_64/COMSOL64-x86_64.sif \
 lmstat -c /COMSOL/license/license.dat -a | grep -E \
 "(COMSOLUSER$(echo $(apptainer run \
  --bind /projects/academic/[YourGroupName]/COMSOL/COMSOL-SENS-license.dat:/COMSOL/license/license.dat:ro \
  --bind "${SLURMTMPDIR}":"${SLURMTMPDIR}" \
  /util/software/containers/x86_64/COMSOL64-x86_64.sif \
  comsol batch -tmpdir "${SLURMTMPDIR}" -np 1 -checklicense "${mph_file}" | while read lic
  do
    echo "|${lic}BATCH"
  done) | sed 's/ //g')):"
echo

# Create the output directory
mkdir -p ./output/

# Run the simulation
apptainer run --nv --writable-tmpfs \
 --bind /util:/util,/scratch:/scratch \
 --bind /vscratch/grp-ccradmintest:/vscratch/grp-ccradmintest \
 --bind /projects/academic/[YourGroupName]:/projects/academic/[YourGroupName] \
 --bind /projects/academic/[YourGroupName]/COMSOL/COMSOL-SENS-license.dat:/COMSOL/license/license.dat:ro \
 /util/software/containers/x86_64/COMSOL64-x86_64.sif \
 comsol -tmpdir "${SLURMTMPDIR}" -np $(expr ${SLURM_CPUS_PER_TASK} - 4) \
 -usebatchlic batch \
 -inputfile "${mph_file}" \
 -outputfile "./output/$(echo "${mph_file}" | sed 's/\.mph$/_output.mph/')"
echo

# list the contents of the output directory
echo "content of the ./output directory:"
ls -l ./output/

