# OpenFold Examples

## OpenFold example from the GitHub sources

The following example is from the [OpenFold Inference docs](https://openfold.readthedocs.io/en/latest/Inference.html#running-alphafold-model-inference)

Start an interactive job with a GPU e.g.
NOTE: OpenFold Inference only uses one GPU

```
export SBATCH_ACCOUNT="[SlurmAccountName]"
```

```
salloc --cluster=ub-hpc --partition=general-compute --qos=general-compute \
 --mem=128GB --nodes=1 --cpus-per-task=1 --tasks-per-node=12 \
 --gpus-per-node=1 --time=02:00:00
```

Change to your OpenFold directory

```
cd /projects/academic/[YourGroupName]/OpenFold
```

Create a top level output directory

```
mkdir -p ./output
```

Start the container, with the "./output" directory as the top level output
 directory "/output" inside the contianer.

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

All the following commands are run from the "Apptainer>" prompt.

The following example uses the [OpenFold model params](Download_model_parameters.md), which have
already been downloaded at CCR and are avaiable in the directory:
/util/software/data/OpenFold/openfold_params
This directory is mounted on /util/software/data/OpenFold/openfold_params
inside the contaner when using the "apptainer" command given above

# Get the example from the OpenFold GitHub repo

```
git clone https://github.com/aqlaboratory/openfold.git
mv openfold//examples/ ./examples/
rm -rf openfold
```

You should now have the monomer example in the ./examples/monomer/ directory

```
ls -l ./examples/monomer/
```

Sample output:

> ```
> total 1
> drwxrwsr-x 2 [CCRusername] nogroup 4096 Dec 17 10:34 alignments
> drwxrwsr-x 2 [CCRusername] nogroup 4096 Dec 17 10:34 fasta_dir
> -rwxrwxr-x 1 [CCRusername] nogroup  530 Dec 17 10:34 inference.sh
> drwxrwsr-x 2 [CCRusername] nogroup 4096 Dec 17 10:34 sample_predictions
> ```

## Run model inference

### Model inference with pre-computed alignments

Note: this example uses "/output/PDB_6KWC/pre-computed_alignments" as the
output directory; outside the container this is the directory:
"./output/PDB_6KWC/pre-computed_alignments"


```
export TRITON_CACHE_DIR="${SLURMTMPDIR}"
mkdir -p /output/PDB_6KWC/pre-computed_alignments
python3 "${OF_DIR}/run_pretrained_openfold.py" \
 --hhblits_binary_path "/opt/conda/bin/hhblits" \
 --hmmsearch_binary_path "/opt/conda/bin/hhsearch" \
 --hmmbuild_binary_path "/opt/conda/bin/hmmbuild" \
 --kalign_binary_path "/opt/conda/bin/kalign" \
 --model_device cuda \
 --data_random_seed $(((RANDOM<<15)|(RANDOM + 1))) \
 --use_precomputed_alignments "./examples/monomer/alignments" \
 --output_dir "/output/PDB_6KWC/pre-computed_alignments" \
 --config_preset model_1_ptm \
 --jax_param_path "${OF_DIR}/openfold/resources/params/params_model_1_ptm.npz" \
 "./examples/monomer/fasta_dir" \
 "/data/pdb_data/mmcif_files"
```

Sample output:

> ```
> [2025-12-17 10:36:24,872] [INFO] [real_accelerator.py:203:get_accelerator] Setting ds_accelerator to cuda (auto detect)
> Warning: The default cache directory for DeepSpeed Triton autotune, /user/[CCRusername]/.triton/autotune, appears to be on an NFS system. While this is generally acceptable, if you experience slowdowns or hanging when DeepSpeed exits, it is recommended to set the TRITON_CACHE_DIR environment variable to a non-NFS path.
> INFO:/opt/openfold/openfold/utils/script_utils.py:Successfully loaded JAX parameters at /opt/openfold/openfold/resources/params/params_model_1_ptm.npz...
> INFO:/opt/openfold/run_pretrained_openfold.py:Using precomputed alignments for 6KWC_1 at ./examples/monomer/alignments...
> INFO:/opt/openfold/openfold/utils/script_utils.py:Running inference for 6KWC_1...
> INFO:/opt/openfold/openfold/utils/script_utils.py:Inference time: 19.050397651968524
> INFO:/opt/openfold/run_pretrained_openfold.py:Output written to /output/PDB_6KWC/pre-computed_alignments/predictions/6KWC_1_model_1_ptm_unrelaxed.pdb...
> INFO:/opt/openfold/run_pretrained_openfold.py:Running relaxation on /output/PDB_6KWC/pre-computed_alignments/predictions/6KWC_1_model_1_ptm_unrelaxed.pdb...
> INFO:/opt/openfold/openfold/utils/script_utils.py:Relaxation time: 10.55438576999586
> INFO:/opt/openfold/openfold/utils/script_utils.py:Relaxed output written to /output/PDB_6KWC/pre-computed_alignments/predictions/6KWC_1_model_1_ptm_relaxed.pdb...
> ```

The output for the run is in the PDB_6KWC/pre-computed_alignments directory tree

```
ls -laR /output/PDB_6KWC/pre-computed_alignments
```

Sample output:

> ```
> /output/PDB_6KWC/pre-computed_alignments:
> total 1
> drwxrwsr-x 2 [CCRusername] nogroup 4096 Dec 17 10:37 .
> drwxrwsr-x 2 [CCRusername] nogroup 4096 Dec 17 10:36 ..
> drwxrwsr-x 2 [CCRusername] nogroup 4096 Dec 17 10:37 predictions
> -rw-rw-r-- 1 [CCRusername] nogroup   45 Dec 17 10:37 timings.json
> 
> /output/PDB_6KWC/pre-computed_alignments/predictions:
> total 341
> drwxrwsr-x 2 [CCRusername] nogroup   4096 Dec 17 10:37 .
> drwxrwsr-x 2 [CCRusername] nogroup   4096 Dec 17 10:37 ..
> -rw-rw-r-- 1 [CCRusername] nogroup 227310 Dec 17 10:37 6KWC_1_model_1_ptm_relaxed.pdb
> -rw-rw-r-- 1 [CCRusername] nogroup 120528 Dec 17 10:37 6KWC_1_model_1_ptm_unrelaxed.pdb
> -rw-rw-r-- 1 [CCRusername] nogroup     33 Dec 17 10:37 timings.json
> ```


### Model inference without pre-computed alignments

Note: jackhmmer and nhmmer don't scale beyond 8 cores, henec the "--cpu" option
is set to 8 rather than $(nproc)

```
export TRITON_CACHE_DIR="${SLURMTMPDIR}"
mkdir -p /output/PDB_6KWC/without_pre-computed_alignments
python3 "${OF_DIR}/run_pretrained_openfold.py" \
 --hhblits_binary_path "/opt/conda/bin/hhblits" \
 --hmmsearch_binary_path "/opt/conda/bin/hhsearch" \
 --hmmbuild_binary_path "/opt/conda/bin/hmmbuild" \
 --kalign_binary_path "/opt/conda/bin/kalign" \
 --uniref90_database_path "/database/uniref90/uniref90.fasta" \
 --mgnify_database_path "/database/mgnify/mgy_clusters_2022_05.fa" \
 --pdb70_database_path "/database/pdb70/pdb70" \
 --uniclust30_database_path "/database/uniclust30/uniclust30_2018_08/uniclust30_2018_08" \
 --bfd_database_path "/database/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt" \
 --cpus 8 \
 --model_device cuda \
 --data_random_seed $(((RANDOM<<15)|(RANDOM + 1))) \
 --output_dir "/output/PDB_6KWC/without_pre-computed_alignments" \
 --config_preset model_1_ptm \
 --jax_param_path "${OF_DIR}/openfold/resources/params/params_model_1_ptm.npz" \
 "./examples/monomer/fasta_dir" \
 "/data/pdb_data/mmcif_files"
```

Sample output:

> ```
> [2025-12-17 10:39:12,706] [INFO] [real_accelerator.py:203:get_accelerator] Setting ds_accelerator to cuda (auto detect)
> Warning: The default cache directory for DeepSpeed Triton autotune, /user/[CCRusername]/.triton/autotune, appears to be on an NFS system. While this is generally acceptable, if you experience slowdowns or hanging when DeepSpeed exits, it is recommended to set the TRITON_CACHE_DIR environment variable to a non-NFS path.
> INFO:/opt/openfold/openfold/utils/script_utils.py:Successfully loaded JAX parameters at /opt/openfold/openfold/resources/params/params_model_1_ptm.npz...
> INFO:/opt/openfold/run_pretrained_openfold.py:Generating alignments for 6KWC_1...
> INFO:/opt/openfold/openfold/utils/script_utils.py:Running inference for 6KWC_1...
> INFO:/opt/openfold/openfold/utils/script_utils.py:Inference time: 15.672921338002197
> INFO:/opt/openfold/run_pretrained_openfold.py:Output written to /output/PDB_6KWC/without_pre-computed_alignments/predictions/6KWC_1_model_1_ptm_unrelaxed.pdb...
> INFO:/opt/openfold/run_pretrained_openfold.py:Running relaxation on /output/PDB_6KWC/without_pre-computed_alignments/predictions/6KWC_1_model_1_ptm_unrelaxed.pdb...
> INFO:/opt/openfold/openfold/utils/script_utils.py:Relaxation time: 6.940809735970106
> INFO:/opt/openfold/openfold/utils/script_utils.py:Relaxed output written to /output/PDB_6KWC/without_pre-computed_alignments/predictions/6KWC_1_model_1_ptm_relaxed.pdb...
> ```

The output for the run is in the PDB_6KWC/without_pre-computed_alignments directory tree

```
ls -laR /output/PDB_6KWC/without_pre-computed_alignments
```

Sample output:

> ```
> /output/PDB_6KWC/without_pre-computed_alignments:
> total 1
> drwxrwsr-x 2 [CCRusername] nogroup 4096 Dec 17 11:24 .
> drwxrwsr-x 2 [CCRusername] nogroup 4096 Dec 17 10:39 ..
> drwxrwsr-x 2 [CCRusername] nogroup 4096 Dec 17 10:39 alignments
> drwxrwsr-x 2 [CCRusername] nogroup 4096 Dec 17 11:24 predictions
> -rw-rw-r-- 1 [CCRusername] nogroup   45 Dec 17 11:24 timings.json
> 
> /output/PDB_6KWC/without_pre-computed_alignments/alignments:
> total 0
> drwxrwsr-x 2 [CCRusername] nogroup 4096 Dec 17 10:39 .
> drwxrwsr-x 2 [CCRusername] nogroup 4096 Dec 17 11:24 ..
> drwxrwsr-x 2 [CCRusername] nogroup 4096 Dec 17 11:23 6KWC_1
> 
> /output/PDB_6KWC/without_pre-computed_alignments/alignments/6KWC_1:
> total 7028
> drwxrwsr-x 2 [CCRusername] nogroup    4096 Dec 17 11:23 .
> drwxrwsr-x 2 [CCRusername] nogroup    4096 Dec 17 10:39 ..
> -rw-rw-r-- 1 [CCRusername] nogroup  397302 Dec 17 11:23 bfd_uniclust_hits.a3m
> -rw-rw-r-- 1 [CCRusername] nogroup  136025 Dec 17 10:55 hhsearch_output.hhr
> -rw-rw-r-- 1 [CCRusername] nogroup 1972569 Dec 17 11:19 mgnify_hits.sto
> -rw-rw-r-- 1 [CCRusername] nogroup 4689644 Dec 17 10:54 uniref90_hits.sto
> 
> /output/PDB_6KWC/without_pre-computed_alignments/predictions:
> total 341
> drwxrwsr-x 2 [CCRusername] nogroup   4096 Dec 17 11:24 .
> drwxrwsr-x 2 [CCRusername] nogroup   4096 Dec 17 11:24 ..
> -rw-rw-r-- 1 [CCRusername] nogroup 227310 Dec 17 11:24 6KWC_1_model_1_ptm_relaxed.pdb
> -rw-rw-r-- 1 [CCRusername] nogroup 120528 Dec 17 11:24 6KWC_1_model_1_ptm_unrelaxed.pdb
> -rw-rw-r-- 1 [CCRusername] nogroup     33 Dec 17 11:24 timings.json
> ```


Note: Other possible options for "run_pretrained_openfold.py"

> ```
> --pdb_seqres_database_path "/database/pdb_seqres/pdb_seqres.txt" \
> --uniref30_database_path "/database/uniref30/UniRef30_2021_03" \
> --uniprot_database_path "/database/uniprot/uniprot.fasta" \
> --max_template_date MAX_TEMPLATE_DATE \
> --obsolete_pdbs_path OBSOLETE_PDBS_PATH \
> --model_device MODEL_DEVICE \
> --config_preset CONFIG_PRESET \
> --openfold_checkpoint_path OPENFOLD_CHECKPOINT_PATH \
> --save_outputs \
> --preset {reduced_dbs,full_dbs} \
> --output_postfix OUTPUT_POSTFIX \
> --skip_relaxation \
> --multimer_ri_gap MULTIMER_RI_GAP \
> --trace_model \
> --subtract_plddt \
> --long_sequence_inference \
> --cif_output \
> --experiment_config_json EXPERIMENT_CONFIG_JSON \
> --use_deepspeed_evoformer_attention \
> --release_dates_path RELEASE_DATES_PATH \
> ```


# Multi GPU example using the OpenFold PDB training set from RODA

Start an interactive job with more than one GPU e.g.

```
export SBATCH_ACCOUNT="[SlurmAccountName]"
```

```
salloc --cluster=ub-hpc --partition=industry-dgx --qos=industry --mem=128GB \
 --nodes=1 --gpus-per-node=8 --mem=0 --exclusive --time=3-00:00:00
```

sample outout:

> ```
> salloc: Pending job allocation 21070582
> salloc: job 21070582 queued and waiting for resources
> salloc: job 21070582 has been allocated resources
> salloc: Granted job allocation 21070582
> salloc: Nodes cpn-i09-04 are ready for job
> CCRusername@cpn-i09-04:~$ 
> ```

In this case the node allocated has eight H100 GPUs with 80GB RAM each

```
nvidia-smi -L
```

output:

> ````
> GPU 0: NVIDIA H100 80GB HBM3 (UUID: GPU-e5f404f3-cc2a-cf0c-219f-dcf1a4e223f2)
> GPU 1: NVIDIA H100 80GB HBM3 (UUID: GPU-96601a91-e977-7a71-a188-8df4aff2fbcc)
> GPU 2: NVIDIA H100 80GB HBM3 (UUID: GPU-c4a62918-26ce-f10c-a009-dd3b2e069ac2)
> GPU 3: NVIDIA H100 80GB HBM3 (UUID: GPU-7b286e42-7f9d-a8e8-501c-14b0663b8440)
> GPU 4: NVIDIA H100 80GB HBM3 (UUID: GPU-a9038bc9-da63-7f95-edb6-9857e428acbc)
> GPU 5: NVIDIA H100 80GB HBM3 (UUID: GPU-347ee5de-5ad5-fdea-3c1b-41ba332b066e)
> GPU 6: NVIDIA H100 80GB HBM3 (UUID: GPU-558a69d7-ed47-fd4c-be72-4308fefe6876)
> GPU 7: NVIDIA H100 80GB HBM3 (UUID: GPU-f65a6ec2-ce6f-ba6c-d4c2-8ca414d6e709)
> ````

Change to your OpenFold directory

```
cd /projects/academic/[YourGroupName]/OpenFold
```

Create an output directory

```
mkdir -p ./output
```

Start the container, with the "./output" directory as the output directory.
Note: You can change the /output mount: "-B $(pwd)/output:/output" to use an
alternate output directory

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

All the following commands are run from the "Apptainer>" prompt.

The following example uses the OpenFold PDB training set from RODA, which was
downloaded and processed for use already, and is available at CCR in the
directory: /util/software/data/OpenFold/
This directory is about 1.5TB in size

The process to download & process this data is documented in in the
[Download_OpenFold_PDB_training_set.md](Download_OpenFold_PDB_training_set.md) file.
This process takes several days to complete.  Do NOT follow the instrctions
therein unless the CCR copy does not work for your use case, and you have
sufficient storage space for the files.


NOTE: The "--seed" option below uses a random number utilizing the ${RANDOM}
bash variable to generate an integer in the 1 to 2^32 range.  You should
expect to generate different loss values for the same parameters and data,
with multiple runs.  If you use the same seed for multiple runs you should
generate the same loss values (this can be used for reproducibility.)

```
export TRITON_CACHE_DIR="${SLURMTMPDIR}"
mkdir -p /output/PDB/2021-10-10/
python3 "${OF_DIR}/train_openfold.py" \
 --train_chain_data_cache_path "/data/pdb_data/data_caches/chain_data_cache.json" \
 --template_release_dates_cache_path "/data/pdb_data/data_caches/mmcif_cache.json" \
 --obsolete_pdbs_file_path "/data/pdb_data/obsolete.dat" \
 --config_preset initial_training \
 --seed $(((RANDOM<<15)|(RANDOM + 1))) \
 --num_nodes ${SLURM_NNODES} \
 --gpus $(expr ${SLURM_GPUS_ON_NODE} \* ${SLURM_NNODES}) \
 --max_epochs 1000 \
 --checkpoint_every_epoch \
 "/data/pdb_data/mmcif_files" \
 "/data/alignment_data/alignments" \
 "/data/pdb_data/mmcif_files" \
 "/output/PDB/2021-10-10" \
 "2021-10-10"
```

Sample abridged output:

> ```
> [2025-12-17 11:56:06,327] [INFO] [real_accelerator.py:203:get_accelerator] Setting ds_accelerator to cuda (auto detect)
> Warning: The default cache directory for DeepSpeed Triton autotune, /user/tkewtest/.triton/autotune, appears to be on an NFS system. While this is generally acceptable, if you experience slowdowns or hanging when DeepSpeed exits, it is recommended to set the TRITON_CACHE_DIR environment variable to a non-NFS path.
> [rank: 0] Seed set to 1054328241
> /opt/conda/lib/python3.10/site-packages/lightning_fabric/connector.py:571: `precision=bf16` is supported for historical reasons but its usage is discouraged. Please set your precision to bf16-mixed instead!
> Using bfloat16 Automatic Mixed Precision (AMP)
> GPU available: True (cuda), used: True
> TPU available: False, using: 0 TPU cores
> Initializing distributed: GLOBAL_RANK: 0, MEMBER: 1/8
> [2025-12-17 11:56:37,498] [INFO] [real_accelerator.py:203:get_accelerator] Setting ds_accelerator to cuda (auto detect)
> [2025-12-17 11:56:37,528] [INFO] [real_accelerator.py:203:get_accelerator] Setting ds_accelerator to cuda (auto detect)
> [2025-12-17 11:56:37,538] [INFO] [real_accelerator.py:203:get_accelerator] Setting ds_accelerator to cuda (auto detect)
> [2025-12-17 11:56:37,541] [INFO] [real_accelerator.py:203:get_accelerator] Setting ds_accelerator to cuda (auto detect)
> [2025-12-17 11:56:37,542] [INFO] [real_accelerator.py:203:get_accelerator] Setting ds_accelerator to cuda (auto detect)
> [2025-12-17 11:56:37,544] [INFO] [real_accelerator.py:203:get_accelerator] Setting ds_accelerator to cuda (auto detect)
> [2025-12-17 11:56:37,546] [INFO] [real_accelerator.py:203:get_accelerator] Setting ds_accelerator to cuda (auto detect)
> Warning: The default cache directory for DeepSpeed Triton autotune, /user/tkewtest/.triton/autotune, appears to be on an NFS system. While this is generally acceptable, if you experience slowdowns or hanging when DeepSpeed exits, it is recommended to set the TRITON_CACHE_DIR environment variable to a non-NFS path.
> [...]
> Warning: The default cache directory for DeepSpeed Triton autotune, /user/tkewtest/.triton/autotune, appears to be on an NFS system. While this is generally acceptable, if you experience slowdowns or hanging when DeepSpeed exits, it is recommended to set the TRITON_CACHE_DIR environment variable to a non-NFS path.
> [rank: 2] Seed set to 1054328241
> [rank: 3] Seed set to 1054328241
> [rank: 5] Seed set to 1054328241
> [rank: 7] Seed set to 1054328241
> [rank: 1] Seed set to 1054328241
> [rank: 6] Seed set to 1054328241
> [rank: 4] Seed set to 1054328241
> Initializing distributed: GLOBAL_RANK: 2, MEMBER: 3/8
> Initializing distributed: GLOBAL_RANK: 3, MEMBER: 4/8
> Initializing distributed: GLOBAL_RANK: 4, MEMBER: 5/8
> Initializing distributed: GLOBAL_RANK: 6, MEMBER: 7/8
> Initializing distributed: GLOBAL_RANK: 1, MEMBER: 2/8
> Initializing distributed: GLOBAL_RANK: 7, MEMBER: 8/8
> Initializing distributed: GLOBAL_RANK: 5, MEMBER: 6/8
> ----------------------------------------------------------------------------------------------------
> distributed_backend=nccl
> All distributed processes registered. Starting with 8 processes
> ----------------------------------------------------------------------------------------------------
> 
> LOCAL_RANK: 1 - CUDA_VISIBLE_DEVICES: [0,1,2,3,4,5,6,7]
> LOCAL_RANK: 0 - CUDA_VISIBLE_DEVICES: [0,1,2,3,4,5,6,7]
> LOCAL_RANK: 2 - CUDA_VISIBLE_DEVICES: [0,1,2,3,4,5,6,7]
> LOCAL_RANK: 3 - CUDA_VISIBLE_DEVICES: [0,1,2,3,4,5,6,7]
> LOCAL_RANK: 7 - CUDA_VISIBLE_DEVICES: [0,1,2,3,4,5,6,7]
> LOCAL_RANK: 5 - CUDA_VISIBLE_DEVICES: [0,1,2,3,4,5,6,7]
> LOCAL_RANK: 6 - CUDA_VISIBLE_DEVICES: [0,1,2,3,4,5,6,7]
> LOCAL_RANK: 4 - CUDA_VISIBLE_DEVICES: [0,1,2,3,4,5,6,7]
> /opt/conda/lib/python3.10/site-packages/torch/optim/lr_scheduler.py:62: UserWarning: The verbose parameter is deprecated. Please use get_last_lr() to access the learning rate.
>   warnings.warn(
> /opt/conda/lib/python3.10/site-packages/torch/optim/lr_scheduler.py:62: UserWarning: The verbose parameter is deprecated. Please use get_last_lr() to access the learning rate.
> [...]
>   warnings.warn(
> /opt/conda/lib/python3.10/site-packages/pytorch_lightning/utilities/model_summary/model_summary.py:242: Precision bf16-mixed is not supported by the model summary.  Estimated model size in MB will not be accurate. Using 32 bits instead.
> ┏━━━┳━━━━━━━┳━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━┳━━━━━━━┓
> ┃   ┃ Name  ┃ Type          ┃ Params ┃ Mode  ┃ FLOPs ┃
> ┡━━━╇━━━━━━━╇━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━╇━━━━━━━┩
> │ 0 │ model │ AlphaFold     │ 93.2 M │ train │     0 │
> │ 1 │ loss  │ AlphaFoldLoss │      0 │ train │     0 │
> └───┴───────┴───────────────┴────────┴───────┴───────┘
> Trainable params: 93.2 M
> Non-trainable params: 0
> Total params: 93.2 M
> Total estimated model params size (MB): 372
> Modules in train mode: 4451
> Modules in eval mode: 0
> Total FLOPs: 0
> /opt/conda/lib/python3.10/site-packages/pytorch_lightning/utilities/data.py:106: Total length of `list` across ranks is zero. Please make sure this was your intention.
> Epoch 0/999 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 0/1250 0:00:00 • -:--:-- 0.00it/s
> /opt/conda/lib/python3.10/site-packages/torch/_dynamo/eval_frame.py:632: UserWarning: torch.utils.checkpoint: the use_reentrant parameter should be passed explicitly. In version 2.5 we will raise an exception if use_reentrant is not passed. use_reentrant=False is recommended, but if you need to preserve the current default behavior, you can pass use_reentrant=True. Refer to docs for more details on the differences between the two variants.
>   return fn(*args, **kwargs)
> [...]
> Epoch 0/999 ╸━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 21/1250 0:02:02 • 1:18:06 0.26it/s train/loss: 143.231
> [...]
> Epoch 0/999 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╸━ 1215/1250 1:27:11 • 0:02:25 0.24it/s train/loss: 53.322
> [....]
> ```

Note: This example will fail with an odd "strategy=None" error if run on a
node with only one GPU

In the above example, I stopped the training with <ctrl>c after Ephoch 0 which
created the following checkpoint file:

```
ls -l /output/PDB/2021-10-10/checkpoints
```

> ```
> total 1464717
> -rw-rw-r-- 1 tkewtest nogroup 1499870010 Dec 17 13:27 0-1250.ckpt
> ```

Restarted the training from the checkpoint, using the checkpoint file
"/output/PDB/2021-10-10/checkpoints/0-1250.ckpt"

```
export TRITON_CACHE_DIR="${SLURMTMPDIR}"
python3 "${OF_DIR}/train_openfold.py" \
 --train_chain_data_cache_path "/data/pdb_data/data_caches/chain_data_cache.json" \
 --template_release_dates_cache_path "/data/pdb_data/data_caches/mmcif_cache.json" \
 --obsolete_pdbs_file_path "/data/pdb_data/obsolete.dat" \
 --config_preset initial_training \
 --seed $(((RANDOM<<15)|(RANDOM + 1))) \
 --num_nodes ${SLURM_NNODES} \
 --gpus $(expr ${SLURM_GPUS_ON_NODE} \* ${SLURM_NNODES}) \
 --max_epochs 1000 \
 --checkpoint_every_epoch \
 --resume_from_ckpt /output/PDB/2021-10-10/checkpoints/0-1250.ckpt \
 "/data/pdb_data/mmcif_files" \
 "/data/alignment_data/alignments" \
 "/data/pdb_data/mmcif_files" \
 "/output/PDB/2021-10-10" \
 "2021-10-10"
```

Sample abridged output:

```
[2025-12-17 14:13:31,823] [INFO] [real_accelerator.py:203:get_accelerator] Setting ds_accelerator to cuda (auto detect)
Warning: The default cache directory for DeepSpeed Triton autotune, /user/tkewtest/.triton/autotune, appears to be on an NFS system. While this is generally acceptable, if you experience slowdowns or hanging when DeepSpeed exits, it is recommended to set the TRITON_CACHE_DIR environment variable to a non-NFS path.
[rank: 0] Seed set to 743491233
/opt/conda/lib/python3.10/site-packages/lightning_fabric/connector.py:571: `precision=bf16` is supported for historical reasons but its usage is discouraged. Please set your precision to bf16-mixed instead!
Using bfloat16 Automatic Mixed Precision (AMP)
GPU available: True (cuda), used: True
TPU available: False, using: 0 TPU cores
Initializing distributed: GLOBAL_RANK: 0, MEMBER: 1/8
[2025-12-17 14:14:00,153] [INFO] [real_accelerator.py:203:get_accelerator] Setting ds_accelerator to cuda (auto detect)
Warning: The default cache directory for DeepSpeed Triton autotune, /user/tkewtest/.triton/autotune, appears to be on an NFS system. While this is generally acceptable, if you experience slowdowns or hanging when DeepSpeed exits, it is recommended to set the TRITON_CACHE_DIR environment variable to a non-NFS path.
[2025-12-17 14:14:00,563] [INFO] [real_accelerator.py:203:get_accelerator] Setting ds_accelerator to cuda (auto detect)
[2025-12-17 14:14:00,570] [INFO] [real_accelerator.py:203:get_accelerator] Setting ds_accelerator to cuda (auto detect)
[2025-12-17 14:14:00,572] [INFO] [real_accelerator.py:203:get_accelerator] Setting ds_accelerator to cuda (auto detect)
[2025-12-17 14:14:00,578] [INFO] [real_accelerator.py:203:get_accelerator] Setting ds_accelerator to cuda (auto detect)
[2025-12-17 14:14:00,588] [INFO] [real_accelerator.py:203:get_accelerator] Setting ds_accelerator to cuda (auto detect)
[2025-12-17 14:14:00,591] [INFO] [real_accelerator.py:203:get_accelerator] Setting ds_accelerator to cuda (auto detect)
Warning: The default cache directory for DeepSpeed Triton autotune, /user/tkewtest/.triton/autotune, appears to be on an NFS system. While this is generally acceptable, if you experience slowdowns or hanging when DeepSpeed exits, it is recommended to set the TRITON_CACHE_DIR environment variable to a non-NFS path.
[...]
Warning: The default cache directory for DeepSpeed Triton autotune, /user/tkewtest/.triton/autotune, appears to be on an NFS system. While this is generally acceptable, if you experience slowdowns or hanging when DeepSpeed exits, it is recommended to set the TRITON_CACHE_DIR environment variable to a non-NFS path.
[rank: 4] Seed set to 743491233
[rank: 5] Seed set to 743491233
[rank: 7] Seed set to 743491233
[rank: 3] Seed set to 743491233
[rank: 6] Seed set to 743491233
[rank: 1] Seed set to 743491233
[rank: 2] Seed set to 743491233
Initializing distributed: GLOBAL_RANK: 4, MEMBER: 5/8
Initializing distributed: GLOBAL_RANK: 7, MEMBER: 8/8
Initializing distributed: GLOBAL_RANK: 6, MEMBER: 7/8
Initializing distributed: GLOBAL_RANK: 2, MEMBER: 3/8
Initializing distributed: GLOBAL_RANK: 5, MEMBER: 6/8
Initializing distributed: GLOBAL_RANK: 3, MEMBER: 4/8
Initializing distributed: GLOBAL_RANK: 1, MEMBER: 2/8
----------------------------------------------------------------------------------------------------
distributed_backend=nccl
All distributed processes registered. Starting with 8 processes
----------------------------------------------------------------------------------------------------

/opt/conda/lib/python3.10/site-packages/pytorch_lightning/callbacks/model_checkpoint.py:881: Checkpoint directory /output/PDB/2021-10-10/checkpoints exists and is not empty.
Restoring states from the checkpoint path at /output/PDB/2021-10-10/checkpoints/0-1250.ckpt
LOCAL_RANK: 4 - CUDA_VISIBLE_DEVICES: [0,1,2,3,4,5,6,7]
LOCAL_RANK: 1 - CUDA_VISIBLE_DEVICES: [0,1,2,3,4,5,6,7]
LOCAL_RANK: 7 - CUDA_VISIBLE_DEVICES: [0,1,2,3,4,5,6,7]
LOCAL_RANK: 3 - CUDA_VISIBLE_DEVICES: [0,1,2,3,4,5,6,7]
LOCAL_RANK: 0 - CUDA_VISIBLE_DEVICES: [0,1,2,3,4,5,6,7]
LOCAL_RANK: 5 - CUDA_VISIBLE_DEVICES: [0,1,2,3,4,5,6,7]
LOCAL_RANK: 2 - CUDA_VISIBLE_DEVICES: [0,1,2,3,4,5,6,7]
LOCAL_RANK: 6 - CUDA_VISIBLE_DEVICES: [0,1,2,3,4,5,6,7]
/opt/conda/lib/python3.10/site-packages/torch/optim/lr_scheduler.py:62: UserWarning: The verbose parameter is deprecated. Please use get_last_lr() to access the learning rate.
  warnings.warn(
/opt/conda/lib/python3.10/site-packages/torch/optim/lr_scheduler.py:62: UserWarning: The verbose parameter is deprecated. Please use get_last_lr() to access the learning rate.
[...]
  warnings.warn(
/opt/conda/lib/python3.10/site-packages/pytorch_lightning/utilities/model_summary/model_summary.py:242: Precision bf16-mixed is not supported by the model summary.  Estimated model size in MB will not be accurate. Using 32 bits instead.
┏━━━┳━━━━━━━┳━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━┳━━━━━━━┓
┃   ┃ Name  ┃ Type          ┃ Params ┃ Mode  ┃ FLOPs ┃
┡━━━╇━━━━━━━╇━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━╇━━━━━━━┩
│ 0 │ model │ AlphaFold     │ 93.2 M │ train │     0 │
│ 1 │ loss  │ AlphaFoldLoss │      0 │ train │     0 │
└───┴───────┴───────────────┴────────┴───────┴───────┘
Trainable params: 93.2 M
Non-trainable params: 0
Total params: 93.2 M
Total estimated model params size (MB): 372
Modules in train mode: 4451
Modules in eval mode: 0
Total FLOPs: 0
Restored all states from the checkpoint at /output/PDB/2021-10-10/checkpoints/0-1250.ckpt
/opt/conda/lib/python3.10/site-packages/pytorch_lightning/utilities/data.py:106: Total length of `list` across ranks is zero. Please make sure this was your intention.
WARNING:root:The exact sequence HPETTPTMLTAPIDSGFLKDPVITPEGFVYNKSSILKWLETKKEDPQSRKPLTAKDLQPFPELLIIVNRFVET was not found in 4wz0_A. Realigning the template to the actual sequence.
WARNING:root:The exact sequence LPYSLTSDNCEHFVNHLRY was not found in 4dpz_X. Realigning the template to the actual sequence.
Epoch 1/999 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 0/1250 0:00:00 • -:--:-- 0.00it/s
[...]
Epoch 1/999 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 7/1250 0:01:13 • 1:28:29 0.23it/s train/loss: 49.389
[...]
```

You can monitor the GPU utilization which running the training as following,
using the Slurm job id:

e.g. from vortex:

```
srun --jobid="21070582" --export=HOME,TERM,SHELL --pty /bin/bash --login
```

Sample output:

> ```
> CCRusername@cpn-i09-04:~$
> ```

Show the GPUs available in the Slurm job:

```
nvidia-smi -L
```

Sample output:

> ```
> GPU 0: NVIDIA H100 80GB HBM3 (UUID: GPU-e5f404f3-cc2a-cf0c-219f-dcf1a4e223f2)
> GPU 1: NVIDIA H100 80GB HBM3 (UUID: GPU-96601a91-e977-7a71-a188-8df4aff2fbcc)
> GPU 2: NVIDIA H100 80GB HBM3 (UUID: GPU-c4a62918-26ce-f10c-a009-dd3b2e069ac2)
> GPU 3: NVIDIA H100 80GB HBM3 (UUID: GPU-7b286e42-7f9d-a8e8-501c-14b0663b8440)
> GPU 4: NVIDIA H100 80GB HBM3 (UUID: GPU-a9038bc9-da63-7f95-edb6-9857e428acbc)
> GPU 5: NVIDIA H100 80GB HBM3 (UUID: GPU-347ee5de-5ad5-fdea-3c1b-41ba332b066e)
> GPU 6: NVIDIA H100 80GB HBM3 (UUID: GPU-558a69d7-ed47-fd4c-be72-4308fefe6876)
> GPU 7: NVIDIA H100 80GB HBM3 (UUID: GPU-f65a6ec2-ce6f-ba6c-d4c2-8ca414d6e709)
> ```

Monitor the GPU activity:

```
nvidia-smi -l
```

Sample output:

> ```
> Tue Aug 26 15:49:52 2025
> +-----------------------------------------------------------------------------------------+
> | NVIDIA-SMI 570.133.20             Driver Version: 570.133.20     CUDA Version: 12.8     |
> |-----------------------------------------+------------------------+----------------------+
> | GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
> | Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
> |                                         |                        |               MIG M. |
> |=========================================+========================+======================|
> |   0  NVIDIA H100 80GB HBM3          On  |   00000000:19:00.0 Off |                    0 |
> | N/A   41C    P0            362W /  700W |   26980MiB /  81559MiB |    100%      Default |
> |                                         |                        |             Disabled |
> +-----------------------------------------+------------------------+----------------------+
> |   1  NVIDIA H100 80GB HBM3          On  |   00000000:3B:00.0 Off |                    0 |
> | N/A   37C    P0            346W /  700W |   11751MiB /  81559MiB |    100%      Default |
> |                                         |                        |             Disabled |
> +-----------------------------------------+------------------------+----------------------+
> |   2  NVIDIA H100 80GB HBM3          On  |   00000000:4C:00.0 Off |                    0 |
> | N/A   36C    P0            330W /  700W |   11751MiB /  81559MiB |    100%      Default |
> |                                         |                        |             Disabled |
> +-----------------------------------------+------------------------+----------------------+
> |   3  NVIDIA H100 80GB HBM3          On  |   00000000:5D:00.0 Off |                    0 |
> | N/A   38C    P0            349W /  700W |   11751MiB /  81559MiB |    100%      Default |
> |                                         |                        |             Disabled |
> +-----------------------------------------+------------------------+----------------------+
> |   4  NVIDIA H100 80GB HBM3          On  |   00000000:9B:00.0 Off |                    0 |
> | N/A   39C    P0            334W /  700W |   11751MiB /  81559MiB |     95%      Default |
> |                                         |                        |             Disabled |
> +-----------------------------------------+------------------------+----------------------+
> |   5  NVIDIA H100 80GB HBM3          On  |   00000000:BB:00.0 Off |                    0 |
> | N/A   36C    P0            335W /  700W |   11751MiB /  81559MiB |     73%      Default |
> |                                         |                        |             Disabled |
> +-----------------------------------------+------------------------+----------------------+
> |   6  NVIDIA H100 80GB HBM3          On  |   00000000:CB:00.0 Off |                    0 |
> | N/A   86C    P0            226W /  700W |   11751MiB /  81559MiB |    100%      Default |
> |                                         |                        |             Disabled |
> +-----------------------------------------+------------------------+----------------------+
> |   7  NVIDIA H100 80GB HBM3          On  |   00000000:DB:00.0 Off |                    0 |
> | N/A   37C    P0            353W /  700W |   11511MiB /  81559MiB |     89%      Default |
> |                                         |                        |             Disabled |
> +-----------------------------------------+------------------------+----------------------+
> 
> +-----------------------------------------------------------------------------------------+
> | Processes:                                                                              |
> |  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
> |        ID   ID                                                               Usage      |
> |=========================================================================================|
> |    0   N/A  N/A         2085037      C   python3                               13266MiB |
> |    0   N/A  N/A         2085212      C   /opt/conda/bin/python3                 1952MiB |
> |    0   N/A  N/A         2085213      C   /opt/conda/bin/python3                 1952MiB |
> |    0   N/A  N/A         2085214      C   /opt/conda/bin/python3                 1952MiB |
> |    0   N/A  N/A         2085215      C   /opt/conda/bin/python3                 1952MiB |
> |    0   N/A  N/A         2085216      C   /opt/conda/bin/python3                 1952MiB |
> |    0   N/A  N/A         2085217      C   /opt/conda/bin/python3                 1952MiB |
> |    0   N/A  N/A         2085218      C   /opt/conda/bin/python3                 1952MiB |
> |    1   N/A  N/A         2085212      C   /opt/conda/bin/python3                11742MiB |
> |    2   N/A  N/A         2085213      C   /opt/conda/bin/python3                11742MiB |
> |    3   N/A  N/A         2085214      C   /opt/conda/bin/python3                11742MiB |
> |    4   N/A  N/A         2085215      C   /opt/conda/bin/python3                11742MiB |
> |    5   N/A  N/A         2085216      C   /opt/conda/bin/python3                11742MiB |
> |    6   N/A  N/A         2085217      C   /opt/conda/bin/python3                11742MiB |
> |    7   N/A  N/A         2085218      C   /opt/conda/bin/python3                11502MiB |
> +-----------------------------------------------------------------------------------------+
> ```

