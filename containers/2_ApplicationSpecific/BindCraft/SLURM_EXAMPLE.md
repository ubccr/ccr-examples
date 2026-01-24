# BindCraft Slurm Example

Change to your BindCraft directory

```
cd /projects/academic/[YourGroupName]/BindCraft
```

Copy the sample Slurm script "slurm_BindCraft_example.bash" to this directory
then modify for your use case.

You should change the SLURM cluster, partition, qos and account; then change
the "[YourGroupName]" in the cd command:

for example:

```
cat slurm_BindCraft_example.bash
```

abridged sample output:

> ```
> [...]
> ## Select a cluster, partition, qos and account that is appropriate for your use case
> ## Available options and more details are provided in CCR's documentation:
> ##   https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#slurm-directives-partitions-qos
> #SBATCH --cluster="ub-hpc"
> #SBATCH --partition="general-compute"
> #SBATCH --qos="general-compute"
> #SBATCH --account="ccradmintest"
> 
> [...]
> 
> ## change to the BindCraft directory
> cd /projects/academic/ccradmintest/BindCraft
> [...]
> ```

NOTE: You can add other Slurm options to either script.
For example, if you want to run on an H100 GPU (with 80GB RAM) add the
following to the script:

> ```
> #SBATCH --constraint="H100"
> ```

The script has a job runtime set to (the "general-compute" partition maximum
of) three days

> ```
> #SBATCH --time=3-00:00:00
> ```

The job will be incomplete after this runtime, but resubmitting the job 
(i.e. re-running /app/bindcraft.py with the identical settings file)
will continue the BindCraft run and should complete with the next run.

Since we know that the first Slurm job will run out of time, we make
note of the Slurm Job ID and submit a second Slurm job to run after the
first run completes:

```
sbatch ./slurm_BindCraft_example.bash
```

Sample output:

> ```
> Submitted batch job 21435656 on cluster ub-hpc
> ```

Submit the "follow on" job using the above Slurm Job ID


```
sbatch --dependency=afterany:21435656 ./slurm_BindCraft_example.bash
```

Sample output:

> ```
> Submitted batch job 21438459 on cluster ub-hpc
> ```

There will be two output files, one for each job containg the Slurm Job IDs,
in this case: "slurm-21435656.out" and "slurm-21438459.out"

Once both Slurm jobs are completed, change to your BindCraft directory:

```
cd /projects/academic/[YourGroupName]/BindCraft
```

...then cat the job output files
e.g.

```
cat slurm-21435656.out
```

Sample output:

> ```
> Running BindCraft on compute node: cpn-q09-20
> GPU info:
> GPU 0: Tesla V100-PCIE-32GB (UUID: GPU-54282c05-37f5-ccab-1be0-20bfd411efdd)
> [...]
> Stage 1: Test Logits
> 1 models [0] recycles 1 hard 0 soft 0.02 temp 1 loss 14.04 helix 2.08 pae 0.86 i_pae 0.88 con 4.90 i_con 4.19 plddt 0.30 ptm 0.48 i_ptm 0.10 rg 16.75
> 2 models [3] recycles 1 hard 0 soft 0.04 temp 1 loss 11.30 helix 0.97 pae 0.75 i_pae 0.79 con 4.18 i_con 4.01 plddt 0.43 ptm 0.49 i_ptm 0.11 rg 9.76
> [...]
> 70 models [4] recycles 1 hard 0 soft 0.80 temp 1 loss 5.04 helix 1.57 pae 0.32 i_pae 0.30 con 2.38 i_con 2.86 plddt 0.73 ptm 0.66 i_ptm 0.49 rg 0.22
> 71 models [0] recycles 1 hard 0 soft 0.84 temp 1 loss 5.49 helix 1.54 pae 0.37 i_pae 0.45 con 2.35 i_con 3.27 plddt 0.73 ptm 0.58 i_ptm 0.31 rg 0.26
> slurmstepd: error: *** JOB 21435656 ON cpn-q09-20 CANCELLED AT 2025-09-12T14:16:49 DUE TO TIME LIMIT ***
> ```

Note that, as expected, this job exceeded the three day walltime

```
cat slurm-21438459.out
```

Sample output:

> ```
> Running BindCraft on compute node: cpn-q07-24
> GPU info:
> GPU 0: Tesla V100-PCIE-32GB (UUID: GPU-b04a1b86-23ee-53c9-e4d1-80ac55520086)
> [...]
> Stage 1: Test Logits
> 1 models [3] recycles 1 hard 0 soft 0.02 temp 1 loss 10.71 helix 1.56 pae 0.80 i_pae 0.78 con 4.55 i_con 4.06 plddt 0.27 ptm 0.54 i_ptm 0.11 rg 6.83
> 2 models [4] recycles 1 hard 0 soft 0.04 temp 1 loss 9.42 helix 0.86 pae 0.71 i_pae 0.67 con 4.32 i_con 3.97 plddt 0.36 ptm 0.55 i_ptm 0.13 rg 3.10
> [...]
> BindCraft run completed successfully
> ```

The BindCraft output files are (in this case) in the ./output/pdl1/ directory
tree

```
ls -laR ./output/pdl1/
```

Sample output:

> ```
> output/pdl1/:
> total 1326
> drwxrwsr-x 2 [CCRusername] [YourGroupName]   4096 Sep  9 11:32 .
> drwxrwsr-x 2 [CCRusername] [YourGroupName]   4096 Sep 15 15:27 ..
> drwxrwsr-x 2 [CCRusername] [YourGroupName]   4096 Sep 13 11:31 Accepted
> -rw-rw-r-- 1 [CCRusername] [YourGroupName]   1137 Sep 13 11:09 failure_csv.csv
> -rw-rw-r-- 1 [CCRusername] [YourGroupName] 151849 Sep 13 11:32 final_design_stats.csv
> drwxrwsr-x 2 [CCRusername] [YourGroupName]   4096 Sep 13 11:31 MPNN
> -rw-rw-r-- 1 [CCRusername] [YourGroupName] 701197 Sep 13 11:31 mpnn_design_stats.csv
> drwxrwsr-x 2 [CCRusername] [YourGroupName]   4096 Sep 13 11:09 Rejected
> -rw-rw-r-- 1 [CCRusername] [YourGroupName] 428916 Sep 13 11:09 rejected_mpnn_full_stats.csv
> drwxrwsr-x 2 [CCRusername] [YourGroupName]   4096 Sep 13 11:32 Trajectory
> -rw-rw-r-- 1 [CCRusername] [YourGroupName]  73494 Sep 13 11:27 trajectory_stats.csv
> 
> output/pdl1/Accepted:
> total 29610
> drwxrwsr-x 2 [CCRusername] [YourGroupName]   4096 Sep 13 11:31 .
> drwxrwsr-x 2 [CCRusername] [YourGroupName]   4096 Sep  9 11:32 ..
> drwxrwsr-x 2 [CCRusername] [YourGroupName]   4096 Sep 13 11:30 Animation
> -rw-rw-r-- 1 [CCRusername] [YourGroupName] 291091 Sep 11 06:33 PDL1_l102_s374445_mpnn1_model1.pdb
> -rw-rw-r-- 1 [CCRusername] [YourGroupName] 291172 Sep 11 06:35 PDL1_l102_s374445_mpnn2_model1.pdb
> -rw-rw-r-- 1 [CCRusername] [YourGroupName] 292063 Sep 13 02:31 PDL1_l103_s967444_mpnn5_model1.pdb
> [...]
> output/pdl1/Trajectory/Relaxed:
> total 33876
> drwxrwsr-x 2 [CCRusername] [YourGroupName]   4096 Sep 13 11:26 .
> drwxrwsr-x 2 [CCRusername] [YourGroupName]   4096 Sep 13 11:32 ..
> -rw-rw-r-- 1 [CCRusername] [YourGroupName] 288094 Sep 13 03:19 PDL1_l101_s944021.pdb
> -rw-rw-r-- 1 [CCRusername] [YourGroupName] 290119 Sep 12 00:57 PDL1_l102_s245763.pdb
> [...]
> -rw-rw-r-- 1 [CCRusername] [YourGroupName] 290686 Sep  9 12:49 PDL1_l99_s308971.pdb
> -rw-rw-r-- 1 [CCRusername] [YourGroupName] 279265 Sep 10 20:41 PDL1_l99_s968849.pdb
> -rw-rw-r-- 1 [CCRusername] [YourGroupName] 287203 Sep 10 21:43 PDL1_l99_s978526.pdb
> ```

