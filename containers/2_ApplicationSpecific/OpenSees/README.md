# Example OpenSees container

Please Note: Graphical output will only display in an [OnDemand portal](https://ondemand.ccr.buffalo.edu) session

The ccrsoft/2024.04 software release was used for the build & run of the OpenSees container.

To set ccrsoft/2024.04 at the default:

```
echo "module-version ccrsoft/2024.04 default" > $HOME/.modulerc
```

...then logout & log back in.


## Building the container

A brief guide to building the OpenSees container follows:<br/>
Please refer to CCR's [container documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/) for more detailed information on building and using Apptainer.

NOTE: for building on the ARM64 platform see [BUILD-ARM64.md](./BUILD-ARM64.md)

1. Start an interactive job

Apptainer is not available on the CCR login nodes and the compile nodes may not provide enough resources for you to build a container.  We recommend requesting an interactive job on a compute node to conduct this build process.<br/>
See CCR docs for more info on [running jobs](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission)

```
salloc --cluster=ub-hpc --partition=debug --qos=debug --mem=64GB --time=01:00:00
```

sample outout:

```
salloc: Pending job allocation [JobID]
salloc: job [JobID] queued and waiting for resources
salloc: job [JobID] has been allocated resources
salloc: Granted job allocation [JobID]
salloc: Nodes [NodeID] are ready for job
CCRusername@[NodeID]:~$
```

2. Navigate to your build directory and use the Slurm job local temporary directory for cache

You should now be on the compute node allocated to you.  In this example we're using our project directory for our build directory.  Ensure you've placed your `OpenSees.def` file in your build directory

```
cd /projects/academic/[YourGroupName]/
export APPTAINER_CACHEDIR=${SLURMTMPDIR}
```

3. Build your container

```
apptainer build OpenSees-$(arch).sif OpenSees.def
```

sample truncated output:

> ```
> [....]
> INFO:    Adding environment to container
> INFO:    Creating SIF file...
> INFO:    Build complete: OpenSees.def-x86_64.sif
> ```

## Running the container

Start an interactive job e.g.

```
salloc --cluster=ub-hpc --partition=general-compute --qos=general-compute --mem=128GB --nodes=1 --cpus-per-task=1 --tasks-per-node=32 --time=05:00:00
```

...then run the container


```
cd /projects/academic/[YourGroupName]/
apptainer shell -B /util:/util,/scratch:/scratch,/projects:/projects OpenSees-$(arch).sif 
Apptainer> OpenSees


         OpenSees -- Open System For Earthquake Engineering Simulation
                 Pacific Earthquake Engineering Research Center
                        Version 3.7.2 64-Bit

      (c) Copyright 1999-2016 The Regents of the University of California
                              All Rights Reserved
  (Copyright and Disclaimer @ http://www.berkeley.edu/OpenSees/copyright.html)


OpenSees > 
```

## Parallel OpenSees

Parallel MPI jobs can be run with OpenSeesSP or OpenSeesMP

| Parallel MPI Options                 | Description |
|--------------------------------------|------------------------|
| OpenSeesSP | For Performing analysis of very large models. |
| OpenSeesMP | For Performing parameter studies or analysis of large models with user defined partitions |


Parallel Slurm script examples (X86_64):

[mainSP with "srun"](https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/OpenSees/slurm_OpenSeesSP_example.bash)  
[mainSP with "mpirun"](https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/OpenSees/slurm_OpenSeesSP_mpirun_example.bash)

[mainMP with "srun"](https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/OpenSees/slurm_OpenSeesMP_example.bash)  
[mainMP with "mpirun"](https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/OpenSees/slurm_OpenSeesMP_mpirun_example.bash)

Parallel ARM64 Slurm script examples:

[mainSP](https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/OpenSees/slurm_ARM64_OpenSeesSP_example.bash)  
[mainMP](https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/OpenSees/slurm_ARM64_OpenSeesMP_example.bash)


See the [OpenSees Documentation](https://opensees.github.io/OpenSeesDocumentation) website and the [OpenSees Parallel](https://opensees.berkeley.edu/OpenSees/parallel/parallel.php) website for more info on OpenSees  
For the Python documentation see the [OpenSeesPy](https://openseespydoc.readthedocs.io) website

