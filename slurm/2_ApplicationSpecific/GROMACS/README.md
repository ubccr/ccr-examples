# GROMACS Slurm Examples

GROMACS is an open-source software suite for high-performance molecular dynamics and output analysis.

Provided in this repository is a [Slurm script](./slurm_GROMACS_benchmark_example.bash) with multiple GROMACS command examples for different configurations. GROMACS can make use of CPUs and (for certain tasks) GPUs. The GPU version of GROMACS supports both CPU only and CPU/GPU use cases, so the provided example uses the GPU version of GROMACS.

## How to use

The provided example does not include any input data by default. This is intentional, so users can customize the workflow and run simulations with their own dataset while becoming familiar with GROMACS. 

For a test run, you can download the benchmark data (`water_GMX50`) from the [GROMACS benchmark website](http://ftp.gromacs.org/pub/benchmarks) and use it as a sample. The dataset only needs to be fetched once.  Once downloaded it can be used for multiple test runs.

You can generate a `bench.tpr` file for each `pme.mdp` file included in the dataset using the following command in a loop:
```
gmx_mpi grompp -f pme.mdp  -o bench.tpr
```
Then you can run the corresponding GROMACS command inside the loop. The [Slurm script](./slurm_GROMACS_benchmark_example.bash) included in this directory contains multiple GROMACS commands (commented out) for different CPU, GPU configurations. When testing a specific configuration, make sure to uncomment the command you want to use and comment out the others.

> [!NOTE]
> The `water-cut1.0_GMX50_bare/0000.65` test fails. We believe the test needs to be larger to run on the allocated resources.

## Additional Information

- Refer to the [official GROMACS documentation](https://manual.gromacs.org/) and [open benchmarking](https://openbenchmarking.org/test/pts/gromacs) for detailed information about GROMACS.
- The [Slurm README](../../README.md) provides details on general Slurm usage.
- The [Placeholders](../../../README.md#placeholders) section lists the available options for each placeholder used in the example scripts.
- The [slurm-options.bash](../../slurm-options.bash) file outlines commonly used `#SBATCH` directives with their descriptions.
