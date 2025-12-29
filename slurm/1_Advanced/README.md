# Advanced Slurm Examples

## How to use

This directory contains examples for more complex use cases, such as job arrays, parallel computing, and using the scavenger partition. These examples are intended as a starting point and will need to be adjusted for your specific use case. Please start with these examples, test for your own use case, and scale as required.

## Table of Topics

| Topic                          | Description |
|--------------------------------|-------------|
| [Scavenger](./Scavenger)       | Example of submitting a job to the scavenger partition, with additional context and usage details in the [README](./Scavenger/README.md) |
| [GPUs](./GPUs)                 | Example job script demonstrating how to request and use GPUs on CCR's clusters |
| [JobArrays](./JobArrays)       | Example of running a Slurm job array with additional information in the [README](./JobArrays/README.md) |

## Additional Information

- The [Slurm README](../README.md) provides details on general Slurm usage.
- The [Placeholders](../../README.md#placeholders) section lists the available options for each placeholder used in commands and example scripts.
- The [slurm-options.bash](../slurm-options.bash) file outlines commonly used `#SBATCH` directives with their descriptions.
