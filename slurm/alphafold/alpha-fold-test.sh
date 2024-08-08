#!/bin/bash -l

#SBATCH --qos=general-compute
#SBATCH --clusters=ub-hpc
#SBATCH --time=03:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=64000
#SBATCH --gpus-per-node=2
#SBATCH --constraint=A100

module load foss alphafold

srun run_alphafold.py --fasta_paths=T1050.fasta --max_template_date=2020-05-14 --model_preset=monomer --db_preset=full_dbs --output_dir=output
