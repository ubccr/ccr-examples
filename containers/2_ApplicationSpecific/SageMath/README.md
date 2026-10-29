# Example SageMath Container

In this example we'll demonstrate how to download and run the containerized version of [SageMath](https://www.sagemath.org/), a free open-source mathematics software system, on CCR's clusters using a container image available on [DockerHub](https://hub.docker.com/r/sagemath/sagemath?tag=10.10).

## Building the container

Please refer to CCR's [container documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/) for more detailed information on using and building with Apptainer.

1. Start an interactive job

> [!IMPORTANT]
> Apptainer is not available on the CCR login nodes and the compile nodes may not provide enough resources for you to build a container.  We recommend requesting an interactive job on a compute node to conduct this build process.<br/>
> See CCR docs for more info on [running jobs](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission).

```
salloc --cluster=ub-hpc --partition=debug --qos=debug --mem=16GB --exclusive --time=01:00:00
```

Sample output:
```
salloc: Pending job allocation [JobID]
salloc: job [JobID] queued and waiting for resources
salloc: job [JobID] has been allocated resources
salloc: Granted job allocation [JobID]
salloc: Nodes [NodeID] are ready for job
CCRusername@[NodeID]:~$
```

2. Navigate to your build directory & set up directories for cached data and temporary files
```
cd /projects/academic/[YourGroupName]/[CCRusername]/SageMath
export APPTAINER_CACHEDIR=="${SLURMTMPDIR}"
export APPTAINER_TMPDIR="${SLURMTMPDIR}"
```

3. Pull the container
```
apptainer pull sagemath-10.10-$(arch).sif docker://sagemath/sagemath:10.10
```

Expected output:
```
INFO:    Starting build...
...
INFO:    Inserting Apptainer configuration...
INFO:    Creating SIF file...
```
> [!NOTE]
> Building the SageMath container takes ~10 minutes.

## Run the container

Cancel the previous interactive job and start a fresh one, e.g.
```
salloc --cluster=ub-hpc --partition=general-compute --qos=general-compute --mem=16GB --nodes=1 --cpus-per-task=1 --tasks-per-node=32 --time=01:00:00
```

4. Set up the temporary files directory and run the container
```
export APPTAINER_TMPDIR="${SLURMTMPDIR}"
```
```
apptainer run --nv --no-env=XDG_DATA_DIRS \
 --bind /util:/util,/scratch:/scratch \
 --bind /projects/academic/[YourGroupName]:/projects/academic/[YourGroupName] sagemath-10.10-x86_64.sif
```

Expected prompt:
```
┌────────────────────────────────────────────────────────────────────┐
│ SageMath version 10.10, Release Date: 2026-09-28                   │
│ Using Python 3.12.3. Type "help()" for help.                       │
└────────────────────────────────────────────────────────────────────┘
sage:
```

5. Verify SageMath works as expected
```
sage: 2+3
# Expected output: 5
sage: print(sqrt(4)==2)
# Expected output: True
```

Refer to the official [SageMath](https://www.sagemath.org/) website for additional information on using SageMath.
