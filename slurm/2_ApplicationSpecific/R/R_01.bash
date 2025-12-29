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

##  Job runtime limit. Format- dd:hh:mm
#SBATCH --time=3:00:00

##   Number of nodes
#SBATCH --nodes=1

##   Specify the number of tasks (for parallelism)
#SBATCH --ntasks-per-node=1

##   Allocate CPUs per task (>1 if multi-threaded tasks)
#SBATCH --cpus-per-task=1

##   Memory per cpu-core (4G per cpu-core is default)
#SBATCH --mem-per-cpu=4G

#SBATCH --job-name="R"

##   Send email on job start, end, fault and a Valid email for Slurm to send notifications - "mail-user"
#SBATCH --mail-user=<your email>
#SBATCH --mail-type=END

##   Load R bioconductor module for edgeR library 
module load gcc/11.2.0 openmpi/4.1.1 r-bundle-bioconductor/3.15-R-4.2.0  

##   Run R script. The following is one of a few ways to launch R scripts
R < ex.edgeR --no-save 

echo "All done!"

