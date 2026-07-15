#!/bin/bash -l

##   This file is intended to serve as a template to be downloaded and modified for your use case.
##   For more information, refer to the following resources whenever referenced in the script-
##   README- https://github.com/ubccr/ccr-examples/tree/main/README.md
##   DOCUMENTATION- https://docs.ccr.buffalo.edu/en/latest/hpc/jobs
##   GROMACS README- https://github.com/ubccr/ccr-examples/tree/main/slurm/2_ApplicationSpecific/GROMACS/README.md
##   GPU DOCUMENTATION- https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#slurm-directives-partitions-qos

##   Select a cluster, partition, qos and account that is appropriate for your use case
##   Available options and more details are provided in README
#SBATCH --cluster=[cluster]
#SBATCH --partition=[partition]
#SBATCH --qos=[qos]
#SBATCH --account=[SlurmAccountName]

##   Job runtime limit, the job will be canceled once this limit is reached. Format- dd:hh:mm
#SBATCH --time=01:00:00

##   Refer to DOCUMENTATION for details on the next three directives

##   Specify the number of tasks (make sure to adjust according to your node configuration)
#SBATCH --ntasks=1

#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2

## If using more than 1 node, use this constraint:
##SBATCH --constraint="[SAPPHIRE-RAPIDS-IB|ICE-LAKE-IB|CASCADE-LAKE-IB|EMERALD-RAPIDS-IB]"

#SBATCH --job-name=water-1536
#SBATCH --output=gromacs.out

echo "SLURM_JOB_ID="$SLURM_JOB_ID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=$SLURM_NNODES
echo "SLURMTMPDIR="$SLURMTMPDIR

echo "working directory = "$SLURM_SUBMIT_DIR
module load foss gromacs/2023.1-CUDA-11.8.0
module list
#
echo "Launch GROMACS with srun"
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export | grep SLURM

## Fetch the data (Refer to GROMACS README for more details)

## CPU single node
gmx mdrun -ntmpi ${SLURM_NTASKS} -ntomp ${SLURM_CPUS_PER_TASK} -resethway -npme 0 -notunepme -noconfout -nsteps 1000 -v -s  bench.tpr

## CPU multi node
srun --mpi=pmix gmx_mpi mdrun -resethway -npme 0 -notunepme -noconfout -nsteps 1000 -v -s  bench.tpr < /dev/null

## GPU single node
gmx mdrun -ntmpi ${SLURM_NTASKS} -ntomp ${SLURM_CPUS_PER_TASK} -resethway -noconfout -nsteps 6000 -v -pin on -nb gpu -s bench.tpr

## Single GPU multi node
srun --mpi=pmix gmx_mpi mdrun -ntomp ${SLURM_CPUS_PER_TASK} -resethway -noconfout -nsteps 6000 -v -pin on -nb gpu -s bench.tpr < /dev/null

## Multi GPU single node
gmx mdrun -ntmpi ${SLURM_NTASKS} -ntomp ${SLURM_CPUS_PER_TASK} -resethway -noconfout -nsteps 6000 -v -pin on -nb gpu -s bench.tpr

#
echo "All Done!"
