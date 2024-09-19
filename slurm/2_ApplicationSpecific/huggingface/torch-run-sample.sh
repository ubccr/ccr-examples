#!/bin/bash -l

#SBATCH --partition=general-compute
#SBATCH --qos=general-compute
#SBATCH --clusters=ub-hpc
#SBATCH --time=01:00:00
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=12G
#SBATCH --gpus-per-node=2

module load foss pytorch transformers

echo "START TIME: $(date)"

# Set this to some place in your projects space. Defaults to scratch
hf_cache_dir=$SLURMTMPDIR

# Define huggingface cache directories to avoid going over quota in $HOME
export TRANSFORMERS_CACHE=$hf_cache_dir/models
export HF_DATASETS_CACHE=$hf_cache_dir/datasets
export HF_MODULES_CACHE=$hf_cache_dir/modules
export HF_METRICS_CACHE=$hf_cache_dir/metrics

MASTER_ADDR=$(scontrol show hostnames $SLURM_JOB_NODELIST | head -n 1)

export LAUNCHER="python3 -m torch.distributed.run \
    --nproc_per_node $SLURM_GPUS_PER_NODE \
    --nnodes $SLURM_NNODES \
    --rdzv_id=$SLURM_JOB_ID \
    --rdzv_backend=static \
    --master_addr=$MASTER_ADDR \
    --max_restarts=0 \
    --tee 3 \
    "

export CMD=" \
    `pwd`/run_clm.py \
    --model_name_or_path gpt2 \
    --dataset_name wikitext \
    --dataset_config_name wikitext-2-raw-v1 \
    --do_train \
    --output_dir `pwd`/output \
    --per_device_train_batch_size 4 \
    --max_steps 200
    "

SRUN_ARGS=" \
    --wait=60 \
    --kill-on-bad-exit=1 \
    "

srun $SRUN_ARGS --jobid $SLURM_JOB_ID bash -c "$LAUNCHER --node_rank \$SLURM_PROCID $CMD"

echo "END TIME: $(date)"
