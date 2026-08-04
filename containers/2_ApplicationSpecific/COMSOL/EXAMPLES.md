# MATLAB Examples

[COMSOL](https://www.comsol.com/products) Multiphysics:registered: is a commercial general-purpose simulation software suite

> [!WARNING]
> COMSOL is a suite of commercial programs.
> You MUST have appropriate licenses for every COMSOL product you use

The following examples assume your COMSOL license file is here:  
"/projects/academic/[YourGroupName]/COMSOL/COMSOL-SENS-license.dat"

CCR provides three pre-built COMSOL containers.  Which one you
choose will depend on whether you need to use MATLAB with COMSOL,
and if so, which MATLAB products you need.

> [!WARNING]
> UB's MATLAB licenses is for **academic purposes only** and can not be used by commercial users or researchers doing commercial work.  Roswell Park researchers and other commercial users should utilize their own license with MATLAB.

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

The examples use the COMSOL container without MATLAB "COMSOL64-x86_64.sif"
but you can substitute the full path to the .sif file of your choice.
If the container you choose includes MATLAB you will have to bind mount the
MATLAB licenses file, for example the UB academic MATLAB license:

```bash
[...]
 --bind /util/software/licenses/matlab.lic:/MATLAB/licenses/licenses.lic:ro \
[...]
```

> [!WARNING]
> UB's MATLAB licenses is for **academic purposes only** and can not be used by commercial users or researchers doing commercial work.  Roswell Park researchers and other commercial users should utilize their own license with MATLAB.


## COMSOL batch Example

Start an interactive job e.g.

```bash
export SBATCH_ACCOUNT="[SlurmAccountName]"
```

```bash
salloc --cluster=ub-hpc --partition=general-compute --qos=general-compute \
 --mem=64GB --nodes=1 --tasks-per-node=1 --cpus-per-task=16 \
 --time=01:00:00
```

Change to your COMSOL directory

```bash
cd /projects/academic/[YourGroupName]/COMSOL
```

Start the COMSOL container instance

```bash
apptainer shell \
 --no-env=XDG_DATA_DIRS \
 --writable-tmpfs \
 --bind /util:/util,/scratch:/scratch \
 --bind /vscratch/grp-[YourGroupName]:/vscratch/grp-[YourGroupName] \
 --bind /projects/academic/[YourGroupName]:/projects/academic/[YourGroupName] \
 --bind /projects/academic/[YourGroupName]/COMSOL/COMSOL-SENS-license.dat:/COMSOL/license/license.dat:ro \
 /util/software/containers/x86_64/COMSOL64-x86_64.sif 
```

The following commands are run from the "Apptainer> " prompt


Download the [COMSOL HI Batch Reactor example](https://www.comsol.com/model/hi-batch-reactor-18119)
This example models the hydrogen iodine reaction in a batch reactor with
constant volume.

```bash
curl -LO "https://www.comsol.com/model/download/1528251/hi_batch_reactor.mph"
curl -LO "https://www.comsol.com/model/download/1528271/hi_batch_reactor_parameters.txt"
curl -LO "https://www.comsol.com/model/download/1528281/hi_batch_reactor_variables.txt"
```

# create the output directory

```bash
mkdir -p ./output/
```

This example will use two COMSOLE product licenses:

```bash
comsol batch -checklicense "hi_batch_reactor.mph"
```

Expected output:

> ```bash
> COMSOL
> CHEM
> ```

Since we are running in batch mode, the run will use the BATCH versions of
these two licenses, `COMSOLBATCH` `CHEMBATCH`, plus a COMSOL user license
`COMSOLUSER` that is:

```bash
lmstat -c /COMSOL/license/license.dat -a | grep -E '(COMSOLUSER|COMSOLBATCH|CHEMBATCH):'
```

Sample output:

> ```bash
> Users of CHEMBATCH:  (Total of 3 licenses issued;  Total of 0 licenses in use)
> Users of COMSOLBATCH:  (Total of 3 licenses issued;  Total of 0 licenses in use)
> Users of COMSOLUSER:  (Total of 3 licenses issued;  Total of 1 license in use)
> ```

Since at lease one of each of the licenses we need is available, we can run the
simulation in batch mode:

```bash
comsol -usebatchlic batch \
 -np $(expr ${SLURM_CPUS_PER_TASK:-${SLURM_TASKS_PER_NODE}} - 4) \
 -inputfile "hi_batch_reactor.mph" \
 -outputfile "./output/hi_batch_reactor_output.mph"
```

Sample output:

> ```
*******************************************
> ***COMSOL 6.4.0.343 progress output file***
> *******************************************
> Tue Aug 04 15:23:31 EDT 2026
> COMSOL Multiphysics 6.4 (Build: 343) starting in batch mode
> Opening file: hi_batch_reactor.mph
> Open time: 8 s.
> Running: Study 1
>            Current Progress:   2 % - Generating equations
> Memory: 716/716 10319/10319
>            Current Progress:   3 % - Generating equations
> Memory: 717/717 10319/10319
> <---- Compile Equations: Time Dependent in Study 1/Solution 1 (sol1) -----------
> Started at Aug 4, 2026, 3:23:41?PM.
> Running on Intel(R) Xeon(R) Gold 6130 CPU at 2.10 GHz.
> Using 1 socket with 12 cores in total on cpn-std-1.dev.ccr.buffalo.edu.
> Available memory: 32.09 GB.
>            Current Progress:   5 % - Compile Equations: Time Dependent
> Memory: 922/922 10511/10511
> Time: 1 s.
> Physical memory: 931 MB
> Virtual memory: 10511 MB
> Ended at Aug 4, 2026, 3:23:42?PM.
> ----- Compile Equations: Time Dependent in Study 1/Solution 1 (sol1) ---------->
> <---- Dependent Variables 1 in Study 1/Solution 1 (sol1) -----------------------
> Started at Aug 4, 2026, 3:23:42?PM.
>            Current Progress:   5 % - Dependent Variables 1
> Memory: 945/945 10511/10511
> Solution time: 0 s.
> Physical memory: 945 MB
> Virtual memory: 10511 MB
> Ended at Aug 4, 2026, 3:23:42?PM.
> ----- Dependent Variables 1 in Study 1/Solution 1 (sol1) ---------------------->
> <---- Time-Dependent Solver 1 in Study 1/Solution 1 (sol1) ---------------------
> Started at Aug 4, 2026, 3:23:42?PM.
> Time-dependent solver (BDF)
> Number of degrees of freedom solved for: 4.
> Nonsymmetric matrix found.
> Scales for dependent variables:
> Concentration (comp1.ODE1): 4.5e+04
> Concentration (comp1.ODE2): 4.5e+04
> Concentration (comp1.ODE3): 1e+05
> comp1.ODE4: 7e+02
> Step        Time    Stepsize      Res  Jac  Sol Order Tfail NLfail   LinErr   LinRes
>    -           0           - out
>    1     0.78125     0.78125 out    8    5    8     1     3      0  1.4e-16  1.4e-16
>   11      170.35      42.558 out   28   15   28     2     3      0    4e-17  5.9e-17
>   21      1011.7       75.36 out   50   26   50     3     4      0  1.8e-16  2.5e-16
>   31        1407      29.857 out   74   38   74     3     6      0  1.4e-16  1.3e-16
>   41      1663.4      28.121 out   96   49   96     3     7      0  6.6e-17  1.2e-16
>   53      1992.4      50.619 out  120   61  120     4     7      0  4.7e-16  1.8e-16
>   64      2751.7      101.24 out  142   72  142     3     7      0  3.8e-16  8.4e-17
>   75       34433        5000 out  164   83  164     1     7      0    5e-15  5.7e-17
>    -       50000           - out
>   79       54433        5000      172   87  172     1     7      0  1.8e-15  6.5e-17
> Time-stepping completed.
> ---------- Current Progress: 100 % - 
> Memory: 966/966 10527/10527
> Solution time: 0 s.
> Physical memory: 966 MB
> Virtual memory: 10527 MB
> Ended at Aug 4, 2026, 3:23:43?PM.
> ----- Time-Dependent Solver 1 in Study 1/Solution 1 (sol1) -------------------->
> Run time: 3 s.
> Saving model: /vscratch/grp-ccradmintest/tkewtest/COMSOL/./output/hi_batch_reactor_output.mph
> Save time: 1 s.
> Total time: 12 s.
> ---------- Current Progress: 100 % - Done
> Memory: 980/980 10532/10532
> ```

From tthe "Apptainer> " prompt, exit apptainer

```bash
exit
```

From the terminal prompt exit the interactive job

```bash
exit
```

## Running the COMSOL GUI

The COMSOL GUI will only run in an [OnDemand portal](https://docs.ccr.buffalo.edu/en/latest/portals/ood/) session  
For example:

Open a browser window to our [OnDemand portal](https://ondemand.ccr.buffalo.edu)

[UB-HPC & Faculty Cluster Desktop]

Cluster: UB-HPC  
Slurm Account: [Your Slurm account]  
Partition: [general-compute]  
Quality of Service: [general-compute]  
Number of Hours Requested: 4  
Number of Cores: 28  
Amount of Memory: 128000  

[Launch]

Once the Slurm job starts you can press the button that appears
[Launch UB-HPC & Faculty Cluster Desktop]

A new window will open with the GUI displayed.

Open a terminal with:
[Applications][Terminal Emulator]

cd to your COMSOL directory

```bash
cd /projects/academic/[YourGroupName]/COMSOL
```

Start the COMSOL container instance (COMSOL without MATLAB)

```bash
apptainer shell \
 --no-env=XDG_DATA_DIRS \
 --writable-tmpfs \
 --bind /util:/util,/scratch:/scratch \
 --bind /vscratch/grp-[YourGroupName]:/vscratch/grp-[YourGroupName] \
 --bind /projects/academic/[YourGroupName]:/projects/academic/[YourGroupName] \
 --bind /projects/academic/[YourGroupName]/COMSOL/COMSOL-SENS-license.dat:/COMSOL/license/license.dat:ro \
 /util/software/containers/x86_64/COMSOL64-x86_64.sif 
```
 --bind /util/software/licenses/matlab.lic:/MATLAB/licenses/licenses.lic:ro \

Note: For COMSOL with MATLAB using UB's academic MATLAB licenses you need to add
a bind mount for the MATLAB license, for example:

```bash
apptainer shell \
 --no-env=XDG_DATA_DIRS \
 --writable-tmpfs \
 --bind /util:/util,/scratch:/scratch \
 --bind /vscratch/grp-[YourGroupName]:/vscratch/grp-[YourGroupName] \
 --bind /projects/academic/[YourGroupName]:/projects/academic/[YourGroupName] \
 --bind /projects/academic/[YourGroupName]/COMSOL/COMSOL-SENS-license.dat:/COMSOL/license/license.dat:ro \
 --bind /util/software/licenses/matlab.lic:/MATLAB/licenses/licenses.lic:ro \
 /util/software/containers/x86_64/COMSOL64-MATLAB-R2025b-all_licenced_products-x86_64.sif
```

The following command is run from the "Apptainer> " prompt

```bash
comsol -3drend sw -np $(expr ${SLURM_NTASKS} - 4)
```

The COMSOL GUI will launch

