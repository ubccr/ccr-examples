#!/bin/bash -l

## This file is intended to serve as a template to be downloaded and modified
## for your use case.
##
## For more information, refer to:
## README - https://github.com/ubccr/ccr-examples/tree/main/slurm/README.md
## DOCUMENTATION - https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/

## Select a cluster, partition, QOS, and account appropriate for your use case.
#SBATCH --cluster=[cluster]
#SBATCH --partition=[partition]
#SBATCH --qos=[qos]
#SBATCH --account=[SlurmAccountName]

## Job runtime limit. The job will be canceled once this limit is reached.
## Format: dd:hh:mm
#SBATCH --time=00:10:00

## Refer to DOCUMENTATION for details on the next three directives.

## Specify the number of compute nodes.
#SBATCH --nodes=2

## Specify the number of MPI tasks to run on each node.
#SBATCH --ntasks-per-node=4

## Specify the number of CPU cores assigned to each MPI task.
#SBATCH --cpus-per-task=1

## Memory requested per node, in megabytes.
#SBATCH --mem=4000

## Job name and output file.
#SBATCH --job-name=lammps-example
#SBATCH --output=lammps-example-%j.out

## Print basic Slurm job information.
echo "SLURM_JOB_ID="$SLURM_JOB_ID
echo "SLURM_JOB_NODELIST="$SLURM_JOB_NODELIST
echo "SLURM_NNODES="$SLURM_NNODES
echo "SLURMTMPDIR="$SLURMTMPDIR
echo "working directory="$SLURM_SUBMIT_DIR

## Load the required software modules.
module load gcc/11.2.0 openmpi/4.1.1
module load lammps/23Jun2022-kokkos
module list

## Set the number of OpenMP threads to the number of CPUs assigned per task.
## If SLURM_CPUS_PER_TASK is not defined, use one thread.
export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK:-1}

## Print the Slurm environment variables to the job output.
export | grep SLURM

## Run LAMMPS using the included input file.
## Replace in.lammps with the name or path of your own input file as needed.
srun lmp -nocite -screen none -in in.lammps \
    -log lammps-example-$SLURM_JOBID.log

echo "All Done!"
