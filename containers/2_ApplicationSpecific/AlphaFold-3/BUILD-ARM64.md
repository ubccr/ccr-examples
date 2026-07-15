# Build the AlphaFold container on ARM64

## Buid the ARM64 container image

Start an interactive job on an ARM64 node

```
tmp_file="$(mktemp)"
salloc --partition=arm64 --qos=arm64 --constraint=ARM64 --no-shell \
 --exclusive --time=1:00:00 2>&1 | tee "${tmp_file}"
SLURM_JOB_ID="$(head -1 "${tmp_file}" | awk '{print $NF}')"
rm "${tmp_file}"
srun --jobid="${SLURM_JOB_ID}" --export=HOME,TERM,SHELL --pty /bin/bash --login
```

sample outout:

> ```
> salloc: Pending job allocation [JobID]
> salloc: job [JobID] queued and waiting for resources
> salloc: job [JobID] has been allocated resources
> salloc: Granted job allocation [JobID]
> salloc: Waiting for resource configuration
> salloc: Nodes [NodeID] are ready for job
> CCRusername@[NodeID]:~$
> ```

Change to your AlphaFold-3 directory
The `AlphaFold-3.def` file will already be in the directory if you have already built
on the x86_64 platform, if not, copy the file here.

```
cd /projects/academic/[YourGroupName]/AlphaFold-3
```

Then set the apptainer cache dir:

```
export APPTAINER_CACHEDIR=${SLURMTMPDIR}
```

Build your container

Building the AlphaFold-3 container takes about half an hour

```
apptainer build --fakeroot AlphaFold-3-$(arch).sif AlphaFold-3.def
```

sample truncated output:

> ```
> [....]
> INFO:    Adding environment to container
> INFO:    Creating SIF file...
> INFO:    Build complete: AlphaFold-3-aarch64.sif
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
tmp_file="$(mktemp)"
salloc --partition=arm64 --qos=arm64 --constraint=ARM64 --no-shell \
 --time=1:00:00  --nodes=1 --tasks-per-node=1 --cpus-per-task=4 \
 --gpus-per-node=1 --constraint="GH200" --mem=90G 2>&1 | tee "${tmp_file}"
SLURM_JOB_ID="$(head -1 "${tmp_file}" | awk '{print $NF}')"
rm "${tmp_file}"
srun --jobid="${SLURM_JOB_ID}" --export=HOME,TERM,SHELL --pty /bin/bash --login
```

Change to your AlphaFold-3 directory

```
cd /projects/academic/[YourGroupName]/AlphaFold-3
```

Create the input & output base directories

```
mkdir -p ./af_input ./af_input_inference ./af_output
```

...then start the AlphaFold container instance

```
apptainer shell \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --nv \
 ./AlphaFold-3-$(arch).sif
```

expected output:

> ```
> 
> # Setting environment variable XLA_FLAGS to work around a known XLA issue that
> # will greatly increase compilation time
> 
> export XLA_FLAGS="--xla_gpu_enable_triton_gemm=false"
> 
> # Setting environment variables for folding up to 5,120 tokens on A100 80GB
> 
> export XLA_PYTHON_CLIENT_PREALLOCATE="true"
> export XLA_CLIENT_MEM_FRACTION="0.95"
> 
> Apptainer> 
> ```

All the following commands are run from the "Apptainer> " prompt

Verify AlphaFold is installed:

```
python3 "/app/alphafold/run_alphafold.py" \
 --db_dir="/util/software/data/alphafold3/" \
 --model_dir="./models" \
 --input_dir="./af_input" \
 --force_output_dir \
 --output_dir="./af_output" \
 ${ALPHAFOLD3_EXTRA_OPTIONS} \
 --helpshort
```

Abridged expected output:

> ```
> AlphaFold 3 structure prediction script.
> 
> AlphaFold 3 source code is licensed under CC BY-NC-SA 4.0. To view a copy of
> this license, visit https://creativecommons.org/licenses/by-nc-sa/4.0/
> 
> To request access to the AlphaFold 3 model parameters, follow the process set
> out at https://github.com/google-deepmind/alphafold3. You may only use these
> if received directly from Google. Use is subject to terms of use available at
> https://github.com/google-deepmind/alphafold3/blob/main/WEIGHTS_TERMS_OF_USE.md
> 
> flags:
> [...]
> ```

Exit the Apptainer container instance

```
exit
```

sample outout:

> ```
> CCRusername@cpn-v14-19$ 
> ```

End the Slurm job

```
scancel "${SLURM_JOB_ID}"
unset SLURM_JOB_ID
```

