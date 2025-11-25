#!/bin/bash -l

##   This file is intended to serve as a template to be downloaded and modified for your use case.
##   For more information, refer to the following resources whenever referenced in the script-
##   README- https://github.com/ubccr/ccr-examples/tree/main/slurm/README.md
##   DOCUMENTATION- https://docs.ccr.buffalo.edu/en/latest/hpc/jobs

##   Select a cluster, partition, qos and account that is appropriate for your use case
##   Available options and more details are provided in README
#SBATCH --cluster=[cluster]
#SBATCH --partition=[partition]
#SBATCH --qos=[qos]
#SBATCH --account=[SlurmAccountName]

##   Job runtime limit, the job will be canceled once this limit is reached. Format- dd:hh:mm
#SBATCH --time=00:01:00

##   Number of "tasks" (for parallelism). Refer to DOCUMENTATION for more details
#SBATCH --ntasks=1

##   Specify real memory required per node. Default units are megabytes
#SBATCH --mem=20G

##   Let's start some work
echo "Hello world: "`/usr/bin/uname -n`
##   Let's finish some work
