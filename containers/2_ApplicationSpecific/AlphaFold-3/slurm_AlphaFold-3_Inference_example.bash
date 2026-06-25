#!/bin/bash -l

## This file is intended to serve as a template to be downloaded and modified for your use case.
## For more information, refer to the following resources whenever referenced in the script-
## README- https://github.com/ubccr/ccr-examples/tree/main/README.md
## DOCUMENTATION- https://docs.ccr.buffalo.edu/en/latest/hpc/jobs

## Select a cluster, partition, qos and account that is appropriate for your use case
## Available options and more details are provided in README
#SBATCH --cluster="[cluster]"
#SBATCH --partition="[partition]"
#SBATCH --qos="[qos]"
#SBATCH --account="[SlurmAccountName]"

## NOTE: This is tested with the ccrsoft/2024.04 software release

## Job runtime limit, the job will be canceled once this limit is reached. Format- dd-hh:mm:ss
#SBATCH --time=00:30:00

## The processing is on the GPU, we only need a few cores to run apptainer
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --gpus-per-node=1

#SBATCH --mem=90G

## change to the AlphaFold-3 directory
cd /projects/academic/[YourGroupName]/AlphaFold-3

echo "Running the Inference on compute node: $(hostname -s)"
echo "GPU info:"
nvidia-smi -L 

# AlphaFold_Inference_Input_Dir must be defined with the input dir
if [ "${AlphaFold_Inference_Input_Dir}" = "" ] || [ ! -d "${AlphaFold_Inference_Input_Dir}" ]
then
  echo "The \"AlphaFold_Inference_Input_Dir\" environment variable must be defined" >&2
  echo "and must contain the path the path to the AlphaFold Inference Input directory" >&2
  exit 1
fi

echo "Running Inference with the input directory \"${AlphaFold_Inference_Input_Dir}\""

## Run the Inference
apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --nv \
 ./AlphaFold-3-$(arch).sif \
 python3 "/app/alphafold/run_alphafold.py" \
 --db_dir="/util/software/data/alphafold3/" \
 --model_dir="./models" \
 --input_dir="${AlphaFold_Inference_Input_Dir}" \
 --force_output_dir \
 --output_dir="./af_output" \
 --norun_data_pipeline \
 --run_inference \
 \${ALPHAFOLD3_EXTRA_OPTIONS}

