# Build the R_rocker container on ARM64


## Building the container

1. Start an interactive job on an ARM64 node

```
tmp_file="$(mktemp)"
salloc --partition=arm64 --qos=arm64 --constraint=ARM64 --no-shell \
 --exclusive --time=1:00:00 2>&1 | tee "${tmp_file}"
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
> salloc: Nodes cpn-f06-38 are ready for job
> CCRusername@cpn-f06-38:~$ 
> ```

2. Navigate to your build directory and use the Slurm job local temporary directory for cache


Change to your R directory

```
cd /projects/academic/[YourGroupName]/R
```

Then set the apptainer cache dir:

```
export APPTAINER_CACHEDIR=${SLURMTMPDIR}
```

The `R_rocker_4.5.1.def` file will already be in the directory if you have already built
on the x86_64 platform, if not, download the .def file:

```
test -f R_rocker_4.5.1.def || curl -o R_rocker_4.5.1.def https://raw.githubusercontent.com/tonykew/ccr-examples/refs/heads/R-Rocker_Project/containers/2_ApplicationSpecific/R-Rocker_Project/R_rocker_4.5.1.def
```

sample output:

> ```
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100  6126  100  6126    0     0   103k      0 --:--:-- --:--:-- --:--:--  104k
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
> INFO:    Build complete: R_rocker_4.5.1-aarch64.sif
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

Start an interactive job on an ARM64 node
Notes: 
  R uses only one core, unless you specifically use functions that take
  advantage of multiple cores, such as the 'parallel' package.  This example
  allocates 6 cores, so apptainer has a thread for itself, plus a thread for
  each bind mount, leaving one core for the R process.  Request more cores if
  you are running parallel code.

  If you use R packages that uses CUDA, add the Slurm directive to request
  GPU(s) e.g. "--gpus-per-node=1" and add tht "--nv" opion to apptainer so the
  requested GPU(s) are available inside the container.

```
tmp_file="$(mktemp)"
salloc --partition=arm64 --qos=arm64 --constraint=ARM64 --no-shell \
 --nodes=1 --ntasks-per-node=1 --cpus-per-task=6 --mem=32GB \
 --time=1:00:00 2>&1 | tee "${tmp_file}"
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
> salloc: Nodes cpn-f06-38 are ready for job
> CCRusername@cpn-f06-38:~$
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

