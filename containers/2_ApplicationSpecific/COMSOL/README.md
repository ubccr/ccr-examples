# Example COMSOL containers

[COMSOL](https://www.comsol.com/products) Multiphysics&reg; is a commercial general-purpose simulation software suite

> [!WARNING]
> COMSOL is a suite of commercial programs.
> You MUST have appropriate licenses for every COMSOL product you use

UB software purchases (including software licenses) must go through a [UB-mandated approval process for software](https://www.buffalo.edu/sens/documentation/purchasing-software.html)  
Contact [Science and Engineering Node Services (SENS)](https://www.buffalo.edu/sens/documentation/purchasing-software.html) for assistance in purchasing COMSOL licenses.

SENS will host the COMSOL license for you, and provide the information
needed to create a client license file.

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

COMSOL (without MATLAB):"

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


# Running a COMSOL container instance

Start an interactive job e.g.

```bash
export SBATCH_ACCOUNT="[SlurmAccountName]"
```

```bash
salloc --cluster=ub-hpc --partition=general-compute --qos=general-compute \
 --mem=128GB --nodes=1 --tasks-per-node=1 --cpus-per-task=16 \
 --time=01:00:00
```

Set "PROJECTS_DIR" to the path to your projects directory
e.g.

```bash
export PROJECTS_DIR="/projects/academic/[YourGroupName]"
```

You will need your COMSOL license file here:
`${PROJECTS_DIR}/COMSOL/COMSOL-SENS-license.dat`

Pick one of the three following options:  
[COMSOL without MATLAB](#comsol-without-matlab)  
[COMSOL with minimal MATLAB](#comsols-with-minimal-matlab)  
[COMSOL with MATLAB including all the UB licensed MATLAB products[(#comsols-with-matlab-including-all-the-UB-licensed-matlab-products)


## COMSOL without MATLAB

```bash
apptainer shell \
 --no-env=XDG_DATA_DIRS \
 --writable-tmpfs \
 --bind "/util":"/util","/scratch":"/scratch" \
 --bind "${PROJECTS_DIR}":"${PROJECTS_DIR}" \
 --bind "${PROJECTS_DIR}/COMSOL/COMSOL-SENS-license.dat":"/COMSOL/license/license.dat":ro \
 /util/software/containers/x86_64/COMSOL64-x86_64.sif
```

## COMSOL with minimal MATLAB
The only optional MATLAB product installed in this container is the
"MATLAB Parallel Computing Toolbox"

```bash
apptainer shell \
 --no-env=XDG_DATA_DIRS \
 --writable-tmpfs \
 --bind /util:/util,/scratch:/scratch \
 --bind "/util":"/util","/scratch":"/scratch" \
 --bind "${PROJECTS_DIR}":"${PROJECTS_DIR}" \
 --bind "/util/software/licenses/matlab.lic":"/MATLAB/licenses/licenses.lic":ro \
 --bind "${PROJECTS_DIR}/COMSOL/COMSOL-SENS-license.dat":"/COMSOL/license/license.dat":ro \
 /util/software/containers/x86_64/COMSOL64-MATLAB-R2025b-x86_64.sif
```

## COMSOL with MATLAB including all the UB licensed MATLAB products

```bash
apptainer shell \
 --no-env=XDG_DATA_DIRS \
 --writable-tmpfs \
 --bind /util:/util,/scratch:/scratch \
 --bind "/util":"/util","/scratch":"/scratch" \
 --bind "${PROJECTS_DIR}":"${PROJECTS_DIR}" \
 --bind "/util/software/licenses/matlab.lic":"/MATLAB/licenses/licenses.lic":ro \
 --bind "${PROJECTS_DIR}/COMSOL/COMSOL-SENS-license.dat":"/COMSOL/license/license.dat":ro \
 /util/software/containers/x86_64/COMSOL64-MATLAB-R2025b-all_licenced_products-x86_64.sif
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

[COMSOL batch example script](slurm_COMSOL_example.bash)  

## Documentation Resources

For more information on COMSOL see the [COMSOL Documentation](https://www.comsol.com/documentation) and the [COMSOL Learning Center](https://www.comsol.com/support/learning-center)

