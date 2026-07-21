# Example MATLAB containers

MATLAB is a suite of commercial prorgams from [MathWorks](https://www.mathworks.com/products/matlab.html)  
CCR has a license for academic use of serveral MATLAB programs, but you MUST meet MathWorks eligability contraints to use the CCR license.  


## Building the container

A brief guide to building the MATLAB container follows:  
Please refer to CCR's [container documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/) for more detailed information on building and using Apptainer.

1. Start an interactive job

Apptainer is not available on the CCR login nodes and the compile nodes may not provide enough resources for you to build a container.  We recommend requesting an interactive job on a compute node to conduct this build process.  
Note: a GPU is NOT needed to build the MATLAB container  
See CCR docs for more info on [running jobs](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission)

```
export SBATCH_ACCOUNT="[SlurmAccountName]"
```

```
salloc --cluster=ub-hpc --partition=debug --qos=debug --mem=0 --exclusive \
 --time=01:00:00
```

sample outout:

> ```
> salloc: Granted job allocation 25260020
> salloc: Nodes cpn-b04-32-01 are ready for job
> CCRusername@cpn-b04-32-01$ 
> ```

2. Navigate to your build directory and use the Slurm job local temporary directory for cache

You should now be on the compute node allocated to you.  
In this example we're using our project directory for our build directory.  

Change to your MATLAB directory

```
cd /projects/academic/[YourGroupName]/MATLAB
```

We have provided two different build examples:  
A parallel minimal install with only the "MATLAB" and "Parallel Computing Toolbox" products  
A maximal install, with all the products for which CCR currenlty has a license

If you wish to install a specific subset of products, download the maximal
install example and remove the products you do not need from the "


Select ONE of the following:

### Parallel MATLAB minimal install

```
curl -LO https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/MATLAB/matlab_lmutil_x86_64
curl -LO https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/MATLAB/MATLAB-R2025b.def
```

### MATLAB maximal install

```
curl -LO https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/MATLAB/matlab_lmutil_x86_64
curl -L -o MATLAB-R2025b.def https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/MATLAB/MATLAB-R2025b-all_licenced_products.def
```

3. Build your container

Set the apptainer cache dir:

```
export APPTAINER_CACHEDIR="${SLURMTMPDIR}"
```

Building the MATLAB container takes about half an hour...

```
apptainer build \
 --build-arg SLURMTMPDIR="${SLURMTMPDIR}" \
 --bind /scratch:/scratch \
 MATLAB-R2025b-$(arch).sif MATLAB-R2025b.def
```

Sample truncated output:

> ```
> [....]
> INFO:    Adding environment to container
> INFO:    Creating SIF file...
> INFO:    Build complete: MATLAB-x86_64.sif
> ```

## Running the container

Start an interactive job e.g.

```
export SBATCH_ACCOUNT="[SlurmAccountName]"
```

```
salloc --cluster=ub-hpc --partition=general-compute --qos=general-compute \
 --mem=128GB --nodes=1 --tasks-per-node=1 --cpus-per-task=16 \
 --time=01:00:00
```

Change to your MATLAB directory

```
cd /projects/academic/[YourGroupName]/MATLAB
```

Start the MATLAB container instance

```
apptainer shell \
 --no-env=XDG_DATA_DIRS \
 --writable-tmpfs \
 --bind /util:/util,/scratch:/scratch \
 --bind /vscratch/grp-[YourGroupName]:/vscratch/grp-[YourGroupName] \
 --bind /projects/academic/[YourGroupName]:/projects/academic/[YourGroupName] \
 --bind /util/software/licenses/matlab.lic:/MATLAB/licenses/licenses.lic:ro \
 MATLAB-R2025b-$(arch).sif
```

All the following commands are run from the "Apptainer> " prompt

Verify MATLAB is installed:

```
matlab -h
```

Sample truncated output:

> ```
> 
>     Usage:  matlab [-h|-help] | [-n | -e]
>                    [v=variant]
>                    [-c licensefile] [-display Xdisplay | -nodisplay]
> [...]
>     -Ddebugger [options]    - Start debugger to debug MATLAB.
>     -nouserjavapath         - Ignore custom javaclasspath.txt and javalibrarypath.txt files.
> 
> ```

NOTE: To run the MATLAB GUI, start a [CCR OnDemand](https://ondemand.ccr.buffalo.edu/) session, open a terminal, then  
run the container as above, then, from the "Apptainer> " prompt, run "matlab"  

You can also check the status of the license server

```
lmstat
```

Sample output:

> ```
> lmstat - Copyright (c) 1989-2024 Flexera. All Rights Reserved.
> Flexible License Manager status on Fri 7/17/2026 13:31
> 
> License server status: 27000@license1.ccr.buffalo.edu
>     License file(s) on license1.ccr.buffalo.edu: /opt/licenses/MATLAB/license/license.lic:
> 
> license1.ccr.buffalo.edu: license server UP (MASTER) v11.19.6
> 
> Vendor daemon status (on license1.ccr.buffalo.edu):
> 
>        MLM: UP v11.19.6
> 
> ```

...and the status of all the individually licensed MATLAB products

```
lmstat -a
```

Sample truncated output:

> ```
> lmstat - Copyright (c) 1989-2024 Flexera. All Rights Reserved.
> Flexible License Manager status on Fri 7/17/2026 13:34
> 
> License server status: 27000@license1.ccr.buffalo.edu
>     License file(s) on license1.ccr.buffalo.edu: /opt/licenses/MATLAB/license/license.lic:
> 
> license1.ccr.buffalo.edu: license server UP (MASTER) v11.19.6
> 
> Vendor daemon status (on license1.ccr.buffalo.edu):
> 
>        MLM: UP v11.19.6
> Feature usage info:
> 
> Users of MATLAB_Distrib_Comp_Engine:  (Total of 100000 licenses issued;  Total of 0 licenses in use)
> 
> Users of MATLAB:  (Total of 10000 licenses issued;  Total of 3 licenses in use)
> 
>   
> "MATLAB" v54, vendor: MLM, expiry: 30-oct-2026
>   vendor_string: vi=0:at=200:ae=1:lu=200:lo=TH:ei=1233456:lr=1:ep=7:
>   floating license
> 
>     user1 cpn-b01-08-02.core.ccr.buffalo.edu /dev/pts/0 (v50) (license1.ccr.buffalo.edu/27000 16636), start Tue 7/14 23:35, PID: 3278807 
>     user2 cpn-d01-32.core.ccr.buffalo.edu /dev/pts/0 (v50) (license1.ccr.buffalo.edu/27000 40623), start Fri 7/17 10:20, PID: 2636405 
>     user2 cpn-d02-13.core.ccr.buffalo.edu /dev/pts/0 (v50) (license1.ccr.buffalo.edu/27000 17527), start Fri 7/17 10:58, PID: 56371 
> 
> Users of SIMULINK:  (Total of 10000 licenses issued;  Total of 0 licenses in use)
> 
> Users of MATLAB_5G_Toolbox:  (Total of 10000 licenses issued;  Total of 0 licenses in use)
> [...]
> Users of Wireless_Testbench:  (Total of 10000 licenses issued;  Total of 0 licenses in use)
> 
> ```

See the [EXAMPLES file](./EXAMPLES.md) for more info.  

## Sample Slurm scripts

### Parallel example:
[MATLAB parallel Slurm example script](https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/MATLAB/matlab-mp.bash)  

### GPU example:
[MATLAB GPU Slurm example script](https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/MATLAB/matlab-gpu.bash)  

## Documentation Resources

For more information on MATLAB see the [MATLAB Documentation](https://www.mathworks.com/help/matlab/index.html) and [MATLAB Examples](https://www.mathworks.com/help/matlab/examples.html)  

