# Example R container, based on the Rocker Project "r-ver" image

The [Rocker Project](https://rocker-project.org) provides a number of [GPL 2 or later](https://opensource.org/license/gpl-2-0) licenced ["R" containers](https://rocker-project.org/images/) 
This example is based on the [r-ver](https://rocker-project.org/images/versioned/r-ver.html) image which is, in turn, based on the [r-base](https://hub.docker.com/_/r-base) 
offical R image 
The [r-ver](https://rocker-project.org/images/versioned/r-ver.html) image uses Ubuntu LTS rather than Debian, with an emphasis on 
reproducibility.


## Building the container

A brief guide to building the R_rocker container follows:<br/>
Please refer to CCR's [container documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/) for more detailed information on building and using Apptainer.

NOTE: for building on the ARM64 platform see [BUILD-ARM64.md](./BUILD-ARM64.md)

1. Start an interactive job

Apptainer is not available on the CCR login nodes and the compile nodes may not provide enough resources for you to build a container.  We recommend requesting an interactive job on a compute node to conduct this build process.<br/>
See CCR docs for more info on [running jobs](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission)

```
tmp_file="$(mktemp)"
salloc --cluster=ub-hpc --partition=debug --qos=debug --no-shell --exclusive \
 --account="[SlurmAccountName]" --mem=0 --time=1:00:00 2>&1 | tee "${tmp_file}"
SLURM_JOB_ID="$(head -1 "${tmp_file}" | awk '{print $NF}')"
rm "${tmp_file}"
srun --jobid="${SLURM_JOB_ID}" --export=HOME,TERM,SHELL --pty /bin/bash --login
```

sample outout:

> ```
> salloc: Pending job allocation 22171515
> salloc: job 22171515 queued and waiting for resources
> salloc: job 22171515 has been allocated resources
> salloc: Granted job allocation 22171515
> salloc: Nodes cpn-d01-39 are ready for job
> CCRusername@pn-d01-39:~$ 
> ```

2. Navigate to your build directory and use the Slurm job local temporary directory for cache

You should now be on the compute node allocated to you. 
In this example we're using our project directory for our build directory.

Change to your R directory

```
cd /projects/academic/[YourGroupName]/R
```

Then set the apptainer cache dir:

```
export APPTAINER_CACHEDIR=${SLURMTMPDIR}
```

Download the .def file

```
test -f R_rocker_4.5.1.def || curl -o R_rocker_4.5.1.def https://raw.githubusercontent.com/tonykew/ccr-examples/refs/heads/R-Rocker_Project/containers/2_ApplicationSpecific/R-Rocker_Project/R_rocker_4.5.1.def
```

sample output:

> ```
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100  6126  100  6126    0     0  97501      0 --:--:-- --:--:-- --:--:-- 98806
> ```

3. Build your container

Building the R container takes about ten minutes

```
apptainer build --fakeroot R_rocker_4.5.1-$(arch).sif R_rocker_4.5.1.def
```

sample truncated output:

> ```
> [....]
> INFO:    Adding environment to container
> INFO:    Creating SIF file...
> INFO:    Build complete: R_rocker_4.5.1-x86_64.sif
> ```

Quick test of the new container .sif image

```
apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 R_rocker_4.5.1-$(arch).sif \
 R --version
````

Sample output:

> ```
> R version 4.5.1 (2025-06-13) -- "Great Square Root"
> Copyright (C) 2025 The R Foundation for Statistical Computing
> Platform: x86_64-pc-linux-gnu
> 
> R is free software and comes with ABSOLUTELY NO WARRANTY.
> You are welcome to redistribute it under the terms of the
> GNU General Public License versions 2 or 3.
> For more information about these matters see
> https://www.gnu.org/licenses/.
> 
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

4. Running the container

Start an interactive job e.g.

```
tmp_file="$(mktemp)"
salloc --cluster=ub-hpc --partition=general-compute --qos=general-compute \
 --no-shell --mem=128GB --nodes=1 --cpus-per-task=1 --tasks-per-node=12 \
 --account="[SlurmAccountName]" --time=5:00:00 2>&1 | tee "${tmp_file}"
SLURM_JOB_ID="$(head -1 "${tmp_file}" | awk '{print $NF}')"
rm "${tmp_file}"
srun --jobid="${SLURM_JOB_ID}" --export=HOME,TERM,SHELL --pty /bin/bash --login
```

sample outout:

> ```
> salloc: Pending job allocation 22171524
> salloc: job 22171524 queued and waiting for resources
> salloc: job 22171524 has been allocated resources
> salloc: Granted job allocation 22171524
> salloc: Nodes cpn-d01-19 are ready for job
> ```

Change to your R directory

```
cd /projects/academic/[YourGroupName]/R
```

Start the R container instance

```
apptainer shell \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 ./R_rocker_4.5.1-$(arch).sif
```

All the following commands are run from the "Apptainer> " prompt
run R

```
R
```

Sampleoutput:

> ```
> 
> R version 4.5.1 (2025-06-13) -- "Great Square Root"
> Copyright (C) 2025 The R Foundation for Statistical Computing
> Platform: x86_64-pc-linux-gnu
> 
> R is free software and comes with ABSOLUTELY NO WARRANTY.
> You are welcome to redistribute it under certain conditions.
> Type 'license()' or 'licence()' for distribution details.
> 
>   Natural language support but running in an English locale
> 
> R is a collaborative project with many contributors.
> Type 'contributors()' for more information and
> 'citation()' on how to cite R or R packages in publications.
> 
> Type 'demo()' for some demos, 'help()' for on-line help, or
> 'help.start()' for an HTML browser interface to help.
> Type 'q()' to quit R.
> 
> > 
> ```

exit R from the ">" prompt with:

```
q()
```

Expected output

> ```
> Apptainer> 
> ```

Exit the Apptainer container instance
From the "Apptainer>" prompt:

```
exit
```

sample output:
> ```
> CCRusername@cpn-d01-39~$ 
> ```

Exit the Slurm interactive session

```
exit
```

sample output:

> ```
> logout
> CCRusername@login1$ 
> ```

End the Slurm job

```
scancel "${SLURM_JOB_ID}"
unset SLURM_JOB_ID
```


See the [EXAMPLES file](./EXAMPLES.md) for more info.

## Sample Slurm scripts

Slurm script examples:

### x86_64 example
[R example](https://raw.githubusercontent.com/tonykew/ccr-examples/refs/heads/R-Rocker_Project/containers/2_ApplicationSpecific/R-Rocker_Project/slurm_example.bash)  

### ARM64 example
[R ARM64 example](https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/R-Rocker_Project/containers/2_ApplicationSpecific/R-Rocker_Project/slurm_ARM64_example.bash)  


## Documentation Resources

For more information on R see the [R project website](https://www.r-project.org), the [R Documentation](https://www.r-project.org/other-docs.html),
the [Rocker Project website](https://rocker-project.org), the [Rocker Project Images](https://rocker-project.org/images), 
and the [Rocker Project Versioned 2 github repo](https://github.com/rocker-org/rocker-versioned2)

