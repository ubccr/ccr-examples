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
## jackhmmer and nhmmer don't scale beyond 8 cores, so no point requesting more CPU cores
#SBATCH --cpus-per-task=12
## This example only uses one GPU
#SBATCH --gpus-per-node=1
#SBATCH --mem=92GB

## Job runtime limit, the job will be canceled once this limit is reached. Format- dd-hh:mm:ss
#SBATCH --time=01:00:00

## change to the OpenFold directory
cd /projects/academic/[YourGroupName]/OpenFold

## Make sure the top output directory exist
mkdir -p ./output

###############################################################################
# OpenFold container setup
###############################################################################
if [ "${APPTAINER_NAME}" = "" ]
then
  # Launch the container with this script
  exec apptainer run \
   --writable-tmpfs \
  -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
  -B /util/software/data/OpenFold:/data \
  -B /util/software/data/alphafold:/database \
  -B /util/software/data/OpenFold/openfold_params:/opt/openfold/openfold/resources/openfold_params \
  -B /util/software/data/alphafold/params:/opt/openfold/openfold/resources/params \
  -B "$(pwd)/output":/output \
  --nv \
  OpenFold-$(arch).sif \
   bash "$(scontrol show job $SLURM_JOB_ID | awk -F= '/Command=/{print $2}')"
fi
# Inside the container - OpenFold setup:
export TRITON_CACHE_DIR="${SLURMTMPDIR}"
###############################################################################

# You can run the same OpenFold commands you would run from
# the "Apptainer> " prompt here:

echo "Running OpenFold on compute node: $(hostname -s)"
echo "GPU info:"
nvidia-smi -L 

# Get the example from the OpenFold GitHub repo
pushd "${SLURMTMPDIR}" > /dev/null
git clone https://github.com/aqlaboratory/openfold.git
mv openfold/examples/ ./examples/
rm -rf openfold
popd > /dev/null

# make the output dir for this job
mkdir -p /output/PDB_6KWC/pre-computed_alignments

## Run the OpenFold example from the GitHub sources
python3 "${OF_DIR}/run_pretrained_openfold.py" \
 --hhblits_binary_path "/opt/conda/bin/hhblits" \
 --hmmsearch_binary_path "/opt/conda/bin/hhsearch" \
 --hmmbuild_binary_path "/opt/conda/bin/hmmbuild" \
 --kalign_binary_path "/opt/conda/bin/kalign" \
 --model_device cuda \
 --data_random_seed $(((RANDOM<<15)|(RANDOM + 1))) \
 --use_precomputed_alignments "${SLURMTMPDIR}/examples/monomer/alignments" \
 --output_dir /output/PDB_6KWC/pre-computed_alignments \
 --config_preset model_1_ptm \
 --jax_param_path "${OF_DIR}/openfold/resources/params/params_model_1_ptm.npz" \
 "${SLURMTMPDIR}/examples/monomer/fasta_dir" \
 "/data/pdb_data/mmcif_files"

if [ "$?" = "0" ]
then
  echo
  echo "Model inference with pre-computed alignments completed"
else
  echo
  echo "Model inference with pre-computed alignments FAILED!" >&2
fi

