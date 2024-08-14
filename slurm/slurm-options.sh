#!/bin/bash -l
##
##   How long do you want to reserve the node(s) for?  By default, if you don't specify,
##   you will get 24 hours.  Referred to as walltime, this is how long the job will be
##   scheduled to run for once it begins. If your program runs longer than what is
##   requested here, the job will be cancelled by Slurm when time runs out.
##   If you make the expected time too long, it may take longer for resources to 
##   become available and for the job to start.  The various partitions in CCR's
##   clusters have various maximum walltimes.  Refer to the documentation for more info.

##   Format: dd:hh:mm:ss
#SBATCH --time=00:01:00

#   Define how many nodes you need. We ask for 1 node
#SBATCH --nodes=1

#   You can define the number of Cores with --cpus-per-task
#SBATCH --cpus-per-task=32

#   Specify the real memory required per node.  Default units are megabytes.  
#   Different units can be specified using the suffix  [K|M|G|T]  
#SBATCH --mem=20G

#   Give your job a name, so you can recognize it in the queue
#SBATCH --job-name="example-debug-job"

#   Tell slurm the name of the file to write to
#SBATCH --output=example-debug-job.out

#   Tell slurm where to send emails about this job
#SBATCH --mail-user=myemailaddress@institution.edu

#   Tell slurm the types of emails to send.
#   Options: NONE, BEGIN, END, FAIL, ALL  
#SBATCH --mail-type=end

#   Tell Slurm which cluster, partition and qos to use to schedule this job.  
#SBATCH --cluster=ub-hpc
OR
#SBATCH --cluster=faculty

# Refer to documentation on what partitions are available and determining what you have access to
#SBATCH --partition=[partition_name]

# QOS usually matches partition name but some users have access to priority boost QOS values.
#SBATCH --qos=[qos]

# For more Slurm directives, refer to the Slurm documentation https://slurm.schedmd.com/documentation.html