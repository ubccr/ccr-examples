#!/bin/bash -l

##   This file is intended to serve as a template to be downloaded and modified for your use case.
##   For more information, refer to the following resources whenever referenced in the script-
##   README-https://github.com/ubccr/ccr-examples/tree/main/README.md
##   DOCUMENTATION- https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#job-arrays

##   Select a cluster, partition, qos and account that is appropriate for your use case
##   Available options and more details are provided in README
#SBATCH --cluster=[cluster]
#SBATCH --partition=[partition]
#SBATCH --qos=[qos]
#SBATCH --account=[SlurmAccountName]

##   Job runtime limit. Format- dd:hh:mm
#SBATCH --time=01:00:00

##   Number of nodes
#SBATCH --nodes=1

##   Specify the number of tasks (for parallelism)
#SBATCH --ntasks-per-node=4

#SBATCH --job-name="test-array"

##  Specify what jobs in the array will run
#SBATCH --array=0-3

##  Output files format
#SBATCH --output="slurm-%A_%a.out"

sleep 100
echo "Hello World from job ${SLURM_ARRAY_JOB_ID}, task ${SLURM_ARRAY_TASK_ID} on node:"`/usr/bin/uname -n`
