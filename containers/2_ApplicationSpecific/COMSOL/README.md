# Example COMSOL containers

[COMSOL](https://www.comsol.com/products) Multiphysics&reg; is a commercial general-purpose simulation software suite

> [!WARNING]
> COMSOL is a suite of commercial programs.
> You MUST have appropriate licenses for every COMSOL product you use

UB software purchases (including software licenses) must go through a [UB-mandated approval process for software](https://www.buffalo.edu/sens/documentation/purchasing-software.html)  
Contact [Science and Engineering Node Services (SENS)](https://www.buffalo.edu/sens/documentation/purchasing-software.html) for assistance in purcasing COMSOL licenses.

SENS will host the COMSOL license for you, and provide the information
neede to create a client license file.

The license file will be something like this:

```bash
SERVER [hostname] 1719 1718
USE_SERVER
```

The following examples assume your license file is here:  
"/projects/academic/[YourGroupName]/COMSOL/COMSOL-SENS-license.dat"

CCR provides three pre-built COMSOL containers.  Which one you
choose will depend on whether you need to use MATLAB with COMSOL,
and if so, which MATLAB products you need.

> [!WARNING]
> UB's MATLAB licenses are for **academic purposes only** and can not be used by commercial users or researchers doing commercial work.  Roswell Park researchers and other commercial users should utilize their own license with MATLAB.

COMSOL (without MATLAB)"

```bash
/util/software/containers/x86_64/COMSOL64-x86_64.sif
```

COMSOL with minimal MATLAB including (only) the "MATLAB Parallel Computing Toolbox":

```bash
/util/software/containers/x86_64/COMSOL64-MATLAB-R2025b-x86_64.sif
```

COMSOL with MATLAB including all the UB licensed MATLAB products

```bash
/util/software/containers/x86_64/COMSOL64-MATLAB-R2025b-all_licenced_products-x86_64.sif
```


If these containers don't fit your needs, you can use the following
instructions to build a COMSOL container.


## Building the container

A brief guide to building the COMSOL container follows:  
Please refer to CCR's [container documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/) for more detailed information on building and using Apptainer.

1. Start an interactive job

Apptainer is not available on the CCR login nodes and the compile nodes may not provide enough resources for you to build a container.  We recommend requesting an interactive job on a compute node to conduct this build process.  
Note: a GPU is NOT needed to build the COMSOL container  
See CCR docs for more info on [running jobs](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission)

```bash
export SBATCH_ACCOUNT="[SlurmAccountName]"
```

```bash
salloc --cluster=ub-hpc --partition=debug --qos=debug --mem=0 --exclusive \
 --time=01:00:00
```

Sample outout:

> ```
> salloc: Granted job allocation 25260020
> salloc: Nodes cpn-b04-32-01 are ready for job
> CCRusername@cpn-b04-32-01$ 
> ```

2. Navigate to your build directory and use the Slurm job local temporary directory for cache

You should now be on the compute node allocated to you.  
In this example we're using our project directory for our build directory.  

Change to your COMSOL directory

```bash
cd /projects/academic/[YourGroupName]/COMSOL
```

We have provided three different build examples:  
"COMSOL" only  
"COMSOL" with a minimal "MATLAB" install including the "MATLAB Parallel Computing Toolbox"  
"COMSOL" with "MATLAB" including all the UB licenses MATLAB products


Select ONE of the following:

### COMSOL (without NMATLAB)

```bash
curl -LO https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/COMSOL/matlab_lmutil_x86_64
curl -LO https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/COMSOL/comsol64-setupconfig.ini
curl -LO https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/COMSOL/COMSOL64.def
```

### COMSOL with minimal MATLAB including (only) the "MATLAB Parallel Computing Toolbox"

```bash
curl -LO https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/COMSOL/matlab_lmutil_x86_64
curl -LO https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/COMSOL/comsol64-setupconfig.ini
curl -L -o COMSOL64.def https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/COMSOL/COMSOL64-MATLAB-R2025b.def
```

### COMSOL with MATLAB including all the UB licensed MATLAB products

```bash
curl -LO https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/COMSOL/matlab_lmutil_x86_64
curl -LO https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/COMSOL/comsol64-setupconfig.ini
curl -L -o COMSOL64.def https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/COMSOL/COMSOL64-MATLAB-R2025b-all_licenced_products.def
```

You will need two additional files in this directory:

Your COMSOL license file named "COMSOL-SENS-license.dat" - COMSOL will NOT
install without this.

The install zip file "COMSOL64_lnx.zip" which is available from SENS.


3. Build your container

Set the apptainer cache dir:

```bash
export APPTAINER_CACHEDIR="${SLURMTMPDIR}"
```

Building the COMSOL container takes about half an hour...

```bash
 apptainer build \
 --build-arg SLURMTMPDIR="${SLURMTMPDIR}" \
 --bind /scratch:/scratch \
 --bind $(pwd)/COMSOL64_lnx.zip:/COMSOL_build/COMSOL64_lnx.zip:ro \
 --bind $(pwd)/comsol64-setupconfig.ini:/COMSOL_build/setupconfig.ini:ro \
 --bind $(pwd)/COMSOL-SENS-license.dat:/COMSOL_build/license/license.dat:ro \
 COMSOL64-$(arch).sif COMSOL64.def
```

Sample truncated output:

> ```
> [....]
> INFO:    Adding environment to container
> INFO:    Creating SIF file...
> INFO:    Build complete: COMSOL64-x86_64.sif
> ```

## Running the container

Start an interactive job e.g.

```bash
export SBATCH_ACCOUNT="[SlurmAccountName]"
```

```bash
salloc --cluster=ub-hpc --partition=general-compute --qos=general-compute \
 --mem=128GB --nodes=1 --tasks-per-node=1 --cpus-per-task=16 \
 --time=01:00:00
```

Change to your COMSOL directory

```bash
cd /projects/academic/[YourGroupName]/COMSOL
```

Start the COMSOL container instance

For COMSOL without MALTAB

```bash
apptainer shell \
 --no-env=XDG_DATA_DIRS \
 --writable-tmpfs \
 --bind /util:/util,/scratch:/scratch \
 --bind /vscratch/grp-[YourGroupName]:/vscratch/grp-[YourGroupName] \
 --bind /projects/academic/[YourGroupName]:/projects/academic/[YourGroupName] \
 --bind /projects/academic/[YourGroupName]/COMSOL/COMSOL-SENS-license.dat:/COMSOL/license/license.dat:ro \
 COMSOL-R2025b-$(arch).sif
```

For COMSOL with MATLAB, using the UB MATLAB license file

```bash
apptainer shell \
 --no-env=XDG_DATA_DIRS \
 --writable-tmpfs \
 --bind /util:/util,/scratch:/scratch \
 --bind /vscratch/grp-[YourGroupName]:/vscratch/grp-[YourGroupName] \
 --bind /projects/academic/[YourGroupName]:/projects/academic/[YourGroupName] \
 --bind /util/software/licenses/matlab.lic:/MATLAB/licenses/licenses.lic:ro \
 --bind /projects/academic/[YourGroupName]/COMSOL/COMSOL-SENS-license.dat:/COMSOL/license/license.dat:ro \
 COMSOL-R2025b-$(arch).sif
```

All the following commands are run from the "Apptainer> " prompt

Verify COMSOL is installed:

```bash
comsol -h
```

Sample truncated output:

> ```
> Usage: comsol [options] [target] [target arguments]
>      
> COMSOL commands:
> 
>    comsol                       Run COMSOL Multiphysics Desktop
>    comsol batch                 Run a COMSOL job
>    comsol compile               Compile a model file for Java or compile an 
>                                   application into an executable application 
>                                   (the latter option requires COMSOL Compiler)
>    comsol mphclient             Run COMSOL Multiphysics Desktop client
>    comsol mphserver             Run COMSOL Multiphysics Server
>    comsol mphserver matlab      Run MATLAB with COMSOL Multiphysics Server
>    comsol hydra                 Run Hydra commands        
> [...]
> ```

NOTE: To run the COMSOL GUI, start a [CCR OnDemand](https://ondemand.ccr.buffalo.edu/) session, open a terminal, then  
run the container as above, then, from the "Apptainer> " prompt, run "comsol"  

You can also check the status of the license server

```bash
lmstat -c /COMSOL/license/license.dat
```

Sample output:

> ```
> lmstat - Copyright (c) 1989-2024 Flexera. All Rights Reserved.
> Flexible License Manager status on Tue 8/4/2026 11:14
> 
> License server status: [port]@license.server.host
>     License file(s) on license.server.host: /COMSOL/license/license.dat:
> 
> license.server.host: license server UP (MASTER) v11.19.6
> 
> Vendor daemon status (on license.server.host):
> 
>   LMCOMSOL: UP v11.19.6
> 
> ```

...and the status of all the individually licensed COMSOL products

```bash
lmstat -c /COMSOL/license/license.dat -a
```

Sample truncated output:

> ```
> Flexible License Manager status on Tue 8/4/2026 11:23
> 
> License server status: [port]@license.server.host
>     License file(s) on license.server.host: /COMSOL/license/license.dat:
>
> license.server.host: license server UP (MASTER) v11.19.6
>
> Vendor daemon status (on license.server.host):
>
>   LMCOMSOL: UP v11.19.6
> Feature usage info:
> 
> Users of SERIAL:  (Uncounted, node-locked)
> 
>   
> "SERIAL" v6.4, vendor: LMCOMSOL, expiry: permanent(no expiration date)
>   vendor_string: [...]
>   uncounted nodelocked license locked to NOTHING (hostid=ANY)
> 
>     user1 simulatorv3 DESKTOP-7S65DQL (v6.4) (license.server.host/[port]), start Sun 8/2 17:54, PID: 18304 
>     user1 SIMULATORV2 SIMULATORV2 (v6.4) (license.server.host/[port]), start Tue 8/4 10:12, PID: 33984 
> 
> Users of CFD:  (Total of 3 licenses issued;  Total of 0 licenses in use)
> 
> Users of CFDBATCH:  (Total of 3 licenses issued;  Total of 0 licenses in use)
> [...]
> Users of ACO:  (Total of 3 licenses issued;  Total of 0 licenses in use)
> 
> ```

See the [EXAMPLES file](./EXAMPLES.md) for more info.  

## Sample Slurm scripts

[COMSOL batch example script](slurm_COMSOL.bash)  

## Documentation Resources

For more information on COMSOL see the [COMSOL Documentation](https://www.comsol.com/documentation) and the [COMSOL Learning Center](https://www.comsol.com/support/learning-center)

