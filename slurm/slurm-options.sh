#!/bin/bash -l
##
## How long do you want to reserve the node(s) for?  By default, if you don't specify,
## you will get 24 hours.  Referred to as walltime, this is how long the job will be
## scheduled to run for once it begins. If your program runs longer than what is
## requested here, the job will be cancelled by Slurm when time runs out.
## If you make the expected time too long, it may take longer for resources to 
## become available and for the job to start.  The various partitions in CCR's
## clusters have various maximum walltimes.  Refer to the documentation for more info.
## Walltime Format: dd:hh:mm:ss
#SBATCH --time=00:01:00

## Define how many nodes you need. We ask for 1 node
#SBATCH --nodes=1

## Refer to docs on proper usage of next 3 Slurm directives https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#requesting-cores-and-nodes  
## Number of "tasks" (use with distributed parallelism)
#SBATCH --ntasks=12

## Number of "tasks" per node (use with distributed parallelism)
#SBATCH --ntasks-per-node=12

## Number of CPUs allocated to each task (use with shared memory parallelism)
#SBATCH --cpus-per-task=32

## Specify the real memory required per node.  Default units are megabytes.  
## Different units can be specified using the suffix  [K|M|G|T]  
#SBATCH --mem=20G

## Give your job a name, so you can recognize it in the queue
#SBATCH --job-name="example-debug-job"

## Tell slurm the name of the file to write to. If not specified, output files are named output.log and output.err
#SBATCH --output=example-job.out
#SBATCH --error=example-job.err

## Tell slurm where to send emails about this job
#SBATCH --mail-user=myemailaddress@institution.edu

## Tell slurm the types of emails to send.
## Options: NONE, BEGIN, END, FAIL, ALL  
#SBATCH --mail-type=end

## Tell Slurm which cluster, partition and qos to use to schedule this job.  
#SBATCH --cluster=ub-hpc
OR
#SBATCH --cluster=faculty

## Refer to documentation on what partitions are available and determining what you have access to
#SBATCH --partition=[partition_name]

## QOS usually matches partition name but some users have access to priority boost QOS values.
#SBATCH --qos=[qos]

## Request exclusive access of the node you're assigned, even if you haven't requested all of the node's resources.
## This prevents other users' jobs from running on the same node as you.  Only recommended if you're having trouble
## with network bandwidth and sharing the node is causing problems for your job.  
#SBATCH --exclusive

## Use snodes command to see node tags used to allow for requesting specific types of hardware
## such as specific GPUs, CPUs, high speed networks, or rack locations.
#SBATCH --constraint=[Slurm tag]

## Multiple options for requesting GPUs
## Request GPU - refer to snodes output for breakdown of node capabilities
#SBATCH --gpus-per-node=1

## Request a specific type of GPU
#SBATCH --gpus-per-node=1
#SBATCH --constraint=V100

## Request a specific GPU & GPU memory configuration
#SBATCH --gpus-per-node=tesla_v100-pcie-32gb:1

## Request a specific GPU, GPU memory, and GPU slot location
#SBATCH --gpus-per-node=tesla_v100-pcie-16gb:1(S:0) or (S:1)

## To use all cores on a node w/more than 1 GPU you must disable CPU binding
#SBATCH --gres-flags=disable-binding

## For more Slurm directives, refer to the Slurm documentation https://slurm.schedmd.com/documentation.html