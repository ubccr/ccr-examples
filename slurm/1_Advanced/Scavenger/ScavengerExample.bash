#!/bin/bash -l

##   This file is intended to serve as a template to be downloaded and modified for your use case.
##   For more information, refer to the following resources whenever referenced in the script-
##   README-https://github.com/ubccr/ccr-examples/tree/main/README.md
##   DOCUMENTATION- https://docs.ccr.buffalo.edu/en/latest/hpc/jobs

##   Select a cluster and account that is appropriate for your use case
##   Available options and more details are provided in README
#SBATCH --cluster=[cluster]
#SBATCH --account=[SlurmAccountName]

##   Select the scavenger partition and qos
#SBATCH --partition=scavenger
#SBATCH --qos=scavenger

##   Job runtime limit. Format- dd:hh:mm
#SBATCH --time=00:01:00

##   Refer to DOCUMENTATION for details on the next four directives

##   Number of nodes
#SBATCH --nodes=1

##   Specify the number of tasks per node
#SBATCH --ntasks-per-node=1

##   Allocate CPUs per task
#SBATCH --cpus-per-task=1

##   Specify real memory required per node. Default units are megabytes
#SBATCH --mem=10G

##   Name your job and specify where to write the output log
#SBATCH --job-name="example-general-compute-scavenger-job"
#SBATCH --output="example-general-compute-scavenger-job.out"

##   Send email on job start, end, fault and Valid email for Slurm to send notifications - "mail-user"
#SBATCH --mail-type=end
#SBATCH --mail-user=UBITusername@buffalo.edu

##   Let's start some work
echo "Hello world from scavenger node: "`/usr/bin/uname -n`
##   Let's finish some work
