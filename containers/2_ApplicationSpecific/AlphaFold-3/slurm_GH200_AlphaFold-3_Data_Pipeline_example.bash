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
#SBATCH --time=01:00:00

## jackhmmer and nhmmer don't scale beyond 8 cores.  The Jackhmmer searches
## are run in parallel against 4 databases, so the Data Pipeline will scale up
## to 32 cores (allocating more cores will not increase performance.)
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=32

## The Data Pipeline does benefit from RAM, so allocate all the memory on the
## node.
#SBATCH --exclusive
#SBATCH --mem=0

## change to the AlphaFold-3 directory
cd /projects/academic/[YourGroupName]/AlphaFold-3

# Set the input directory
input_dir="./af_input/2PV7"

echo "Running the Data Pipeline on compute node: $(hostname -s)"

## Make sure the top output directories exist
mkdir -p ./af_input_inference ./af_output

## Run the Data Pipeline
apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 ./AlphaFold-3-$(arch).sif \
 python3 "/app/alphafold/run_alphafold.py" \
 --db_dir="/util/software/data/alphafold3/" \
 --model_dir="./models" \
 --input_dir="${input_dir}" \
 --force_output_dir \
 --output_dir="./af_input_inference" \
 --run_data_pipeline \
 --norun_inference

if [ "$?" != "0" ]
then
  echo "Data Pipeline failed - NOT running Inference" 
  exit 1
fi

## get the output directory name for the Inference run
AlphaFold_Inference_Input_Dir="$(apptainer exec -B ,/projects:/projects ./AlphaFold-3-$(arch).sif python3 -c "exec(open('/app/alphafold/src/alphafold3/common/folding_input.py', 'r').read()); inference_input_dir = Input(name=\"$(jq -r '.name' "${input_dir}/"*.json)\", chains=[], rng_seeds=[0]); print ('./af_input_inference/' + inference_input_dir.sanitised_name())" 2>&1 | tail -1)"

## submit an Inference job with the output from this Data Pipeline run
echo "Submitting Inference job with the input directory \"${AlphaFold_Inference_Input_Dir}\""
sbatch \
 --export=HOME,TERM,SHELL,AlphaFold_Inference_Input_Dir="${AlphaFold_Inference_Input_Dir}" \
 slurm_GH200_AlphaFold-3_Inference_example.bash

