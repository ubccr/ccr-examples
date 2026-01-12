# BindCraft with PyRosetts Slurm Example

Change to your BindCraft directory

```
cd /projects/academic/[YourGroupName]/BindCraft
```

Copy the sample Slurm script [slurm_BindCraft_with_PyRosetta_example.bash](./slurm_BindCraft_with_PyRosetta_example.bash) to
this directory then modify for your use case.

You should change the SLURM cluster, partition, qos and account; then change
the "[YourGroupName]" in the cd command:

for example:

```
cat slurm_BindCraft_with_PyRosetta_example.bash
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
of) three days:

> ```
> #SBATCH --time=3-00:00:00
> ```

The job will be incomplete ater this runtime, but resubmitting the job 
(i.e. re-running /app/bindcraft.py with the identical settings file)
will continue the BindCraft run and should complete with the next run.

Since we know that the first Slurm job will run out of time, we make
note of the Slurm Job ID and submit a second Slurm job to run after the
first run completes:

```
sbatch ./slurm_BindCraft_with_PyRosetta_example.bash
```

Sample output:

> ```
> Submitted batch job 21507613 on cluster ub-hpc
> ```

Submit the "follow on" job using the above Slurm Job ID


```
sbatch --dependency=afterany:21507613 ./slurm_BindCraft_with_PyRosetta_example.bash
```

Sample output:

> ```
> Submitted batch job 21507614 on cluster ub-hpc
> ```

There will be two output files, one for each job containg the Slurm Job IDs,
in this case: slurm-21507613.out and slurm-21507614.out

Once both Slurm jobs are completed, change to your BindCraft directory:

```
cd /projects/academic/[YourGroupName]/BindCraft
```

...then cat the job output files
e.g.

```
cat slurm-21507613.out
```

Sample output:

> ```
> Running BindCraft on compute node: cpn-h25-29
> 
> GPU info:
> GPU 0: NVIDIA A100-PCIE-40GB (UUID: GPU-b5f2372f-bd99-dc66-1270-1b34ec7d2f1f)
> 
> Open files limits OK (soft=65536, hard=65536)
> Available GPUs:
> NVIDIA A100-PCIE-40GB1: gpu
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
> Starting trajectory: PDL1_l84_s935958
> Stage 1: Test Logits
> 1 models [1] recycles 1 hard 0 soft 0.02 temp 1 loss 9.91 helix 1.34 pae 0.79 i_pae 0.78 con 4.52 i_con 4.15 plddt 0.31 ptm 0.55 i_ptm 0.10 rg 3.80
> 2 models [1] recycles 1 hard 0 soft 0.04 temp 1 loss 9.38 helix 0.65 pae 0.67 i_pae 0.69 con 4.06 i_con 4.09 plddt 0.45 ptm 0.56 i_ptm 0.13 rg 3.31
> 3 models [2] recycles 1 hard 0 soft 0.05 temp 1 loss 8.69 helix 0.95 pae 0.65 i_pae 0.67 con 3.92 i_con 3.88 plddt 0.45 ptm 0.56 i_ptm 0.16 rg 2.51
> [...]
> Unmet filter conditions for PDL1_l88_s461145_mpnn7
> Unmet filter conditions for PDL1_l88_s461145_mpnn8
> slurmstepd: error: *** JOB 21507613 ON cpn-h25-29 CANCELLED AT 2025-09-18T18:57:26 DUE TO TIME LIMIT ***
> ```


```
cat slurm-21507614.out
```

Sample output:

> ```
> Running BindCraft on compute node: cpn-q07-20
> 
> GPU info:
> GPU 0: Tesla V100-PCIE-32GB (UUID: GPU-9aed1269-fe05-ca6a-6f44-56688afcbe50)
> 
> Open files limits OK (soft=65536, hard=65536)
> Available GPUs:
> Tesla V100-PCIE-32GB1: gpu
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
> Starting trajectory: PDL1_l133_s279404
> Stage 1: Test Logits
> 1 models [1] recycles 1 hard 0 soft 0.02 temp 1 loss 16.15 helix 2.11 pae 0.89 i_pae 0.88 con 5.05 i_con 3.99 plddt 0.28 ptm 0.46 i_ptm 0.09 rg 23.94
> 2 models [1] recycles 1 hard 0 soft 0.04 temp 1 loss 15.37 helix 1.50 pae 0.84 i_pae 0.83 con 4.64 i_con 3.93 plddt 0.37 ptm 0.47 i_ptm 0.18 rg 22.42
> 3 models [3] recycles 1 hard 0 soft 0.05 temp 1 loss 11.67 helix 1.12 pae 0.80 i_pae 0.83 con 4.42 i_con 4.24 plddt 0.39 ptm 0.46 i_ptm 0.10 rg 9.45
> [...]
> Base AF2 filters not passed for PDL1_l95_s421201_mpnn18, skipping full interface scoring.
> Base AF2 filters not passed for PDL1_l95_s421201_mpnn19, skipping full interface scoring.
> Unmet filter conditions for PDL1_l95_s421201_mpnn20
> Found 1 MPNN designs passing filters
> 
> Design and validation of trajectory PDL1_l95_s421201 took: 0 hours, 20 minutes, 26 seconds
> Target number 100 of designs reached! Reranking...
> Files in folder '/work/output/pdl1/Trajectory/Animation' have been zipped and removed.
> Files in folder '/work/output/pdl1/Trajectory/Plots' have been zipped and removed.
> Finished all designs. Script execution for 12 trajectories took: 5 hours, 8 minutes, 16 seconds
> 
> BindCraft run completed successfully
> ```

We can look at the runtime for these two jobs:

```
sacct --format="Elapsed" -j 21507613
```

Job 21507613 runtime info:

> ```
>    Elapsed 
> ---------- 
> 3-00:00:20 
> 3-00:00:21 
> 3-00:00:21 
> ```

```
sacct --format="Elapsed" -j 21507614
```

Job 21507614 runtime info:

> ```
>    Elapsed 
> ---------- 
>   05:09:05 
>   05:09:05 
>   05:09:05 
> ```

...so, unfortunately only a few hours beyond the 3 day queue limit.

The BindCraft output files are (in this case) in the ./output/pdl1/ directory
tree

```
ls -laR ./output/pdl1/
```

Sample output:

> ```
> output/pdl1/:
> total 2091
> drwxrwsr-x 2 tkewtest grp-ccradmintest    4096 Sep 15 15:28 .
> drwxrwsr-x 2 tkewtest grp-ccradmintest    4096 Sep 15 15:27 ..
> drwxrwsr-x 2 tkewtest grp-ccradmintest    4096 Sep 19 19:12 Accepted
> -rw-rw-r-- 1 tkewtest grp-ccradmintest    1144 Sep 19 19:28 failure_csv.csv
> -rw-rw-r-- 1 tkewtest grp-ccradmintest  154700 Sep 19 19:28 final_design_stats.csv
> drwxrwsr-x 2 tkewtest grp-ccradmintest    4096 Sep 19 19:28 MPNN
> -rw-rw-r-- 1 tkewtest grp-ccradmintest 1150297 Sep 19 19:28 mpnn_design_stats.csv
> drwxrwsr-x 2 tkewtest grp-ccradmintest    4096 Sep 19 19:28 Rejected
> -rw-rw-r-- 1 tkewtest grp-ccradmintest  726597 Sep 19 19:28 rejected_mpnn_full_stats.csv
> drwxrwsr-x 2 tkewtest grp-ccradmintest    4096 Sep 19 19:29 Trajectory
> -rw-rw-r-- 1 tkewtest grp-ccradmintest  106598 Sep 19 19:08 trajectory_stats.csv
> 
> output/pdl1/Accepted:
> total 29602
> drwxrwsr-x 2 tkewtest grp-ccradmintest   4096 Sep 19 19:12 .
> drwxrwsr-x 2 tkewtest grp-ccradmintest   4096 Sep 15 15:28 ..
> drwxrwsr-x 2 tkewtest grp-ccradmintest   4096 Sep 19 19:12 Animation
> -rw-rw-r-- 1 tkewtest grp-ccradmintest 291114 Sep 16 12:56 PDL1_l103_s466116_mpnn1_model2.pdb
> -rw-rw-r-- 1 tkewtest grp-ccradmintest 292167 Sep 16 13:02 PDL1_l103_s466116_mpnn9_model2.pdb
> -rw-rw-r-- 1 tkewtest grp-ccradmintest 292815 Sep 17 03:40 PDL1_l103_s530314_mpnn3_model1.pdb
> [...]
> output/pdl1/Trajectory/Relaxed:
> total 49282
> drwxrwsr-x 2 tkewtest grp-ccradmintest   4096 Sep 19 19:07 .
> drwxrwsr-x 2 tkewtest grp-ccradmintest   4096 Sep 19 19:29 ..
> -rw-rw-r-- 1 tkewtest grp-ccradmintest 281880 Sep 17 11:44 PDL1_l100_s775462.pdb
> -rw-rw-r-- 1 tkewtest grp-ccradmintest 289899 Sep 17 10:29 PDL1_l101_s615526.pdb
> -rw-rw-r-- 1 tkewtest grp-ccradmintest 284796 Sep 17 19:04 PDL1_l101_s96790.pdb
> [...]
> -rw-rw-r-- 1 tkewtest grp-ccradmintest 281394 Sep 18 08:09 PDL1_l98_s487657.pdb
> -rw-rw-r-- 1 tkewtest grp-ccradmintest 280260 Sep 16 11:58 PDL1_l98_s617776.pdb
> -rw-rw-r-- 1 tkewtest grp-ccradmintest 281637 Sep 16 01:27 PDL1_l98_s684300.pdb
> ```

