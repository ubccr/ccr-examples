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

##   Specify number of  nodes  
#SBATCH --nodes=1  

##   Requesting infiniband network
##   Uncomment next line if you're running on more than one node  
##SBATCH --constraint="[SAPPHIRE-RAPIDS-IB|ICE-LAKE-IB|CASCADE-LAKE-IB|EMERALD-RAPIDS-IB]"

##   Specify the number of tasks (for parallelism)
#SBATCH --ntasks=3

##  Tasks per node.  Uncomment next line and edit appropriately
##  if you want to split up the tasks in a certain way across the nodes
##SBATCH --ntasks-per-node=3

##   Specify real memory required per node. Default units are megabytes
#SBATCH --mem=6000

##   Run FDS using a batch script inside the Apptainer container

module load intel
export I_MPI_PMI_LIBRARY=/opt/software/slurm/lib64/libpmi.so
mpirun -np $SLURM_NTASKS apptainer exec -B /scratch:/scratch /[path-to-container]/fds_6.7.9.sif fas radiator.fds
