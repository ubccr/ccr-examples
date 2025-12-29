# Application Specific Slurm Script Examples

## Using these examples

This directory contains batch scripts for a variety of applications that have special setup requirements.  You will not find an example script for every piece of software installed on CCR's systems.  These examples should be used as guidance and are not set in stone.  Please start with these examples, test for your own use case, and scale as required.

## Table of Topics

| Topic                                | Description |
|--------------------------------------|------------------------|
| [AlphaFold](./alphafold)                | AlphFold example including a dataset for testing and validation |
| [LSDYNA](./lsdyna)                      | LSDYNA examples for both single and multi node message passing parallel jobs as well as single node shared memory parallel jobs (See [README](./lsdyna/README.md) for details) |
| [MATLAB](./matlab)                      | The MATLAB directory includes example bash scripts and MATLAB functions for running [serial](./matlab/serial), [multithreaded](./matlab/multithreaded), and [GPU](./matlab/GPU) MATLAB jobs |
| [Python](./python)                      | The Python directory includes examples bash scripts and Python functions for [serial](./python/serial) Python job, with multithreaded and GPU examples coming soon |
| [R](./R)                                | R example using RNA-seq data for testing and differential gene expression analysis |

## Additional Information

- The [Slurm README](../README.md) provides details on general Slurm usage.
- The [Placeholders](../../README.md#placeholders) section lists the available options for each placeholder used in commands and example scripts.
- The [slurm-options.bash](../slurm-options.bash) file outlines commonly used `#SBATCH` directives with their descriptions.
