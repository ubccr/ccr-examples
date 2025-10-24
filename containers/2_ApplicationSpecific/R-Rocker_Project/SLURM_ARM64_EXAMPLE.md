# R_rocker ARM64 Slurm example

Change to your R directory

```
cd /projects/academic/[YourGroupName]/R
```

Download the slurm sample scrip and the exmaple R script [estimate_pi.R](https://raw.githubusercontent.com/tonykew/ccr-examples/refs/heads/R-Rocker_Project/containers/2_ApplicationSpecific/R-Rocker_Project/estimate_pi.R)
The example code is writen by Andrea Gustafsen - see:
https://rpubs.com/andrea_gustafsen/839901

```
test -f estimate_pi.R || curl -o estimate_pi.R https://raw.githubusercontent.com/tonykew/ccr-examples/refs/heads/R-Rocker_Project/containers/2_ApplicationSpecific/R-Rocker_Project/estimate_pi.R
test -f slurm_ARM64_example.bash || curl -o slurm_ARM64_example.bash https://raw.githubusercontent.com/tonykew/ccr-examples/refs/heads/R-Rocker_Project/containers/2_ApplicationSpecific/R-Rocker_Project/slurm_ARM64_example.bash
```

sample output:

> ```
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100   874  100   874    0     0  14616      0 --:--:-- --:--:-- --:--:-- 14813
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100  1268  100  1268    0     0   9810      0 --:--:-- --:--:-- --:--:--  9829
> ```

Modify the Slurm script - change the account to one that has access to the
"arm64" partition (see `slimits | grep arm64`)

For example:

```
slimits | grep arm64
```

sample output:

> ```
>     ub-hpc         ccradmintest   tkewtest                      	arm64,class,debug,eai-test,general-compute,industry,scavenger,viz
> ```

So my test account has access to the "arm64" partition using the account
"ccradmintest"

```
cat slurm_ARM64_example.bash
```

abridged sample output:

> ```
> [...]
> #SBATCH --account="ccradmintest"
> [...]
> ```

Submit the Slurm script

```
sbatch ./slurm_ARM64_example.bash
```

sample output:

> ```
> Submitted batch job 22179954 on cluster ub-hpc
> ```

The Slurm output file in this case is slurm-22179954.out
Once this Slurm job completed:

```
cat slurm-22179954.out
```

> ```
>       10      100     1000    10000    1e+05    1e+06    1e+07    1e+08 
> 2.400000 3.160000 3.184000 3.158400 3.138760 3.143816 3.141868 3.141650 
>    1e+09 
> 3.141679 
> ```

