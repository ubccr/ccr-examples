# Example OpenFold container

## Building the container

A brief guide to building the OpenFold container follows:<br/>
Please refer to CCR's [container documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/) for more detailed information on building and using Apptainer.

NOTE: for building on the ARM64 platform see [BUILD-ARM64.md](./BUILD-ARM64.md)

1. Start an interactive job

Apptainer is not available on the CCR login nodes and the compile nodes may not provide enough resources for you to build a container.  We recommend requesting an interactive job on a compute node to conduct this build process.<br/>
Note: a GPU is NOT needed to build the OpenFold container<br/>
See CCR docs for more info on [running jobs](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission)

```
export SBATCH_ACCOUNT="[SlurmAccountName]"
```

```
salloc --cluster=ub-hpc --partition=debug --qos=debug --mem=0 --exclusive \
 --time=01:00:00
```

sample outout:

> ```
> salloc: Pending job allocation 19781052
> salloc: job 19781052 queued and waiting for resources
> salloc: job 19781052 has been allocated resources
> salloc: Granted job allocation 19781052
> salloc: Nodes cpn-i14-39 are ready for job
> CCRusername@cpn-i14-39:~$ 
> ```

2. Navigate to your build directory and use the Slurm job local temporary directory for cache

You should now be on the compute node allocated to you.  In this example we're using our project directory for our build directory.  Ensure you've placed your `OpenFold.def` file in your build directory

Change to your OpenFold directory

```
cd /projects/academic/[YourGroupName]/OpenFold
```

Download the OpenFold build files, Openfold.def and environment.yml to this directory

```
curl -L -o OpenFold.def https://raw.githubusercontent.com/tonykew/ccr-examples/refs/heads/OpenFold/containers/2_ApplicationSpecific/OpenFold/OpenFold.def
curl -L -o environment.yml https://raw.githubusercontent.com/tonykew/ccr-examples/refs/heads/OpenFold/containers/2_ApplicationSpecific/OpenFold/environment.yml
```

Sample output:

> ```
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100  3534  100  3534    0     0  63992      0 --:--:-- --:--:-- --:--:-- 64254
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100   767  100   767    0     0  11406      0 --:--:-- --:--:-- --:--:-- 11447
> ```

3. Build your container

Set the apptainer cache dir:

```
export APPTAINER_CACHEDIR="${SLURMTMPDIR}"
```

Building the OpenFold container takes about half an hour...

```
apptainer build --build-arg SLURMTMPDIR="${SLURMTMPDIR}" \
 --build-arg SLURM_NPROCS="${SLURM_NPROCS}" -B /scratch:/scratch \
 OpenFold-$(arch).sif OpenFold.def
```

Sample truncated output:

> ```
> [....]
> INFO:    Adding environment to container
> INFO:    Creating SIF file...
> INFO:    Build complete: OpenFold-x86_64.sif
> ```

## Running the container

Start an interactive job with a single GPU e.g.
NOTE: OpenFold Inference only uses one GPU

```
salloc --cluster=ub-hpc --partition=general-compute --qos=general-compute \
 --account="[SlurmAccountName]" --mem=128GB --nodes=1 --cpus-per-task=1 \
 --tasks-per-node=12 --gpus-per-node=1 --time=05:00:00
```

Change to your OpenFold directory

```
cd /projects/academic/[YourGroupName]/OpenFold
```

Create an output directory, and an empty tuning directory for triton

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

All the following commands are run from the "Apptainer> " prompt

Verify OpenFold is installed:

```
export TRITON_CACHE_DIR="${SLURMTMPDIR}"
python3 "${OF_DIR}/train_openfold.py" --help
```

Sample output:

> ```
> [2025-12-17 10:25:31,032] [WARNING] [real_accelerator.py:162:get_accelerator] Setting accelerator to CPU. If you have GPU or other accelerator, we were unable to detect it.
> [2025-12-17 10:25:31,093] [INFO] [real_accelerator.py:203:get_accelerator] Setting ds_accelerator to cpu (auto detect)
> Warning: The default cache directory for DeepSpeed Triton autotune, /user/tkewtest/.triton/autotune, appears to be on an NFS system. While this is generally acceptable, if you experience slowdowns or hanging when DeepSpeed exits, it is recommended to set the TRITON_CACHE_DIR environment variable to a non-NFS path.
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
> 
> positional arguments:
>   train_data_dir        Directory containing training mmCIF files
>   train_alignment_dir   Directory containing precomputed training alignments
>   template_mmcif_dir    Directory containing mmCIF files to search for templates
>   output_dir            Directory in which to output checkpoints, logs, etc. Ignored if not on rank 0
>   max_template_date     Cutoff for all templates. In training mode, templates are also filtered by the release date of the target
> 
> options:
>   -h, --help            show this help message and exit
>   --train_mmcif_data_cache_path TRAIN_MMCIF_DATA_CACHE_PATH
>                         Path to the json file which records all the information of mmcif structures used during training
>   --use_single_seq_mode USE_SINGLE_SEQ_MODE
>                         Use single sequence embeddings instead of MSAs.
>   --distillation_data_dir DISTILLATION_DATA_DIR
>                         Directory containing training PDB files
>   --distillation_alignment_dir DISTILLATION_ALIGNMENT_DIR
>                         Directory containing precomputed distillation alignments
>   --val_data_dir VAL_DATA_DIR
>                         Directory containing validation mmCIF files
>   --val_alignment_dir VAL_ALIGNMENT_DIR
>                         Directory containing precomputed validation alignments
>   --val_mmcif_data_cache_path VAL_MMCIF_DATA_CACHE_PATH
>                         path to the json file which records all the information of mmcif structures used during validation
>   --kalign_binary_path KALIGN_BINARY_PATH
>                         Path to the kalign binary
>   --train_filter_path TRAIN_FILTER_PATH
>                         Optional path to a text file containing names of training examples to include, one per line. Used to filter the training set
>   --distillation_filter_path DISTILLATION_FILTER_PATH
>                         See --train_filter_path
>   --obsolete_pdbs_file_path OBSOLETE_PDBS_FILE_PATH
>                         Path to obsolete.dat file containing list of obsolete PDBs and their replacements.
>   --template_release_dates_cache_path TEMPLATE_RELEASE_DATES_CACHE_PATH
>                         Output of scripts/generate_mmcif_cache.py run on template mmCIF files.
>   --use_small_bfd USE_SMALL_BFD
>                         Whether to use a reduced version of the BFD database
>   --seed SEED           Random seed
>   --deepspeed_config_path DEEPSPEED_CONFIG_PATH
>                         Path to DeepSpeed config. If not provided, DeepSpeed is disabled
>   --checkpoint_every_epoch
>                         Whether to checkpoint at the end of every training epoch
>   --early_stopping EARLY_STOPPING
>                         Whether to stop training when validation loss fails to decrease
>   --min_delta MIN_DELTA
>                         The smallest decrease in validation loss that counts as an improvement for the purposes of early stopping
>   --patience PATIENCE   Early stopping patience
>   --resume_from_ckpt RESUME_FROM_CKPT
>                         Path to a model checkpoint from which to restore training state
>   --resume_model_weights_only RESUME_MODEL_WEIGHTS_ONLY
>                         Whether to load just model weights as opposed to training state
>   --resume_from_jax_params RESUME_FROM_JAX_PARAMS
>                         Path to an .npz JAX parameter file with which to initialize the model
>   --log_performance LOG_PERFORMANCE
>                         Measure performance
>   --wandb               Whether to log metrics to Weights & Biases
>   --experiment_name EXPERIMENT_NAME
>                         Name of the current experiment. Used for wandb logging
>   --wandb_id WANDB_ID   ID of a previous run to be resumed
>   --wandb_project WANDB_PROJECT
>                         Name of the wandb project to which this run will belong
>   --wandb_entity WANDB_ENTITY
>                         wandb username or team name to which runs are attributed
>   --script_modules SCRIPT_MODULES
>                         Whether to TorchScript eligible components of them model
>   --train_chain_data_cache_path TRAIN_CHAIN_DATA_CACHE_PATH
>   --distillation_chain_data_cache_path DISTILLATION_CHAIN_DATA_CACHE_PATH
>   --train_epoch_len TRAIN_EPOCH_LEN
>                         The virtual length of each training epoch. Stochastic filtering of training data means that training datasets have no well-defined length.
>                         This virtual length affects frequency of validation & checkpointing (by default, one of each per epoch).
>   --log_lr              Whether to log the actual learning rate
>   --config_preset CONFIG_PRESET
>                         Config setting. Choose e.g. "initial_training", "finetuning", "model_1", etc. By default, the actual values in the config are used.
>   --_distillation_structure_index_path _DISTILLATION_STRUCTURE_INDEX_PATH
>   --alignment_index_path ALIGNMENT_INDEX_PATH
>                         Training alignment index. See the README for instructions.
>   --distillation_alignment_index_path DISTILLATION_ALIGNMENT_INDEX_PATH
>                         Distillation alignment index. See the README for instructions.
>   --experiment_config_json EXPERIMENT_CONFIG_JSON
>                         Path to a json file with custom config values to overwrite config setting
>   --gpus GPUS           For determining optimal strategy and effective batch size.
>   --mpi_plugin          Whether to use MPI for parallele processing
> 
> Arguments to pass to PyTorch Lightning Trainer:
>   --num_nodes NUM_NODES
>   --precision PRECISION
>                         Sets precision, lower precision improves runtime performance.
>   --max_epochs MAX_EPOCHS
>   --log_every_n_steps LOG_EVERY_N_STEPS
>   --flush_logs_every_n_steps FLUSH_LOGS_EVERY_N_STEPS
>   --num_sanity_val_steps NUM_SANITY_VAL_STEPS
>   --reload_dataloaders_every_n_epochs RELOAD_DATALOADERS_EVERY_N_EPOCHS
>   --accumulate_grad_batches ACCUMULATE_GRAD_BATCHES
>                         Accumulate gradients over k batches before next optimizer step.
> ```

See the [EXAMPLE file](./EXAMPLE.md) for more info.

## Sample Slurm scripts

### x86_64 example
[OpenFold Slurm example script](https://raw.githubusercontent.com/tonykew/ccr-examples/refs/heads/OpenFold/containers/2_ApplicationSpecific/OpenFold/slurm_OpenFold_example.bash)

### Grace Hopper (GH200) GPU - ARM64 example
[OpenFold Grace Hopper (GH200) GPU - ARM64 Slurm example script](https://raw.githubusercontent.com/tonykew/ccr-examples/refs/heads/OpenFold/containers/2_ApplicationSpecific/OpenFold/slurm_GH200_OpenFold_example.bash)

## Documentation Resources

For more information on OpenFold see the [OpenFold Documentation](https://openfold.readthedocs.io/en/latest) and the [OpenFold GitHub page](https://github.com/aqlaboratory/openfold)


