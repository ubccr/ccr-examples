#!/bin/sh
#SBATCH --partition=general-compute
#SBATCH --qos=general-compute
#SBATCH --time=3:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --job-name="R"
#SBATCH --mail-user=<your-email>
#SBATCH --mail-type=END

echo "SLURM_JOBID="$SLURM_JOBID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=$SLURM_NNODES
echo "SLURMTMPDIR="$SLURMTMPDIR
echo "working directory = "$SLURM_SUBMIT_DIR

NPROCS=`srun --nodes=${SLURM_NNODES} bash -c 'hostname' |wc -l`
echo "NPROCS="$NPROCS
module load gcc/11.2.0  openmpi/4.1.1 r/4.2.0 r-bundle-bioconductor/3.15-R-4.2.0  
  
R < ex.edgeR --no-save 

echo "All done!"
#
