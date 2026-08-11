# Examples job runs based on the sample Slurm Parallel OpenSeesSP and OpenSeesMP scripts

The following examples were run on the ub-hpc cluster with the [ccrsoft/2024.04](https://docs.ccr.buffalo.edu/en/latest/software/releases/#ccr-software-environment-releases) software release


## OpenSeesSP example

```
module -t list

```

command output:

> ```
> [...]
> ccrsoft/2024.04
> ```

```
cat slurm_OpenSeesSP_example.bash 
```

command output:

> ```
> #!/bin/bash -l
> 
> #SBATCH --cluster=ub-hpc
> #SBATCH --partition=debug
> #SBATCH --qos=debug
> #SBATCH --account="ccradmintest"
> 
> ## NOTE: This is tested with the ccrsoft/2024.04 software release
> ##       The ccrsoft/2023.01 software release needs several work-rounds and will not
> ##       run on the emerald rapids or sapphire rapids nodes over Infiniband 
> 
> # Request Inifinband nodes
> #SBATCH --constraint="[EMERALD-RAPIDS-IB|SAPPHIRE-RAPIDS-IB|ICE-LAKE-IB|CASCADE-LAKE-IB]"
> 
> ## 30 minute runtime
> #SBATCH --time=00:30:00
> 
> ## This example uses two nodes with four cores each node
> #SBATCH --nodes=2
> #SBATCH --cpus-per-task=1
> #SBATCH --tasks-per-node=4 
> 
> ## Specify memory required per node.
> #SBATCH --mem=100GB
> 
> ## Get the OpenSeesSP example code
> if ! [ -d OpenSees ]
> then
>   git clone -q -b master https://github.com/OpenSees/OpenSees
> fi
> cd ./OpenSees/EXAMPLES/SmallSP
> 
> ## Use Infiniband
> export OMPI_MCA_pml="ucx"
> export OMPI_MCA_btl="self,vader,ofi"
> 
> ## Avoid possible auth & gds issues:
> export PMIX_MCA_psec="native"
> export PMIX_MCA_gds="hash"
> 
> ## Run the OpenSeesSP example over Infiniband
> srun --mpi=pmix \
>  --nodes=${SLURM_NNODES} \
>  --ntasks-per-node=${SLURM_NTASKS_PER_NODE} \
>  apptainer exec \
>  -B /util:/util,/scratch:/scratch,/projects/academic/[YourGroupName]:/projects \
>  --sharens \
>  /projects/academic/ccradmintest/tkewtest/OpenSees/OpenSees-$(arch).sif \
>  OpenSeesSP Example.tcl
> ```

Run the job:

```
sbatch ./slurm_OpenSeesSP_example.bash
```

sample command output:

> ```
> Submitted batch job 20286855 on cluster ub-hpc
> ```

Once the Slurm job has completed:

```
cat slurm-20286855.out 
```

sample command output:

> ```
> Secondary Process Running 4
> Secondary Process Running 7
> Secondary Process Running 5
> Secondary Process Running 6
> Primary Process Running OpenSees Interpreter 0
> Secondary Process Running 1
> Secondary Process Running 3
> Secondary Process Running 2
> 
> 
>          OpenSees -- Open System For Earthquake Engineering Simulation
>                  Pacific Earthquake Engineering Research Center
>                         Version 3.7.2 64-Bit
> 
>       (c) Copyright 1999-2016 The Regents of the University of California
>                               All Rights Reserved
>   (Copyright and Disclaimer @ http://www.berkeley.edu/OpenSees/copyright.html)
> 
> 
> Num Processors: 8
> DomainPartitioner::partition() - Start
> DomainPartitioner::partition - Successful partition. Now redistributing data accordingly.
>   * Identifying components to transfer.
>      + Elements.
>      + Nodes.
>      + Boundary Nodes.
>      + MP constraints.
>      + MP constraints (2nd pass).
>   * Sending nodes.
>   * Sending elements.
>   * Sending Load Patterns
>   * Sending homogeneous SP Constraints`
>   * Sending MP Constraints
> DomainPartitioner::partition() - Done
> EIGEN:              0.00447668904987931666               0.00447668904988048587  
> EIGEN:              0.00447668904987930192               0.00447668904988047373  
> NODEDISP 99:              0.85329409409949763532             0.85329409409945922160            -0.21282190742542650419
> ele1: -0.29657760925280662878
> Process Terminating
> Process Terminating 1
> Process Terminating 2
> Process Terminating 4
> Process Terminating 3
> Process Terminating 5
> Process Terminating 6
> Process Terminating 7
> ```

## OpenSeesMP Example


```
module -t list

```

command output:

> ```
> [...]
> ccrsoft/2024.04
> ```

```
cat slurm_OpenSeesMP_example.bash
```

command output:

> ```
> #!/bin/bash -l
> 
> #SBATCH --cluster=ub-hpc
> #SBATCH --partition=debug
> #SBATCH --qos=debug
> #SBATCH --account="ccradmintest"
> 
> ## NOTE: This is tested with the ccrsoft/2024.04 software release
> ##       The ccrsoft/2023.01 software release needs several work-rounds and will not
> ##       run on the emerald rapids or sapphire rapids nodes over Infiniband 
> 
> ## Request Inifinband nodes
> #SBATCH --constraint="[EMERALD-RAPIDS-IB|SAPPHIRE-RAPIDS-IB|ICE-LAKE-IB|CASCADE-LAKE-IB]"
> 
> ## 30 minute runtime
> #SBATCH --time=00:30:00
> 
> ## This example uses two nodes with thirty cores on each node
> #SBATCH --nodes=2
> #SBATCH --cpus-per-task=1
> #SBATCH --tasks-per-node=30
> 
> ## Specify memory required per node.
> #SBATCH --mem=100GB
> 
> ## Get the OpenSeesMP example code
> if ! [ -d OpenSees ]
> then
>   git clone -q -b master https://github.com/OpenSees/OpenSees
> fi
> cd ./OpenSees/EXAMPLES/SmallMP
> 
> ## Use Infiniband
> export OMPI_MCA_pml="ucx"
> export OMPI_MCA_btl="self,vader,ofi"
> 
> ## Avoid possible auth & gds issues:
> export PMIX_MCA_psec="native"
> export PMIX_MCA_gds="hash"
> 
> ## Run the OpenSeesMP example over Infiniband
> srun --mpi=pmix \
>  --nodes=${SLURM_NNODES} \
>  --ntasks-per-node=${SLURM_NTASKS_PER_NODE} \
>  apptainer exec \
>  -B /util:/util,/scratch:/scratch,/projects/academic/[YourGroupName]:/projects \
>  --sharens \
>  /projects/academic/ccradmintest/tkewtest/OpenSees/OpenSees-$(arch).sif \
>  OpenSeesMP Example.tcl
> ```

Remove any old output files:

```
rm -f OpenSees/EXAMPLES/SmallMP/GM/*.out
```

(this command has no output)


Run the job:

```
sbatch ./slurm_OpenSeesMP_example.bash
```

sample command output:

> ```
> Submitted batch job 20286856 on cluster ub-hpc
> ```

Once the Slurm job has completed:

```
cat slurm-20286856.out 
```

sample command output:

> ```
> 
> 
>          OpenSees -- Open System For Earthquake Engineering Simulation
>                  Pacific Earthquake Engineering Research Center
>                         Version 3.7.2 64-Bit
> 
>       (c) Copyright 1999-2016 The Regents of the University of California
>                               All Rights Reserved
>   (Copyright and Disclaimer @ http://www.berkeley.edu/OpenSees/copyright.html)
> 
> 
> 8 8 GM/A-PEL180.AT2
> 11 11 GM/A-TIN000.AT2
> 17 17 GM/B-ELC000.AT2
> 20 20 GM/B-ZAK360.AT2
> 24 24 GM/EUR090.AT2
> 9 9 GM/A-SHE009.AT2
> 5 5 GM/A-LVL090.AT2
> 13 13 GM/ANLA196.AT2
> 3 3 GM/A-LAD180.AT2
> 6 6 GM/A-MAM290.AT2
> 7 7 GM/A-PAS180.AT2
> 12 12 GM/A-ZAK360.AT2
> 0 0 GM/A-BEN360.AT2
> 1 1 GM/A-BPL160.AT2
> 23 23 GM/EIL-EW.AT2
> 25 25 GM/FOR090.AT2
> 27 27 GM/HAD-NS.AT2
> 21 21 GM/BAR315.AT2
> 22 22 GM/D-ZAK360.AT2
> 16 16 GM/B-BEN360.AT2
> 26 26 GM/GCN-WE.AT2
> 29 29 GM/HEN-E.AT2
> 19 19 GM/B-SHE009.AT2
> 15 15 GM/AZF225.AT2
> 14 14 GM/ANLCSOU.AT2
> 10 10 GM/A-SON303.AT2
> 2 2 GM/A-ELC180.AT2
> 28 28 GM/HAU000.AT2
> 4 4 GM/A-LVD000.AT2
> 18 18 GM/B-LAD180.AT2
> 31 31 GM/HWA002-N.AT2
> 38 38 GM/HWA058-N.AT2
> 41 41 GM/KAU020-N.AT2
> 44 44 GM/KAU054-N.AT2
> 47 47 GM/KAU086-N.AT2
> 57 57 GM/WGK-N.AT2
> 32 32 GM/HWA012-N.AT2
> 36 36 GM/HWA037-N.AT2
> 42 42 GM/KAU030-N.AT2
> 45 45 GM/KAU057-N.AT2
> 46 46 GM/KAU082-N.AT2
> 48 48 GM/NSK-E.AT2
> 50 50 GM/PBFEAS.AT2
> 54 54 GM/SGL-E.AT2
> 56 56 GM/SSD-E.AT2
> 51 51 GM/PFT135.AT2
> 53 53 GM/ROC-NS.AT2
> 55 55 GM/SHL000.AT2
> Process Terminating 59
> 33 33 GM/HWA013-N.AT2
> 58 58 GM/WTC-E.AT2
> 34 34 GM/HWA017-N.AT2
> 49 49 GM/NST-N.AT2
> 43 43 GM/KAU046-N.AT2
> 35 35 GM/HWA036-N.AT2
> 37 37 GM/HWA053-N.AT2
> 40 40 GM/KAU008-N.AT2
> 30 30 GM/HOS180.AT2
> 52 52 GM/RIO270.AT2
> 39 39 GM/ISE-WE.AT2
> GM/BAR315 OK
> Process Terminating 21
> GM/ANLCSOU OK
> Process Terminating 14
> GM/ANLA196 OK
> Process Terminating 13
> GM/AZF225 OK
> Process Terminating 15
> GM/PFT135 OK
> Process Terminating 51
> GM/PBFEAS OK
> Process Terminating 50
> GM/SHL000 OK
> Process Terminating 55
> GM/RIO270 OK
> Process Terminating 52
> GM/FOR090 OK
> Process Terminating 25
> GM/EUR090 OK
> Process Terminating 24
> GM/HAU000 OK
> Process Terminating 28
> GM/A-LVL090 OK
> Process Terminating 5
> GM/A-ELC180 OK
> Process Terminating 2
> GM/A-LVD000 OK
> Process Terminating 4
> GM/ISE-WE OK
> Process Terminating 39
> GM/B-SHE009 OK
> Process Terminating 19
> GM/A-SON303 OK
> Process Terminating 10
> GM/SGL-E OK
> GM/GCN-WE OK
> Process Terminating 54
> Process Terminating 26
> GM/B-BEN360 OK
> GM/A-TIN000 OK
> Process Terminating 16
> Process Terminating 11
> GM/A-PEL180 OK
> Process Terminating 8
> GM/ROC-NS OK
> GM/B-ELC000 OK
> Process Terminating 17
> Process Terminating 53
> GM/A-PAS180 OK
> Process Terminating 7
> GM/A-MAM290 OK
> Process Terminating 6
> GM/D-ZAK360 OK
> GM/HEN-E OK
> Process Terminating 22
> Process Terminating 29
> GM/A-SHE009 OK
> Process Terminating 9
> GM/A-ZAK360 OK
> Process Terminating 12
> GM/NSK-E OK
> Process Terminating 48
> GM/A-BPL160 OK
> Process Terminating 1
> GM/B-LAD180 OK
> Process Terminating 18
> GM/A-LAD180 OK
> Process Terminating 3
> GM/B-ZAK360 OK
> Process Terminating 20
> GM/A-BEN360 OK
> Duration 1345
> Process Terminating 0
> GM/HAD-NS OK
> Process Terminating 27
> GM/SSD-E OK
> GM/WTC-E OK
> Process Terminating 56
> Process Terminating 58
> GM/KAU082-N OK
> Process Terminating 46
> GM/KAU046-N OK
> Process Terminating 43
> GM/EIL-EW OK
> GM/WGK-N OK
> Process Terminating 23
> Process Terminating 57
> GM/HOS180 OK
> Process Terminating 30
> GM/NST-N OK
> Process Terminating 49
> GM/KAU008-N OK
> Process Terminating 40
> GM/HWA017-N OK
> Process Terminating 34
> GM/HWA053-N OK
> Process Terminating 37
> GM/KAU030-N OK
> Process Terminating 42
> GM/KAU057-N OK
> Process Terminating 45
> GM/HWA013-N OK
> Process Terminating 33
> GM/HWA012-N OK
> Process Terminating 32
> GM/KAU054-N OK
> Process Terminating 44
> GM/HWA036-N OK
> GM/HWA002-N OK
> Process Terminating 35
> Process Terminating 31
> GM/KAU020-N OK
> Process Terminating 41
> GM/HWA058-N OK
> Process Terminating 38
> GM/HWA037-N OK
> Process Terminating 36
> GM/KAU086-N OK
> Process Terminating 47
> ```

This job generates 59 output files (from the 59 imput *.AT2 files)

```
ls OpenSees/EXAMPLES/SmallMP/GM/*.out
```

abridged cpmmand output:

> ```
> OpenSees/EXAMPLES/SmallMP/GM/A-BEN360.out
> OpenSees/EXAMPLES/SmallMP/GM/A-BPL160.out
> OpenSees/EXAMPLES/SmallMP/GM/A-ELC180.out
> OpenSees/EXAMPLES/SmallMP/GM/A-LAD180.out
> [...]
> OpenSees/EXAMPLES/SmallMP/GM/SHL000.out
> OpenSees/EXAMPLES/SmallMP/GM/SSD-E.out
> OpenSees/EXAMPLES/SmallMP/GM/WGK-N.out
> OpenSees/EXAMPLES/SmallMP/GM/WTC-E.out
> ```


```
ls OpenSees/EXAMPLES/SmallMP/GM/*.out | wc -l
```

command output:

```
59
```

