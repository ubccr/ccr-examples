# Example VASP container

VASP is a licensed product and not installed by CCR staff. Provided is an
example VASP [apptainer def](https://apptainer.org/docs/user/main/definition_files.html) file for
building a VASP container with GPU support. This has been tested with VASP
v6.3.0 and may need adjustments for other versions.

## Building container

1. Ensure you copy the vasp source code to this directory:

```
cp vasp.6.3.0.tgz .
```

2. Optionally, download a copy of whichever makefile.include you want to use.
   For GPU support, we suggest using the one included in this repo which is
   this one: [makefile.include.nvhpc_acc](https://www.vasp.at/wiki/index.php/Makefile.include.nvhpc_acc)

> [!IMPORTANT]
> The VASP definition file contains commands that cannot be executed during an Apptainer build by an unprivileged user. Build the container on a system where you have administrator (root) privileges, then copy the resulting `vasp.sif` container image to CCR before running it.

3. On the system where you have administrator (root) privileges, build the container:

```
export APPTAINER_CACHEDIR=/projects/academic/[YourGroupName]/[CCRusername]/cache
apptainer build vasp.sif vasp.def
```

Refer to CCR's [container documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/) for more details.

## Running container

1. Download the [O atom](https://www.vasp.at/wiki/index.php/O_atom) VASP example
   for performing a standard calculation for a single oxygen atom in a box:

```
wget https://www.vasp.at/wiki/images/7/7a/Oatom.tgz
tar xvzf Oatom.tgz
cd Oatom
```

2. Request a GPU node via interactive job or use within a Slurm script. As an
   example, this is how we'd request an interactive job:

```
salloc --partition=debug --qos=debug --mem=16GB --gpus-per-node=1
```

Refer to CCR's [documentation](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/) for more on running jobs.

3. Run container:

```
apptainer exec --nv --bind $SLURMTMPDIR:$SLURMTMPDIR /path/to/vasp.sif mpirun -np 1 vasp_std
```
Expected output:
```
 running on    1 total cores
 distrk:  each k-point on    1 cores,    1 groups
 distr:  one band on    1 cores,    1 groups
 OpenACC runtime initialized ...    2 GPUs detected
```

> [!NOTE]
> To run on more than 1 GPU, you must request that in your job allocation. Use a single MPI rank per GPU as recommended by the [VASP documentation](https://www.vasp.at/wiki/index.php/OpenACC_GPU_port_of_VASP#Running_the_OpenACC_version)

## See also:

https://github.com/faridf/VASP-6.3.0-Docker-Build-with-GPU-Support/
