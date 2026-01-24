# BindCraft Examples with PyRosetta

## BindCraft 

The following examples are from the [BindCraft GitHub README.md](https://github.com/cytokineking/FreeBindCraft/blob/master/README.md)

Start an interactive job with a GPU e.g.
NOTE: BindCraft only uses one GPU

```
salloc --cluster=ub-hpc --partition=debug --qos=debug \
 --account="[SlurmAccountName]" --mem=128GB --nodes=1 --cpus-per-task=1 \
 --tasks-per-node=12 --gpus-per-node=1 --time=01:00:00
```

Sample output:

> ```
> salloc: Pending job allocation 21408161
> salloc: job 21408161 queued and waiting for resources
> salloc: job 21408161 has been allocated resources
> salloc: Granted job allocation 21408161
> salloc: Nodes cpn-d01-39 are ready for job
> ```

Change to your BindCraft directory

```
cd /projects/academic/[YourGroupName]/BindCraft
```

Create the top level input and output directories

```
mkdir -p ./input ./output
```

Start the container:
Note that the AlphaFold 2 params files are mounted on /app/params inside the container.

```
apptainer shell \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 -B /util/software/data/alphafold/params:/app/params \
 -B ./input:/work/input,./output:/work/output \
 --nv \
 ./BindCraft_with_PyRosetta-$(arch).sif
```

Sample output:

> ```
> 
> GPU info:
> GPU 0: NVIDIA A40 (UUID: GPU-52ba81f0-dd77-1e16-417f-8c7218ee8bc6)
> 
> Apptainer> 
> ```

The following command is run from the "Apptainer> " prompt

```
source /singularity
```

Expected output:

> ```
> BindCraft> 
> ```

All the following commands are run from the "BindCraft> " prompt

Copy the sample input file

```
cp /app/example/PDL1.pdb /work/input/
```

Verify the copy:

```
ls -l /work/input/PDL1.pdb
```

Sample output:

> ```
> -rw-rw-r-- 1 [CCRusername] nogroup 74686 Sep 11 14:20 /work/input/PDL1.pdb
> ```

## Run OpenMM relax Sanity test

```
python3 /app/extras/test_openmm_relax.py /work/input/PDL1.pdb /work/output/relax_test
```

Sample output:

> ```
> --- Test Script: Starting Relaxations ---
> Input PDB: /work/input/PDL1.pdb
> Base Output PDB Path: /work/output/relax_test
> Cleaning input PDB file: /work/input/PDL1.pdb...
> Input PDB file cleaned successfully.
> Target OpenMM output: /work/output/relax_test_openmm.pdb
> Target PyRosetta output: /work/output/relax_test_pyrosetta.pdb
> 
> --- OpenMM Relax Run: single ---
> Platform: OpenCL
> Total seconds: 8.79
> Initial minimization seconds: 0.22
> Ramp count: 3, MD steps/shake: 5000
> Best energy (kJ/mol): -20230.12
>   Stage 1: md_steps=5000, md_s=0.87, min_calls=5, min_s=1.09, E0=-20218.36831188202, Emd=-14389.742311477661, Efin=-20187.55224609375
>   Stage 2: md_steps=5000, md_s=0.86, min_calls=5, min_s=1.32, E0=-20187.55224609375, Emd=-14475.73784828186, Efin=-20227.04603099823
>   Stage 3: md_steps=0, md_s=0.00, min_calls=5, min_s=1.18, E0=-20227.04603099823, Emd=None, Efin=-20230.118795394897
> OpenMM Relaxed PDB saved to: /work/output/relax_test_openmm.pdb
> 
> --- Starting PyRosetta Relaxation ---
> Initializing PyRosetta...
> ┌───────────────────────────────────────────────────────────────────────────────┐
> │                                  PyRosetta-4                                  │
> │               Created in JHU by Sergey Lyskov and PyRosetta Team              │
> │               (C) Copyright Rosetta Commons Member Institutions               │
> │                                                                               │
> │ NOTE: USE OF PyRosetta FOR COMMERCIAL PURPOSES REQUIRES PURCHASE OF A LICENSE │
> │          See LICENSE.PyRosetta.md or email license@uw.edu for details         │
> └───────────────────────────────────────────────────────────────────────────────┘
> PyRosetta-4 2025 [Rosetta PyRosetta4.conda.ubuntu.cxx11thread.serialization.Ubuntu.python310.Release 2025.37+release.df75a9c48e763e52a7aa3f5dfba077f4da88dbf5 2025-09-03T12:23:30] retrieved from: http://www.pyrosetta.org
> PyRosetta initialized successfully for the test script.
> PyRosetta is available. Calling pr_relax function for /work/output/relax_test_pyrosetta.pdb...
> pr_relax function completed.
> PyRosetta Relaxed PDB saved to: /work/output/relax_test_pyrosetta.pdb
> 
> --- Test Script: Finished ---

> ```

The output for the run is in the ./output directory

```
ls -l ./output/relax_test_*
```

Sample output:

> ```
> -rw-rw-r-- 1 [CCRusername] nogroup 150101 Sep 11 14:25 ./output/relax_test_openmm.pdb
> -rw-rw-r-- 1 [CCRusername] nogroup 150093 Sep 11 14:25 ./output/relax_test_pyrosetta.pdb
> ```

Exit the container

```
exit
```

Sample output:

> ```
> exit
> [CCRusername]@cpn-d01-39$
> ```

Exit the Slurm job

```
exit
```

Sample output:

> ```
> logout
> salloc: Relinquishing job allocation 21408161
> salloc: Job allocation 21408161 has been revoked.
> [CCRusername]@login1$ 
> ````

## Long Example run

Start an interactive job with a GPU e.g.
NOTE: BindCraft only uses one GPU (however, see [Using Multiple GPUs](#using-multiple-gpus) for work
rounds with a Slurm job)

For this example, the runtime is set to eight hours, however such a run
is better suited to a Slurm job.
The job will not complete in this time, but, as per:
https://github.com/martinpacesa/BindCraft/issues/258
and:
restarting the job with the same input & output parameters should continue
the run.

```
salloc --cluster=ub-hpc --partition=general-compute --qos=general-compute \
 --account="[SlurmAccountName]" --mem=128GB --nodes=1 --cpus-per-task=1 \
 --tasks-per-node=12 --gpus-per-node=1 --time=08:00:00
```

Sample output:

> ```
> salloc: Pending job allocation 21409013
> salloc: job 21409013 queued and waiting for resources
> salloc: job 21409013 has been allocated resources
> salloc: Granted job allocation 21409013
> salloc: Nodes cpn-q07-20 are ready for job
> ```

Note the Slurm job id, "21409013" in this case, if you want to monitor the
GPU utilization

Change to your BindCraft directory

```
cd /projects/academic/[YourGroupName]/BindCraft
```

Create the top level input and output directories

```
mkdir -p ./input ./output
```

Start the container:

```
apptainer shell \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 -B /util/software/data/alphafold/params:/app/params \
 -B ./input:/work/input,./output:/work/output \
 --nv \
 ./BindCraft_with_PyRosetta-$(arch).sif
```

Sample output:

> ```
> 
> GPU info:
> GPU 0: Tesla V100-PCIE-32GB (UUID: GPU-88d8d1ca-8d0d-7333-0585-00e3c88b669c)
> 
> Apptainer> 
> ```

The following command is run from the "Apptainer> " prompt

```
source /singularity
```

Expected output:

> ```
> BindCraft> 
> ```

All the following commands are run from the "BindCraft> " prompt

Copy the settings file to the input directory

```
cp /app/settings_target/PDL1.json /work/input/
```

Verify the copy:

```
ls -l /work/input/PDL1.json
```

Sample output:

> ```
-rw-rw-r-- 1 [CCRusername] nogroup 74686 Sep 11 14:35 /work/input/PDL1.json
> ```

The output path is set by the "design_path" variable in this file

```
grep design_path /work/input/PDL1.json
```

Sample output:

> ```
>     "design_path": "/work/output/",
> ```

Create the output directory:

```
mkdir -p /work/output/pdl1
```

...then modify the output path by changing the "design_path" variable to use
this path.  You can use "vim" or "nano" to do this inside the container, however
"sed" is used here so you can just cut & paste...

```
sed -E -i -e "/\"design_path\"/s|:.*$|: \"/work/output/pdl1/\",|" /work/input/PDL1.json
```

Since this is a JSON file, it is important to maintain the syntax of the file,
particularly the quotes " and the comma at the end of the line.  You can verify
the syntax by using the "jq" command to display the file, which will give errors
if the syntax is incorrect.

```
jq . /work/input/PDL1.json
```

Expected output:

> ```
> {
>   "design_path": "/work/output/pdl1/",
>   "binder_name": "PDL1",
>   "starting_pdb": "/app/example/PDL1.pdb",
>   "chains": "A",
>   "target_hotspot_residues": "56",
>   "lengths": [
>     65,
>     150
>   ],
>   "number_of_final_designs": 100
> }
> ```


```
python3 /app/bindcraft.py \
 --settings /work/input/PDL1.json \
 --filters /app/settings_filters/default_filters.json \
 --advanced /app/settings_advanced/default_4stage_multimer.json
```

Sample output:

> ```
> Open files limits OK (soft=65536, hard=65536)
> Available GPUs:
> NVIDIA V100: gpu
> ┌───────────────────────────────────────────────────────────────────────────────┐
> │                                  PyRosetta-4                                  │
> │               Created in JHU by Sergey Lyskov and PyRosetta Team              │
> │               (C) Copyright Rosetta Commons Member Institutions               │
> │                                                                               │
> │ NOTE: USE OF PyRosetta FOR COMMERCIAL PURPOSES REQUIRES PURCHASE OF A LICENSE │
> │          See LICENSE.PyRosetta.md or email license@uw.edu for details         │
> └───────────────────────────────────────────────────────────────────────────────┘
> PyRosetta-4 2025 [Rosetta PyRosetta4.conda.ubuntu.cxx11thread.serialization.Ubuntu.python310.Release 2025.37+release.df75a9c48e763e52a7aa3f5dfba077f4da88dbf5 2025-09-03T12:23:30] retrieved from: http://www.pyrosetta.org
> PyRosetta initialized successfully.
> Running binder design for target PDL1
> Design settings used: default_4stage_multimer
> Filtering designs based on default_filters
> Starting trajectory: PDL1_l89_s972985
> Stage 1: Test Logits
> 1 models [0] recycles 1 hard 0 soft 0.02 temp 1 loss 10.45 helix 1.42 pae 0.78 i_pae 0.77 con 4.55 i_con 4.25 plddt 0.30 ptm 0.54 i_ptm 0.11 rg 5.26
> 2 models [2] recycles 1 hard 0 soft 0.04 temp 1 loss 13.38 helix 1.97 pae 0.84 i_pae 0.84 con 4.96 i_con 4.00 plddt 0.28 ptm 0.54 i_ptm 0.09 rg 14.91
> 3 models [2] recycles 1 hard 0 soft 0.05 temp 1 loss 10.73 helix 1.08 pae 0.71 i_pae 0.70 con 4.59 i_con 3.94 plddt 0.42 ptm 0.54 i_ptm 0.14 rg 6.90
> [...]
> ```


Note that the output for the run will be in the "./output/pdl1/" directory tree

```
ls -l ./output/pdl1/
```

Sample output:

> ```
> total 12
> drwxrwsr-x 2 [CCRusername] nogroup 4096 Sep  9 16:35 Accepted
> -rw-rw-r-- 1 [CCRusername] nogroup 1116 Sep  9 16:35 failure_csv.csv
> -rw-rw-r-- 1 [CCRusername] nogroup 3890 Sep  9 16:35 final_design_stats.csv
> drwxrwsr-x 2 [CCRusername] nogroup 4096 Sep  9 16:35 MPNN
> -rw-rw-r-- 1 [CCRusername] nogroup 3885 Sep  9 16:35 mpnn_design_stats.csv
> drwxrwsr-x 2 [CCRusername] nogroup 4096 Sep  9 16:35 Rejected
> -rw-rw-r-- 1 [CCRusername] nogroup 1004 Sep  9 16:35 rejected_mpnn_full_stats.csv
> drwxrwsr-x 2 [CCRusername] nogroup 4096 Sep  9 16:35 Trajectory
-rw-rw-r-- 1 [CCRusername] nogroup  592 Sep  9 16:35 trajectory_stats.csv
> ```

## Monitor the GPU activity of the job

You can monitor the GPU utilization while the job is running.  You need the
Slurm job id for this ("squeue --me" will list your Slurm jobs.)

Log into vortex in another terminal window and from there use the Slurm
job id in the following command:

```
srun --jobid="21409013" --export=HOME,TERM,SHELL --pty /bin/bash --login
```

Sample output:

> ```
> CCRusername@cpn-q07-20:~$
> ```

Show the GPU in the Slurm job:

```
nvidia-smi -L
```

Sample output:

> ```
> GPU 0: Tesla V100-PCIE-32GB (UUID: GPU-88d8d1ca-8d0d-7333-0585-00e3c88b669c)
> ```

Monitor the GPU activity:

```
nvidia-smi -l
```

Sample output:

> ```
> Tue Sep  9 16:43:12 2025       
> +-----------------------------------------------------------------------------------------+
> | NVIDIA-SMI 570.133.20             Driver Version: 570.133.20     CUDA Version: 12.8     |
> |-----------------------------------------+------------------------+----------------------+
> | GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
> | Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
> |                                         |                        |               MIG M. |
> |=========================================+========================+======================|
> |   0  Tesla V100-PCIE-32GB           On  |   00000000:3B:00.0 Off |                    0 |
> |  0%   58C    P0            250W /  250W |   34501MiB /  32768MiB |    100%      Default |
> |                                         |                        |                  N/A |
> +-----------------------------------------+------------------------+----------------------+
>                                                                                          
> +-----------------------------------------------------------------------------------------+
> | Processes:                                                                              |
> |  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
> |        ID   ID                                                               Usage      |
> |=========================================================================================|
> |    0   N/A  N/A         1028955      C   python3                               34492MiB |
> +-----------------------------------------------------------------------------------------+
> [...]
> ```

The GPU utilization should be 100% for the majority of the time.

## Using Multiple GPUs

As per https://github.com/martinpacesa/BindCraft/issues/258
you can use Slurm job arrays to utilize multiple GPUs.
HOWEVER, this will require a patch that is (at the time of writing) neither in
FreeBindCraft nor the upstream BindCraft - see:
https://github.com/martinpacesa/BindCraft/pull/264
Currently this patch needs changes before it could be merged into BindCraft

Once these changes are in the code, using the following lines in a BindCraft
Slurm script will run 120 Slurm array jobs, running a maximum of 2 array jobs
at a time, hence using 2 GPUs at the same time (if the necessary resources are
available.)

``` 
> [...]
> #SBATCH --gpus-per-node=1
> #SBATCH --array=0-119%2
> [...]
```

