#!/bin/bash -l

##   This file is intended to serve as a template to be downloaded and modified for your use case.
##   For more information, refer to the following resources whenever referenced in the script-
##   README- https://github.com/ubccr/ccr-examples/tree/main/README.md
##   DOCUMENTATION- https://docs.ccr.buffalo.edu/en/latest/hpc/jobs
##   GPU DOCUMENTATION- https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#slurm-directives-partitions-qos

##   Select a cluster, partition, qos and account that is appropriate for your use case
##   Available options and more details are provided in README
#SBATCH --cluster=[cluster]
#SBATCH --partition=[partition]
#SBATCH --qos=[qos]
#SBATCH --account=[SlurmAccountName]

##   Job runtime limit, the job will be canceled once this limit is reached. Format- dd:hh:mm
#SBATCH --time=03:30:00

##   Refer to DOCUMENTATION for details on the next two directives

##   Specify the number of tasks (for parallelism)
#SBATCH --ntasks=1

##   Allocate CPUs per task
#SBATCH --cpus-per-task=32

##   Specify real memory required per node. Default units are megabytes
#SBATCH --mem=64000

##   Number of GPUs required. Specify the GPU node with the constraint option (A100, V100). 
##   See GPU DOCUMENTATION for more info
#SBATCH --gpus-per-node=2
#SBATCH --constraint=A100

module load foss alphafold

srun run_alphafold.py --fasta_paths=T1050.fasta --max_template_date=2020-05-14 --model_preset=monomer --db_preset=full_dbs --output_dir=output
