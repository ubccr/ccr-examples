# MATLAB Examples

CCR provides two pre-built MATLAB containers:

MATLAB with (only) the "Parallel Computing Toolbox"

```bash
/util/software/containers/x86_64/MATLAB-R2025b-x86_64.sif
```

MATLAB with all the MATLAB programs UB has licenses for:

```bash
/util/software/containers/x86_64/MATLAB-R2025b-all_licenced_products-x86_64.sif
```

You can use either of these, or a MATLAB container of your own making, (following
our [README file](./README.md) that includes the MATLAB "Parallel Computing Toolbox",) for
the following examples.
The examples use the "MATLAB-R2025b-all_licenced_products-x86_64.sif" container,
but you can substitute the full path to the .sif file of your choice.
For example:

```bash
/projects/academic/[YourGroupName]/MATLAB/MATLAB-R2025b-$(arch).sif
```

> [!WARNING]
> UB's MATLAB licenses is for **academic purposes only** and can not be used by commercial users or researchers doing commercial work.  Roswell Park researchers and other commercial users should utilize their own license with MATLAB.


## Parallel Example

Start an interactive job e.g.

```bash
export SBATCH_ACCOUNT="[SlurmAccountName]"
```

```bash
salloc --cluster=ub-hpc --partition=general-compute --qos=general-compute \
 --mem=64GB --nodes=1 --tasks-per-node=1 --cpus-per-task=16 \
 --time=01:00:00
```

Change to your MATLAB directory

```bash
cd /projects/academic/[YourGroupName]/MATLAB
```

Start the MATLAB container instance

```bash
apptainer shell \
 --no-env=XDG_DATA_DIRS \
 --writable-tmpfs \
 --bind /util:/util,/scratch:/scratch \
 --bind /vscratch/grp-[YourGroupName]:/vscratch/grp-[YourGroupName] \
 --bind /projects/academic/[YourGroupName]:/projects/academic/[YourGroupName] \
 --bind /util/software/licenses/matlab.lic:/MATLAB/licenses/licenses.lic:ro \
 /util/software/containers/x86_64/MATLAB-R2025b-all_licenced_products-x86_64.sif
```

The following commands are run from the "Apptainer> " prompt

```bash
matlab -nojvm -nodisplay -nosplash
```

Note: this can take over a minute to start

Sample output:

> ```
> 
>                                                         < M A T L A B (R) >
>                                               Copyright 1984-2025 The MathWorks, Inc.
>                                          R2025b Update 5 (25.2.0.3177638) 64-bit (glnxa64)
>                                                          February 24, 2026
> 
>  
> To get started, type doc.
> For product information, visit www.mathworks.com.
>  
> >> 
> ```


The following commands are run from the MATLAB ">> " prompt:

Report the number of Slurm cores in the interactive job

NOTE: In an [OnDemand portal](https://docs.ccr.buffalo.edu/en/latest/portals/ood/) session, the requested "Number of Cores" are  
allocated as Slurm tasks, rather than cores (cpus) per task.  
Hence, in an OnDemand session, subsititue the Slurm variable  
`SLURM_TASKS_PER_NODE` for `SLURM_CPUS_PER_TASK` in the following commands.

```
fprintf('Number of CPU cores in the Slurm job: %s\n', getenv('SLURM_CPUS_PER_TASK'));

```

Expected output

> ```
> Number of CPU cores in the Slurm job: 16
> >> 
> ```

Create a parallel work pool, saving 4 cores for apptainer threads

```
poolobj = parpool(str2double(getenv('SLURM_CPUS_PER_TASK')) - 4);

```

Expected output:

> ```
> Starting parallel pool (parpool) using the 'Processes' profile ...
> Connected to parallel pool with 12 workers.
> >> 
> ```

Run a trivial parallel computation

```
tic
n = 200;
A = 500;
a = zeros(n);
parfor i = 1:n
    a(i) = max(abs(eig(rand(A))));
end
toc

```

Sample output:

> ```
> >> tic
> >> n = 200;
> >> A = 500;
> >> a = zeros(n);
> >> parfor i = 1:n
>     a(i) = max(abs(eig(rand(A))));
> end
> >> toc
> Elapsed time is 2.986196 seconds.
> >> 
> ```

Exit MATLAB

```
exit
```

Expected output:

> ```
>> quit
> Parallel pool using the 'Processes' profile is shutting down.
> Apptainer> 
> ```

From tthe "Apptainer> " prompt, exit apptainer

```bash
exit
```

From the terminal prompt exit the interactive job

```bash
exit
```

## GPU Example

Start an interactive job with a GPU e.g.

```bash
export SBATCH_ACCOUNT="[SlurmAccountName]"
```

```bash
salloc --cluster=ub-hpc --partition=general-compute --qos=general-compute \
 --mem=32GB --nodes=1 --tasks-per-node=1 --cpus-per-task=8 \
 --gpus-per-node=1 --time=01:00:00
```

Change to your MATLAB directory

```bash
cd /projects/academic/[YourGroupName]/MATLAB
```

Start the MATLAB container instance, with nvidia GPU support

```bash
apptainer shell \
 --nv \
 --no-env=XDG_DATA_DIRS \
 --writable-tmpfs \
 --bind /util:/util,/scratch:/scratch \
 --bind /vscratch/grp-[YourGroupName]:/vscratch/grp-[YourGroupName] \
 --bind /projects/academic/[YourGroupName]:/projects/academic/[YourGroupName] \
 --bind /util/software/licenses/matlab.lic:/MATLAB/licenses/licenses.lic:ro \
 /util/software/containers/x86_64/MATLAB-R2025b-all_licenced_products-x86_64.sif
```

The following commands are run from the "Apptainer> " prompt


Start MATLAB in text mode, with a single computation thread (the work on the
GPU is still in parallel)

```bash
matlab -nojvm -nodisplay -nosplash -singleCompThread
```

Note: this can take over a minute to start

Sample output:

> ```
> 
>                                                         < M A T L A B (R) >
>                                               Copyright 1984-2025 The MathWorks, Inc.
>                                          R2025b Update 5 (25.2.0.3177638) 64-bit (glnxa64)
>                                                          February 24, 2026
> 
>  
> To get started, type doc.
> For product information, visit www.mathworks.com.
>  
> >> 
> ```

The following commands are run from the MATLAB ">> " prompt:

Make sure MATLAB sees the GPU

```
gpu = gpuDevice();
fprintf('Using a %s GPU.\n', gpu.Name);

```

Sample output

> ```
> Using a NVIDIA A40 GPU.
> >> 
> ```

Display GPU information

```
disp(gpuDevice);

```

Sample abridged output:

> ```
>   CUDADevice with properties:
> 
>    Identity
>                       Name: 'NVIDIA A16'
>                       UUID: 'GPU-8ac21d11-a9b4-11a3-ead7-1424d081643d'
>                      Index: 1 (of 1)
> [...]
>                MaxGridSize: [2.1475e+09 65535 65535]
>                  SIMDWidth: 32
>             ToolkitVersion: 12.2000
> 
> >> 
> ```

Run a computation on the GPU

```
X = gpuArray([1 0 2; -1 5 0; 0 3 -9]);
whos X;
[U,S,V] = svd(X)
fprintf('trace(S): %f\n', trace(S))

```

Sample Output:

> ```
> >> X = gpuArray([1 0 2; -1 5 0; 0 3 -9]);
> >> whos X;
>   Name      Size            Bytes  Class       Attributes
> 
>   X         3x3                72  gpuArray              
> 
> >> [U,S,V] = svd(X)
> 
> U =
> 
>    -0.1905    0.1291   -0.9732
>     0.2061    0.9745    0.0890
>     0.9598   -0.1836   -0.2122
> 
> 
> S =
> 
>     9.8383         0         0
>          0    4.8002         0
>          0         0    1.0799
> 
> 
> V =
> 
>    -0.0403   -0.1761   -0.9835
>     0.3974    0.9003   -0.1775
>    -0.9168    0.3980   -0.0337
> 
> >> fprintf('trace(S): %f\n', trace(S))
> trace(S): 15.718392
> >> 
> ```

Exit MATLAB

```
exit
```

Expected output:

> ```
> Apptainer> 
> ```

From tthe "Apptainer> " prompt, exit apptainer

```bash
exit
```

From the terminal prompt exit the interactive job

```bash
exit
```

## Running the MATLAB GUI

The MATLAB GUI will only run in an [OnDemand portal](https://docs.ccr.buffalo.edu/en/latest/portals/ood/) session  
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
Number of GPUs: 1  

[Launch]

Once the Slurm job starts you can press the button that appears
[Launch UB-HPC & Faculty Cluster Desktop]

A new window will open with the GUI displayed.

Open a terminal with:
[Applications][Terminal Emulator]

cd to your MATLAB directory

```bash
cd /projects/academic/[YourGroupName]/MATLAB
```

Start the MATLAB container instance

```bash
apptainer shell \
 --nv \
 --no-env=XDG_DATA_DIRS \
 --writable-tmpfs \
 --bind /util:/util,/scratch:/scratch \
 --bind /vscratch/grp-[YourGroupName]:/vscratch/grp-[YourGroupName] \
 --bind /projects/academic/[YourGroupName]:/projects/academic/[YourGroupName] \
 --bind /util/software/licenses/matlab.lic:/MATLAB/licenses/licenses.lic:ro \
 /util/software/containers/x86_64/MATLAB-R2025b-all_licenced_products-x86_64.sif
```

The following command is run from the "Apptainer> " prompt

```bash
matlab 
```

The MATLAB GUI will launch

The above Parallel and GPU examples can be run in the GUI's "Command Window",  
but note that you must substitute `SLURM_TASKS_PER_NODE` for `SLURM_CPUS_PER_TASK`  
in the parallel example because the "Number of Cores" are allocated as Slurm  
tasks, rather than cores (cpus) per task.

