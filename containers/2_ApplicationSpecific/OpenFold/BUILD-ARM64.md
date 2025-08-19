# Build the OpenFold container on ARM64

## Buid the ARM64 container image

Start an interactive job on an ARM64 node with a GPU

```
export SBATCH_ACCOUNT="[SlurmAccountName]"
```

```
tmp_file="$(mktemp)"
salloc --partition=arm64 --qos=arm64 --constraint=ARM64 --no-shell \
 --gpus-per-node=1 --exclusive --time=1:00:00 2>&1 | tee "${tmp_file}"
SLURM_JOB_ID="$(head -1 "${tmp_file}" | awk '{print $NF}')"
rm "${tmp_file}"
srun --jobid="${SLURM_JOB_ID}" --export=HOME,TERM,SHELL --pty /bin/bash --login
```

sample outout:

> ```
> salloc: Pending job allocation 20812210
> salloc: job 20812210 queued and waiting for resources
> salloc: job 20812210 has been allocated resources
> salloc: Granted job allocation 20812210
> salloc: Waiting for resource configuration
> salloc: Nodes cpn-f06-36 are ready for job
> CCRusername@cpn-f06-36:~$
> ```

Verify that a GPU has been allocated to the job (or the build will fail because
the nvidia tools incluing "nvcc" will not be installed.)

```
nvidia-smi -L
```

sample output:

> ````
> GPU 0: NVIDIA GH200 480GB (UUID: GPU-3ec6f59a-0684-f162-69a0-8b7ebe27a8e3)
> ```

Change to your OpenFold directory

```
cd /projects/academic/[YourGroupName]/OpenFold
```

Download the OpenFold ARM64 build files, OpenFold-aarch64.def and
environment-aarch64.yml, to this directory

```
curl -L -o OpenFold-aarch64.def https://raw.githubusercontent.com/tonykew/ccr-examples/refs/heads/OpenFold/containers/2_ApplicationSpecific/OpenFold/OpenFold-aarch64.def
curl -L -o environment-aarch64.yml https://raw.githubusercontent.com/tonykew/ccr-examples/refs/heads/OpenFold/containers/2_ApplicationSpecific/OpenFold/environment-aarch64.yml
```

Sample output:

> ```
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100  4627  100  4627    0     0  27459      0 --:--:-- --:--:-- --:--:-- 27541
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100   574  100   574    0     0   3128      0 --:--:-- --:--:-- --:--:--  3136
> ```

Set the apptainer cache dir:

```
export APPTAINER_CACHEDIR="${SLURMTMPDIR}"
```

Build your container

Note: Building the OpenFold container takes about ten minutes

```
apptainer build --build-arg SLURMTMPDIR="${SLURMTMPDIR}" \
 --build-arg SLURM_NPROCS="${SLURM_NPROCS}" -B /scratch:/scratch \
 OpenFold-$(arch).sif OpenFold-aarch64.def
```

sample truncated output:

> ```
> [....]
> INFO:    Adding environment to container
> INFO:    Creating SIF file...
> INFO:    Build complete: OpenFold-aarch64.sif
> ```

Exit the Slurm interactive session

```
exit
```

sample output:

> ```
> CCRusername@login1$ 
> ```

End the Slurm job

```
scancel "${SLURM_JOB_ID}"
unset SLURM_JOB_ID
```

## Running the container

Start an interactive job on a node with a Grace Hopper GPU e.g.

```
export SBATCH_ACCOUNT="[SlurmAccountName]"
```

```
tmp_file="$(mktemp)"
salloc --partition=arm64 --qos=arm64 --constraint=ARM64 --no-shell \
 --time=01:00:00  --nodes=1 --tasks-per-node=1 --cpus-per-task=4 \
 --gpus-per-node=1 --constraint="GH200" --mem=90G 2>&1 | tee "${tmp_file}"
SLURM_JOB_ID="$(head -1 "${tmp_file}" | awk '{print $NF}')"
rm "${tmp_file}"
srun --jobid="${SLURM_JOB_ID}" --export=HOME,TERM,SHELL --pty /bin/bash --login
```

sample outout:

> ```
> salloc: Pending job allocation 20815431
> salloc: job 20815431 queued and waiting for resources
> salloc: job 20815431 has been allocated resources
> salloc: Granted job allocation 20815431
> salloc: Waiting for resource configuration
> salloc: Nodes cpn-f06-36 are ready for job
> ```

Change to your OpenFold` directory

```
cd /projects/academic/[YourGroupName]/OpenFold
```

Create the output base directory, and an empty tuning directory for triton

```
mkdir -p ./output
mkdir -p ${HOME}/.triton/autotune
```

...then start the OpenFold container instance

```
apptainer shell \
 --writable-tmpfs \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 -B /util/software/data/OpenFold:/data \
 -B /util/software/data/alphafold:/database \
 -B /util/software/data/OpenFold/openfold_params:/opt/openfold/openfold/resources/openfold_params \
 -B /util/software/data/alphafold/params:/opt/openfold/openfold/resources/params \
 -B $(pwd)/output:/output \
 --nv \
 OpenFold-$(arch).sif
```

expected output:

> ```
> Apptainer> 
> ```

All the following commands are run from the "Apptainer> " prompt

Verify OpenFold is installed:

```
export TRITON_CACHE_DIR="${SLURMTMPDIR}"
python3 "${OF_DIR}/train_openfold.py" --help
```

Note: There may be no output for over half a minute

Abridged sample output:

> ```
> usage: train_openfold.py [-h] [--train_mmcif_data_cache_path TRAIN_MMCIF_DATA_CACHE_PATH] [--use_single_seq_mode USE_SINGLE_SEQ_MODE]
>                          [--distillation_data_dir DISTILLATION_DATA_DIR] [--distillation_alignment_dir DISTILLATION_ALIGNMENT_DIR] [--val_data_dir VAL_DATA_DIR]
>                          [--val_alignment_dir VAL_ALIGNMENT_DIR] [--val_mmcif_data_cache_path VAL_MMCIF_DATA_CACHE_PATH] [--kalign_binary_path KALIGN_BINARY_PATH]
>                          [--train_filter_path TRAIN_FILTER_PATH] [--distillation_filter_path DISTILLATION_FILTER_PATH]
>                          [--obsolete_pdbs_file_path OBSOLETE_PDBS_FILE_PATH] [--template_release_dates_cache_path TEMPLATE_RELEASE_DATES_CACHE_PATH]
>                          [--use_small_bfd USE_SMALL_BFD] [--seed SEED] [--deepspeed_config_path DEEPSPEED_CONFIG_PATH] [--checkpoint_every_epoch]
>                          [--early_stopping EARLY_STOPPING] [--min_delta MIN_DELTA] [--patience PATIENCE] [--resume_from_ckpt RESUME_FROM_CKPT]
>                          [--resume_model_weights_only RESUME_MODEL_WEIGHTS_ONLY] [--resume_from_jax_params RESUME_FROM_JAX_PARAMS]
>                          [--log_performance LOG_PERFORMANCE] [--wandb] [--experiment_name EXPERIMENT_NAME] [--wandb_id WANDB_ID] [--wandb_project WANDB_PROJECT]
>                          [--wandb_entity WANDB_ENTITY] [--script_modules SCRIPT_MODULES] [--train_chain_data_cache_path TRAIN_CHAIN_DATA_CACHE_PATH]
>                          [--distillation_chain_data_cache_path DISTILLATION_CHAIN_DATA_CACHE_PATH] [--train_epoch_len TRAIN_EPOCH_LEN] [--log_lr]
>                          [--config_preset CONFIG_PRESET] [--_distillation_structure_index_path _DISTILLATION_STRUCTURE_INDEX_PATH]
>                          [--alignment_index_path ALIGNMENT_INDEX_PATH] [--distillation_alignment_index_path DISTILLATION_ALIGNMENT_INDEX_PATH]
>                          [--experiment_config_json EXPERIMENT_CONFIG_JSON] [--gpus GPUS] [--mpi_plugin] [--num_nodes NUM_NODES] [--precision PRECISION]
>                          [--max_epochs MAX_EPOCHS] [--log_every_n_steps LOG_EVERY_N_STEPS] [--flush_logs_every_n_steps FLUSH_LOGS_EVERY_N_STEPS]
>                          [--num_sanity_val_steps NUM_SANITY_VAL_STEPS] [--reload_dataloaders_every_n_epochs RELOAD_DATALOADERS_EVERY_N_EPOCHS]
>                          [--accumulate_grad_batches ACCUMULATE_GRAD_BATCHES]
>                          train_data_dir train_alignment_dir template_mmcif_dir output_dir max_template_date
> [...]
> ```

Exit the Apptainer container instance

```
exit
```

sample outout:

> ```
> CCRusername@cpn-f06-36$ 
> ```

Exit the Slurm interactive session

```
exit
```

sample output:

> ```
> CCRusername@login1$ 
> ```

End the Slurm job

```
scancel "${SLURM_JOB_ID}"
unset SLURM_JOB_ID
```

