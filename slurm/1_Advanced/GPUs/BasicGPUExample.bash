#!/bin/bash -l

##   This file is intended to serve as a template to be downloaded and modified for your use case.
##   For more information, refer to the following resources whenever referenced in the script-
##   README-https://github.com/ubccr/ccr-examples/tree/main/README.md
##   DOCUMENTATION- https://docs.ccr.buffalo.edu/en/latest/hpc/jobs

##   Select a cluster, partition, qos and account that is appropriate for your use case
##   Available options and more details are provided in README
#SBATCH --cluster=[cluster]
#SBATCH --partition=[partition]
#SBATCH --qos=[qos]
#SBATCH --account=[SlurmAccountName]

##   Job runtime limit. Format- dd:hh:mm
#SBATCH --time=00:10:00

##   Number of nodes
#SBATCH --nodes=1

##   Number of gpus per node. Refer to snodes output for breakdown of node capabilities
#SBATCH --gpus-per-node=1

##   Send email on job start, end, fault and Valid email for Slurm to send notifications - "mail-user"
#SBATCH --mail-type=end
#SBATCH --mail-user=UBITusername@buffalo.edu
