#!/bin/bash -l

## This file is intended to serve as a template to be downloaded and modified for your use case.
## For more information, refer to the following resources whenever referenced in the script-
## README- https://github.com/ubccr/ccr-examples/tree/main/slurm/README.md
## DOCUMENTATION- https://docs.ccr.buffalo.edu/en/latest/hpc/jobs

## NOTE: This Slurm script was tested with the ccrsoft/2024.04 software release

## Select a cluster, partition, qos and account that is appropriate for your use case
## Available options and more details are provided in CCR's documentation:
##   https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#slurm-directives-partitions-qos
#SBATCH --cluster="[cluster]"
#SBATCH --partition="[partition]"
#SBATCH --qos="[qos]"
#SBATCH --account="[SlurmAccountName]"

#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=4
## BindCraft only uses one GPU
#SBATCH --gpus-per-node=1
#SBATCH --mem=64GB

## Job runtime limit, the job will be canceled once this limit is reached. Format- dd-hh:mm:ss
#SBATCH --time=3-00:00:00

## change to the BindCraft directory
cd /projects/academic/[YourGroupName]/BindCraft

## Make sure the top input and output directories exist
mkdir -p ./input ./output

echo "Running BindCraft on compute node: $(hostname -s)"

settings_file="./input/PDL1.json"

# create the settings JSON file
cat > "${settings_file}" << EOF
{
    "design_path": "/work/output/pdl1/",
    "binder_name": "PDL1",
    "starting_pdb": "/app/example/PDL1.pdb",
    "chains": "A",
    "target_hotspot_residues": "56",
    "lengths": [65, 150],
    "number_of_final_designs": 100
}
EOF

# make sure the output directory for this job exists using the
# "design_path" entry from the settings file
output_dir="$(jq -r .design_path "${settings_file}")"
if [ "${output_dir}" = "" ]
then
  echo "Check the the settings file \"${settings_file}\" - \"design_path\" not configured" >&2
  exit 1
fi 
apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 -B ./input:/work/input,./output:/work/output \
 --nv \
 ./BindCraft-$(arch).sif \
 mkdir -p "${output_dir}" > /dev/null
if [ "$?" != "0" ]
then
  echo "Failed to creat the BindCraft output dir \"${output_dir}\" = bailing" >&2
  exit 1
fi

apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 -B /util/software/data/alphafold/params:/app/params \
 -B ./input:/work/input,./output:/work/output \
 --nv \
 ./BindCraft_with_PyRosetta-x86_64.sif \
 python3 /app/bindcraft.py \
  --settings "${settings_file}" \
  --filters /app/settings_filters/default_filters.json \
  --advanced /app/settings_advanced/default_4stage_multimer.json

if [ "$?" = "0" ]
then
  echo
  echo "BindCraft run completed successfully"
else
  echo
  echo "WARNING: BindCraft run FAILED!" >&2
fi

