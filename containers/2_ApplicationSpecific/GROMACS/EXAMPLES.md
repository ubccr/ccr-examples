# GROMACS Examples


This example used one of the GROMACS test bemchmarks from [OpenBenchmarking.org](https://openbenchmarking.org/test/pts/gromacs)
specifically: https://ftp.gromacs.org/pub/benchmarks/water_GMX50_bare.tar.gz

Start an interactive Slurm job on a single node with a GPU, e.g.

```bash
salloc --cluster=ub-hpc --partition=debug --qos=debug --mem=0 --exclusive --gpus-per-node=1 --time=01:00:00
```

Then change to your GROMACS directory e,g,

```bash
cd /projects/academic/[YourGroupName]/GROMACS
```

Set the directory for container images e.g.

```bash
CONTAINER_DIR="/projects/academic/[CCRgroupname]/Containers"
```

Set environment variables to run the container

```bash
GROMACS_TAG="v2026.2"
container_image="GROMACS-${GROMACS_TAG}-CUDA-$(arch).sif"
export OMP_NUM_THREADS="${SLURM_CPUS_PER_TASK:-$((${SLURM_JOB_CPUS_PER_NODE} / ${SLURM_GPUS_ON_NODE}))}"
export CUDA_CACHE_PATH="${SLURMTMPDIR:-/var/tmp}/nv_$(id -nu)"
mkdir -p "${CUDA_CACHE_PATH}"
export GMX_ENABLE_DIRECT_GPU_COMM=1
export APPTAINER_TMPDIR="${APPTAINER_TMPDIR:-${SLURMTMPDIR}/apptainer/tmp}"
mkdir -p "${APPTAINER_TMPDIR}"
```

Set "PROJECTS_DIR" to the path to your projects directory
e.g.

```bash
export PROJECTS_DIR="/projects/academic/[YourGroupName]"
```

Start the container:

```bash
apptainer shell \
 --bind "/util":"/util","/scratch":"/scratch" \
 --bind "${PROJECTS_DIR}":"${PROJECTS_DIR}" \
 --nv \
 "${CONTAINER_DIR}/${container_image}"
```

Expected output:

> ```bash
> Apptainer> 
> ```

All the commands from here, withing this terminal window, are run from the
"Apptainer> " prompt

Source the startup script to add "gmx" to the PATH

```bash
source /singularity 
```

Sample output:

> ```bash
> CCRusername@cpn-c04-33:/projects/academic/[YourGroupName]/GROMACS$ 
> ```

Fetch the tarball for this exmaple:

```bash
curl -LO https://ftp.gromacs.org/pub/benchmarks/water_GMX50_bare.tar.gz
```

Sample output:

> ```
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100  132M  100  132M    0     0  53.4M      0  0:00:02  0:00:02 --:--:-- 53.4M
> ```

extract the tarball

```bash
tar xzvf water_GMX50_bare.tar.gz
```

Sample abriged output:

> ```
> water-cut1.0_GMX50_bare/
> water-cut1.0_GMX50_bare/0000.96/
> water-cut1.0_GMX50_bare/0000.96/pme.mdp
> [...]
> water-cut1.0_GMX50_bare/0048/topol.top
> water-cut1.0_GMX50_bare/0048/conf.gro
> water-cut1.0_GMX50_bare/0048/rf.mdp
> ```

Chanage to the "water-cut1.0_GMX50_bare/" directory

```bash
cd ./water-cut1.0_GMX50_bare/0000.96/
```

Generate an atomic-level input file (.tpr)

```bash
gmx grompp -f pme.mdp -o bench.tpr
```

sample abridged output:

> ```
>                     :-) GROMACS - gmx grompp, 2026.2-dev (-:
> [...]
> Taking velocities from 'conf.gro'
> Analysing residue names:
> There are:   320      Water residues
> Number of degrees of freedom in T-Coupling group System is 1917.00
> 
> The largest distance between excluded atoms is 0.164 nm between atom 821 and 822
> 
> Determining Verlet buffer for a tolerance of 0.005 kJ/mol/ps at 300 K
> 
> Calculated rlist for 1x1 atom pair-list as 1.036 nm, buffer size 0.036 nm
> 
> Set rlist, assuming 4x4 atom pair-list, to 1.000 nm, buffer size 0.000 nm
> 
> Note that mdrun will redetermine rlist based on the actual pair-list setup
> Calculating fourier grid dimensions for X Y Z
> Using a fourier grid of 20x20x20, spacing 0.106 0.106 0.106
> 
> Estimate for the relative computational load of the PME mesh part: 0.26
> [...]
> ```

This generates two files:

```bash
ls -l bench.tpr mdout.mdp 
```

Ssample output:

> ```
> -rw-rw-r-- 1 [CCRusername] nogroup 27096 Oct 28 10:01 bench.tpr
> -rw-rw-r-- 1 [CCRusername] nogroup 11029 Oct 28 10:01 mdout.mdp
> ```


Run the simulation:

```bash
gmx mdrun -ntmpi ${SLURM_GPUS_ON_NODE} -resethway -npme 0 -notunepme -noconfout -nsteps 1000 -v -s bench.tpr
```

sample truncated output:

> ```
>                     :-) GROMACS - gmx mdrun, 2026.2-dev (-:
> [...]
> Reading file bench.tpr, VERSION 2026.2-dev (single precision)
> Overriding nsteps with value passed on the command line: 1000 steps, 2 ps
> Changing nstlist from 10 to 25, rlist from 1 to 1.051
> 
> On host cpn-d03-37.core.ccr.buffalo.edu 2 GPUs selected for this run.
> Mapping of GPU IDs to the 2 GPU tasks in the 2 ranks on this node:
>   PP:0,PP:1
> PP tasks will do non-perturbed short-ranged interactions on the GPU
> PP task will update and constrain coordinates on the CPU
> GPU direct communication will be used between MPI ranks.
> Using 2 MPI threads
> Using 32 OpenMP threads per tMPI thread
> 
> starting mdrun 'Water'
> 1000 steps,      2.0 ps.
> step 400, remaining wall clock time:     0 s          imb F  0% 
> step 500: resetting all time and cycle counters
> step 1000, remaining wall clock time:     0 s          mb F  0% 
> 
> Dynamic load balancing report:
>  DLB was off during the run due to low measured imbalance.
>  Average load imbalance: 0.3%.
>  The balanceable part of the MD step is 50%, load imbalance is computed from this.
>  Part of the total run time spent waiting due to load imbalance: 0.1%.
> 
> 
>                Core t (s)   Wall t (s)        (%)
>        Time:        6.306        0.100     6331.6
>                  (ns/day)    (hour/ns)    (ms/step)  (Matom*steps/s) 
> Performance:      869.294        0.028        0.199            4.829
> [...]
> ```

Exit the container

```bash
exit
```

sample output:

> ```bash
> CCRusername@cpn-c04-33:/projects/academic/[YourGroupName]/GROMACS$ 
> ``

...then exit the slurm interactive session

```bash
exit
```


GROMACS can be used to generate .xvg files, for example with energy analysis
such as:

```bash
gmx energy -f em.edr -o potential.xvg
```

The data in such .xvg files can be can be plotted, in CCR's [OnDemand portal](https://ondemand.ccr.buffalo.edu)
with "xmgrace"

e.g. in an OnDemand terminal window

Set the directory for container images e.g.

```bash
CONTAINER_DIR="/projects/academic/[CCRgroupname]/Containers"
```

then

```bash
apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 "${CONTAINER_DIR}/grace-$(arch).sif" \
 xmgrace "potential.xvg"
```
Please exit the OnDemand session once you are done:
[Applications] [Log Out] [Log Out]
Then close the browser window

