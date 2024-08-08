#!/bin/bash -l
#SBATCH --job-name=main
#SBATCH --output=output.log
#SBATCH --error=output.err
#SBATCH --mail-type=END
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=debug
#SBATCH --qos=debug
#SBATCH --mem=64000
#SBATCH --tasks-per-node=16

module load ansys
export LSTC_LICENSE=ansys
echo $SLURM_NPROCS

# For single precision use this
$EBROOTANSYS/v231/ansys/bin/linx64/lsdyna_sp.e ncpus=$SLURM_NPROCS i=ball_and_plate.k

# For double precision use this
#$EBROOTANSYS/v231/ansys/bin/linx64/lsdyna_dp.e ncpus=$SLURM_NPROCS i=ball_and_plate.k

echo 'all done'
exit

