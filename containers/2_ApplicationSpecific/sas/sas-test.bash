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
#SBATCH --time=00:30:00

##   Refer to DOCUMENTATION for details on the next two directives

##   Specify the number of tasks (for parallelism)
#SBATCH --ntasks=1

##   Allocate CPUs per task
#SBATCH --cpus-per-task=4

##   Specify real memory required per node. Default units are megabytes
#SBATCH --mem=10000

##   Run SAS using a SAS script inside the Apptainer container
apptainer exec -B /scratch:/scratch /[path-to-container]/sas94.sif /usr/local/SASHome/SASFoundation/9.4/sas ~/myjob.sas -log ~/sasoutput.log
