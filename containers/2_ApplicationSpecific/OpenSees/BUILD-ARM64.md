# Build the OpenSees container on ARM64

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

```
salloc: Pending job allocation [JobID]
salloc: job [JobID] queued and waiting for resources
salloc: job [JobID] has been allocated resources
salloc: Granted job allocation [JobID]
salloc: Nodes [NodeID] are ready for job
CCRusername@[NodeID]:~$
```

Change to your OpenSees directory
The "OpenSees.def" file will already be in the directory if you have already built
on the x86_64 platform, if not, copy the file here.

```
cd /projects/academic/[YourGroupName]/OpenSees
```

Then set the apptainer cache dir:

```
export APPTAINER_CACHEDIR=${SLURMTMPDIR}
```

Build your container

Building the OpenSees container takes about half an hour

```
apptainer build OpenSees-$(arch).sif OpenSees.def
```

sample truncated output:

> ```
> [....]
> INFO:    Adding environment to container
> INFO:    Creating SIF file...
> INFO:    Build complete: OpenSees-aarch64.sif
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

Start an interactive job on an ARM64 node

```
tmp_file="$(mktemp)"
salloc --partition=arm64 --qos=arm64 --constraint=ARM64 --no-shell \
 --time=1:00:00  --nodes=1 --cpus-per-task=1 --tasks-per-node=32 \
 --mem=100G 2>&1 | tee "${tmp_file}"
SLURM_JOB_ID="$(head -1 "${tmp_file}" | awk '{print $NF}')"
rm "${tmp_file}"
srun --jobid="${SLURM_JOB_ID}" --export=HOME,TERM,SHELL --pty /bin/bash --login
```
Change to your OpenSees directory

```
cd /projects/academic/[YourGroupName]/OpenSees
```

...then start the OpenSees container instance

```
apptainer shell -B /util:/util,/scratch:/scratch,/projects:/projects OpenSees-$(arch).sif 
```

expected output:

> ```
> Apptainer> 
> ```

The following command is run from the "Apptainer> " prompt

```
OpenSees
```

expected output:

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
> OpenSees > 
> ```

Exit OpenSees

```
exit
```

expected output:

> ```
> Apptainer> 
> ```

Exit the Apptainer container instance

```
exit
```

sample outout:

> ```
> CCRusername@cpn-v14-19$ 
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

