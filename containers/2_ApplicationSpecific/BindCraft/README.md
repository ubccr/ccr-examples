# Example BindCraft container

## Building the container

A brief guide to building the BindCraft container follows:<br/>
Please refer to CCR's [container documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/) for more detailed information on building and using Apptainer.

NOTE: for building on the ARM64 platform see [BUILD-ARM64.md](./BUILD-ARM64.md)

1. Start an interactive job

Apptainer is not available on the CCR login nodes and the compile nodes may not provide enough resources for you to build a container.  We recommend requesting an interactive job on a compute node to conduct this build process.<br/>
Note: a GPU is NOT needed to build the BindCraft container<br/>
See CCR docs for more info on [running jobs](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission)

```
salloc --cluster=ub-hpc --partition=debug --qos=debug --account="[SlurmAccountName]" \
 --mem=0 --exclusive --time=01:00:00
```

Sample output:

> ```
> salloc: Pending job allocation 19781052
> salloc: job 19781052 queued and waiting for resources
> salloc: job 19781052 has been allocated resources
> salloc: Granted job allocation 19781052
> salloc: Nodes cpn-i14-39 are ready for job
> CCRusername@cpn-i14-39:~$ 
> ```

2. Navigate to your build directory and use the Slurm job local temporary directory for cache

You should now be on the compute node allocated to you.  In this example we're using our project directory for our build directory.

Change to your BindCraft directory

```
cd /projects/academic/[YourGroupName]/BindCraft
```

There are two sample .def files, [FreeBindCraft.def](./FreeBindCraft.def) and [FreeBindCraft_with_PyRosetta.def](./FreeBindCraft_with_PyRosetta.def)
The former does not install PyRosetta, the latter does.
To build and use the PyRosetta version you must have a PyRosetta license.
You must either complete the application for a non commercial license or purchase
a commercial license - see [PyRosetta Licensing](https://els2.comotion.uw.edu/product/pyrosetta) for more info.

The following example uses the non PyRosetta version.
To build with PyRosetta see [Build with PyRosetta](./BUILD_with_PyRosetta.md)

Download the BindCraft build files, FreeBindCraft.def and docker-entrypoint.sh to this directory

```
curl -L -o BindCraft.def https://raw.githubusercontent.com/tonykew/ccr-examples/refs/heads/BindCraft/containers/2_ApplicationSpecific/BindCraft/FreeBindCraft.def
curl -L -o docker-entrypoint.sh https://raw.githubusercontent.com/tonykew/ccr-examples/refs/heads/BindCraft/containers/2_ApplicationSpecific/BindCraft/docker-entrypoint.sh
```

Sample output:

> ```
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100  5413  100  5413    0     0  50616      0 --:--:-- --:--:-- --:--:-- 51066
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100   404  100   404    0     0   7185      0 --:--:-- --:--:-- --:--:--  7214
> ```

3. Build your container

Set the apptainer cache dir:

```
export APPTAINER_CACHEDIR=${SLURMTMPDIR}
```

Building the BindCraft container takes about half an hour...

```
apptainer build BindCraft-$(arch).sif FreeBindCraft.def
```

Sample truncated output:

> ```
> [....]
> INFO:    Adding environment to container
> INFO:    Creating SIF file...
> INFO:    Build complete: BindCraft-x86_64.sif
> ```

Exit the Slurm job

```
exit
```

Sample output:

> ```
> logout
> salloc: Relinquishing job allocation 19781052
> salloc: Job allocation 19781052 has been revoked.
> [CCRusername]@login1$ 
> ``

## Running the container

Start an interactive job with a single GPU e.g.
NOTE: BindCraft only uses one GPU

```
salloc --cluster=ub-hpc --partition=general-compute --qos=general-compute \
 --account="[SlurmAccountName]" --mem=128GB --nodes=1 --cpus-per-task=1 \
 --tasks-per-node=12 --gpus-per-node=1 --time=05:00:00
```

Change to your BindCraft directory

```
cd /projects/academic/[YourGroupName]/BindCraft
```

Create the input and output directories

```
mkdir -p ./input ./output
```

...then start the BindCraft container instance

```
apptainer shell \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 -B /util/software/data/alphafold/params:/app/params \
 -B ./input:/work/input,./output:/work/output \
 --nv \
 ./BindCraft-$(arch).sif
```

Sample output:

> ```
> 
> GPU info:
> GPU 0: Tesla T4 (UUID: GPU-fdc92258-5f5b-9ece-ceca-f1545184cd08)
> 
> Apptainer> 
> ```

Verify BindCraft is installed:

The following command is run from the "Apptainer> " prompt

```
source /singularity
```

Expected output:

> ```
> BindCraft> 
> ```

All the following commands are run from the "BindCraft> " prompt

```
python3 "/app/bindcraft.py" --help
```

Sample output:

> ```
> Open files limits OK (soft=65536, hard=65536)
> usage: bindcraft.py [-h] [--settings SETTINGS] [--filters FILTERS] [--advanced ADVANCED] [--no-pyrosetta] [--verbose] [--no-plots] [--no-animations]
>                     [--interactive]
> 
> Script to run BindCraft binder design.
> 
> options:
>   -h, --help            show this help message and exit
>   --settings SETTINGS, -s SETTINGS
>                         Path to the basic settings.json file. If omitted in a TTY, interactive mode is used.
>   --filters FILTERS, -f FILTERS
>                         Path to the filters.json file used to filter design. If not provided, default will be used.
>   --advanced ADVANCED, -a ADVANCED
>                         Path to the advanced.json file with additional design settings. If not provided, default will be used.
>   --no-pyrosetta        Run without PyRosetta (skips relaxation and PyRosetta-based scoring)
>   --verbose             Enable detailed timing/progress logs
>   --no-plots            Disable saving design trajectory plots (overrides advanced settings)
>   --no-animations       Disable saving design animations (overrides advanced settings)
>   --interactive         Force interactive mode to collect target settings and options
> ```

See the [EXAMPLE file](./EXAMPLES.md) for more info.

## Sample Slurm scripts

### x86_64 examples
[BindCraft Slurm example script](https://raw.githubusercontent.com/tonykew/ccr-examples/refs/heads/BindCraft/containers/2_ApplicationSpecific/BindCraft/slurm_BindCraft_example.bash) 
[BindCraft with PyRosetta Slurm example script](https://raw.githubusercontent.com/tonykew/ccr-examples/refs/heads/BindCraft/containers/2_ApplicationSpecific/BindCraft/slurm_BindCraft_with_PyRosetta_example.bash)

## Documentation Resources

For more information on BindCraft see the [Free BindCraft GitHub page](https://github.com/cytokineking/FreeBindCraft), [the BindCraft wiki](https://github.com/martinpacesa/BindCraft/wiki/De-novo-binder-design-with-BindCraft) and the [BindCraft GitHub page](https://github.com/martinpacesa/BindCraft)

