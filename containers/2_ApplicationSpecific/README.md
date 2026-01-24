# Application Specific Container Examples

## How to use

This directory contains examples for building and running specific containers with Apptainer, including applications that require specialized container setups. You will not find an example for every software application. These container examples should be used as guidance and can be modified for your own use case.

Please refer to CCR's [container documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/) for information on building and using Apptainer.

## Table of Topics

| Topic                                | Description |
|--------------------------------------|------------------------|
| [Abaqus](./abaqus)                   | Guide to running Abaqus with Apptainer via Slurm batch script, command line, GUI access, and GPU support |
| [AlphaFold 3](./AlphaFold-3)         | AlphaFold 3 container with steps for building and running a Data Pipeline and Inference via Apptainer and Slurm |
| [BindCraft](./BindCraft)             | Free BindCraft container with steps for building and running with or without PyRosetta via Apptainer and Slurm |
| [CONDA](./conda)                     | Example CONDA container with steps for building and running via Apptainer |
| [Juicer](./juicer)                   | Example of running the containerized version of Juicer at CCR using Apptainer |
| [Micro-C](./Micro-C)                 | Micro-C Pipeline container with steps for building and running via Apptainer |
| [OpenFF-Toolkit](./Open_Force_Field_toolkit)  | Open Force Field toolkit container with steps for building and running via Apptainer |
| [OpenFOAM](./OpenFOAM)               | OpenFOAM container with steps for building and running via Apptainer and Slurm |
| [OpenSees](./OpenSees)               | OpenSees container with steps for building and running via Apptainer |
| [SAS](./sas)                         | Guide for running SAS using Apptainer via Slurm batch script, command line, and GUI access |
| [Seurat](./seurat)                   | Seurat container with example scRNA analysis |
| [VASP](./vasp)                       | Example VASP container with steps for building and running via Apptainer |

## Additional Information

- The [Slurm README](../../slurm/README.md) provides details on general Slurm usage.
- The [Placeholders](../../slurm/README.md#placeholders) section lists the available options for each placeholder used in the example scripts.
- The [slurm-options.sh](../../slurm/slurm-options.sh) file outlines commonly used `#SBATCH` directives with their descriptions.
