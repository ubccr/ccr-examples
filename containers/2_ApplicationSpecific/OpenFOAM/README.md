# Example OpenFOAM container

Please Note: Graphical output (paraFoam) will only display in an [OnDemand portal](https://ondemand.ccr.buffalo.edu) session

## Building the container

A brief guide to building the OpenFOAM container follows:<br/>
Please refer to CCR's [container documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/) for more detailed information on building and using Apptainer.

1. Start an interactive job

Apptainer is not available on the CCR login nodes and the compile nodes may not provide enough resources for you to build a container.  We recommend requesting an interactive job on a compute node to conduct this build process.<br/>
See CCR docs for more info on [running jobs](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission)

```
salloc --cluster=ub-hpc --partition=debug --qos=debug --mem=64GB --time=01:00:00
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

You should now be on the compute node allocated to you.  In this example we're using our project directory for our build directory.  Ensure you've placed your `OpenFOAM-13.def` file in your build directory

```
cd /projects/academic/[YourGroupName]/OpenFOAM
export APPTAINER_CACHEDIR=${SLURMTMPDIR}
```

In the `OpenFOAM-13.def` file, change the FOAM_BASE_DIR on following line to
your projects directory:

> ```
>   export FOAM_BASE_DIR="/projects/academic/[YourGroupName]"
> ```

3. Build your container

```
apptainer build --fakeroot OpenFOAM-13-$(arch).sif OpenFOAM-13.def
```

sample truncated output:

> ```
> [....]
> INFO:    Adding environment to container
> INFO:    Creating SIF file...
> INFO:    Build complete: OpenFOAM-13-x86_64.sif
> ```

## Running the container

Start an interactive job e.g.

```
salloc --cluster=ub-hpc --partition=general-compute --qos=general-compute --mem=128GB --nodes=1 --cpus-per-task=1 --tasks-per-node=32 --time=05:00:00
```

...then run the container


```
cd /projects/academic/[YourGroupName]/OpenFOAM
apptainer shell -B /util:/util,/scratch:/scratch,/vscratch:/vscratch,/projects:/projects OpenFOAM-13-$(arch).sif
```

sample output:

> ```
> Run the following to use OpenFOAM:
>
>
> source /opt/openfoam13/etc/bashrc && mkdir -p "${FOAM_RUN}" "${FOAM_JOB_DIR}"
>
> Apptainer>
> ```

All the following commands are run from the "Apptainer> " prompt

Copy the line from above to use OpenFOAM

```
source /opt/openfoam13/etc/bashrc && mkdir -p "${FOAM_RUN}" "${FOAM_JOB_DIR}"
```

Verify OpenFOAM is installed:

```
foamVersion
```

Expected output:

> ```
> OpenFOAM-13
> ```

All non GUI OpenFOAM commands, such as "blockMesh" and "foamRun" can be run
in an interactive Slurm job like this.

Note that "paraFoam" is a GUI application, so it must be run in an
[OnDemand portal](https://ondemand.ccr.buffalo.edu) session and generally
requires at least 128GB of memory to run.  "paraFoam" also requires extra
bind mount options for apptainer - See the [EXAMPLES file](./EXAMPLES.md#parafoam) for
the apptainer command to use "paraFoam"


## Parallel OpenFOAM

Note that OpenFOAM can run an MPI job inside the container, however the number of
cores used is entirely dependent on how the decomposition is defined in the
decomposeParDict file.

See the [OpenFOAM Parallel Documentation](https://www.openfoam.com/documentation/user-guide/3-running-applications/3.2-running-applications-in-parallel) for more information.

It is theoretically possible to run the decomposition over multiple nodes, but
not from inside the container, and the number of cores used is always bound by
the decomposeParDict file.

Slurm script examples:

[OpenFOAM with "srun"](https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/OpenFOAM/slurm_OpenFOAM_example.bash)

See the [OpenFOAM website][https://openfoam.org) and the [OpenFOAM version 13 User Guide](https://doc.cfd.direct/openfoam/user-guide-v13/index) for more information on OpenFOAM
