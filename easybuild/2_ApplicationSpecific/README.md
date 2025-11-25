# Application Specific EasyBuild Examples

This directory contains examples for building and installing software with EasyBuild. These examples should be used as guidance and can be modified for your own use case.

Please refer to the official EasyBuild [documentation](https://docs.easybuild.io/) and [tutorials](https://tutorial.easybuild.io/) for information in detail.

## Table of Topics

| Topic                                | Description |
|--------------------------------------|------------------------|
| [Gaussian](./gaussian)               | Example of installing and using Gaussian with EasyBuild on CCR's clusters |
| [Orca](./orca)                       | Example of installing and using Orca with EasyBuild on CCR's clusters |
| [PETSc](./petsc-custom-compile)      | Example of building PETSc with EasyBuild using a Slurm job |

## Additional Information

- The [Slurm README](../../slurm/README.md) provides details on general Slurm usage.
- The [Placeholders](../../slurm/README.md#placeholders) section lists the available options for each placeholder used in the example scripts.
- The [slurm-options.sh](../../slurm/slurm-options.sh) file outlines commonly used `#SBATCH` directives with their descriptions.
