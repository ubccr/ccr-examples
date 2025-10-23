# R_rocker Example

Start an interactive job in the "debug" partition

```
tmp_file="$(mktemp)"
salloc --cluster=ub-hpc --partition=debug --qos=debug --no-shell \
 --nodes=1 --cpus-per-task=1 --tasks-per-node=6 --mem=36GB \
 --account="[SlurmAccountName]" --time=1:00:00 2>&1 | tee "${tmp_file}"
SLURM_JOB_ID="$(head -1 "${tmp_file}" | awk '{print $NF}')"
rm "${tmp_file}"
srun --jobid="${SLURM_JOB_ID}" --export=HOME,TERM,SHELL --pty /bin/bash --login
```

sample outout:

> ```
> salloc: Pending job allocation 22172066
> salloc: job 22172066 queued and waiting for resources
> salloc: job 22172066 has been allocated resources
> salloc: Granted job allocation 22172066
> salloc: Nodes cpn-d01-39 are ready for job
> CCRusername@cpn-d01-39~$ 
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

Download the exmaple R script [estimate_pi.R](https://raw.githubusercontent.com/tonykew/ccr-examples/refs/heads/R-Rocker_Project/containers/2_ApplicationSpecific/R-Rocker_Project/estimate_pi.R)
This code is writen by Andrea Gustafsen - see:
https://rpubs.com/andrea_gustafsen/839901

```
test -f estimate_pi.R || curl -o estimate_pi.R https://raw.githubusercontent.com/tonykew/ccr-examples/refs/heads/R-Rocker_Project/containers/2_ApplicationSpecific/R-Rocker_Project/estimate_pi.R
```

sample output:

> ```
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100   874  100   874    0     0   7536      0 --:--:-- --:--:-- --:--:--  7600
> ```

Run the R script
Note: This script takes about 2 minutes to run, during which there is no output

```
Rscript estimate_pi.R
```

Sample output:

> ```
>       10      100     1000    10000    1e+05    1e+06    1e+07    1e+08 
> 2.400000 3.160000 3.184000 3.158400 3.138760 3.143816 3.141868 3.141650 
>    1e+09 
> 3.141679 
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
> CCRusername@login1$ 
> ```

End the Slurm job

```
scancel "${SLURM_JOB_ID}"
unset SLURM_JOB_ID
``` 

