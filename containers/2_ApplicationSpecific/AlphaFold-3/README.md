# Example AlphaFold 3 container

> [!NOTE]
> AlphaFold 3 requires a model parameters file.  
> You must request the file by completing the [AlphaFold 3 model parameter request form](https://forms.gle/svvpY4u2jsHEwWYS6) and agree to the software [terms of use](https://github.com/google-deepmind/alphafold3/blob/main/WEIGHTS_TERMS_OF_USE.md)
> If you are granted access to the file, Google will email you a download link.

Here is an example to setup the parameters file for use:

Change to your AlphaFold-3 directory

```
cd /projects/academic/[YourGroupName]/AlphaFold-3
```

then fetch the model parameters file:

```
curl -o af3.bin.zst [download URL]
zstd -d af3.bin.zst
rm af3.bin.zst
chmod 440 af3.bin
mkdir -p ./models/
mv af3.bin models/
chmod 550 ./models/
```


## Building the container

A brief guide to building the AlphaFold container follows:<br/>
Please refer to CCR's [container documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/) for more detailed information on building and using Apptainer.

> [!NOTE] 
> For building on the ARM64 platform see [BUILD-ARM64.md](./BUILD-ARM64.md)

1. Start an interactive job

> [!IMPORTANT]
> Apptainer is not available on the CCR login nodes and the compile nodes may not provide enough resources for you to build a container.  We recommend requesting an interactive job on a compute node to conduct this build process.

A GPU is NOT needed to build the AlphaFold container.
See CCR documentation for more info on [running jobs](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission)

```
salloc --cluster=ub-hpc --partition=debug --qos=debug --mem=0 --exclusive --time=01:00:00
```

sample outout:

> ```
> salloc: Pending job allocation [JobID]
> salloc: job [JobID] queued and waiting for resources
> salloc: job [JobID] has been allocated resources
> salloc: Granted job allocation 19781052
> salloc: Nodes [NodeID] are ready for job
> CCRusername@[NodeID]:~$ 
> ```

2. Navigate to your build directory and use the Slurm job local temporary directory for cache

You should now be on the compute node allocated to you.  In this example we're using our project directory for our build directory.  Ensure you've placed your `AlphaFold-3.def` file in your build directory

Change to your AlphaFold-3 directory

```
cd /projects/academic/[YourGroupName]/AlphaFold-3
```

Then set the apptainer cache dir:

```
export APPTAINER_CACHEDIR=${SLURMTMPDIR}
```

3. Build your container

Building the AlphaFold-3 container takes about half an hour

```
apptainer build --fakeroot AlphaFold-3-$(arch).sif AlphaFold-3.def
```

sample truncated output:

> ```
> [....]
> INFO:    Adding environment to container
> INFO:    Creating SIF file...
> INFO:    Build complete: AlphaFold-3-x86_64.sif
> ```

## Running the container

Start an interactive job e.g.

```
salloc --cluster=ub-hpc --partition=general-compute --qos=general-compute --mem=128GB --nodes=1 --cpus-per-task=1 --tasks-per-node=12 --gpus-per-node=1 --time=05:00:00
```

Change to your AlphaFold-3 directory

```
cd /projects/academic/[YourGroupName]/AlphaFold-3
```

Create the input & output directories

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

If you requested a GPU (for Inference) the container startup will set
environment variables to give some sensible default values, based on the
GPU compute capability and RAM.

sample output for a V100 GPU with 32GB RAM:

> ```
> # Running on a GPU with a compute capability less than 8
> # i.e. this GPU predates the Ampere GPUs
> # Setting environment variable XLA_FLAGS to use this GPU
> 
> export XLA_FLAGS="--xla_disable_hlo_passes=custom-kernel-fusion-rewriter"
> 
> # You must also add the "--flash_attention_implementation=xla" to
> # /app/alphafold/run_alphafold.py for this GPU to work:
> 
> export ALPHAFOLD3_EXTRA_OPTIONS="--flash_attention_implementation=xla"
> 
> # Setting environment variables for a GPU with less than 80GB RAM
> 
> export XLA_PYTHON_CLIENT_PREALLOCATE="false"
> export TF_FORCE_UNIFIED_MEMORY="true"
> export XLA_CLIENT_MEM_FRACTION="3.2"
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

See the [EXAMPLES file](./EXAMPLES.md) for more information.

## Sample Slurm scripts

Slurm script examples:

### x86_64 example
[AlphaFold 3 Slurm Data Pipeline example](https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/AlphaFold-3/slurm_AlphaFold-3_Data_Pipeline_example.bash)  
[AlphaFold 3 Slurm Inference example](https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/AlphaFold-3/slurm_AlphaFold-3_Inference_example.bash)

### Grace Hopper (GH200) GPU example
[AlphaFold 3 Slurm (x86_64) Data Pipeline example](https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/AlphaFold-3/slurm_GH200_AlphaFold-3_Data_Pipeline_example.bash)  
[AlphaFold 3 Slurm Grace Hopper Inference example](https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/AlphaFold-3/slurm_GH200_AlphaFold-3_Inference_example.bash)


## Documentation Resources

For more information on AlphaFold-3 see the [AlphaFold-3 Wiki](https://deepwiki.com/google-deepmind/alphafold3/1-overview), the [AlphaFold-3 User Guide](https://deepwiki.com/google-deepmind/alphafold3/3-user-guide),
the [AlphaFold-3 Performance Optimization Guide](https://deepwiki.com/google-deepmind/alphafold3/8-performance-optimization) and the [AlphaFold-3 GitHub page](https://github.com/google-deepmind/alphafold3)

