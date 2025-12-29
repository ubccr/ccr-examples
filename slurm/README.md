# Example Slurm scripts

This directory contains example Slurm batch job scripts for use on CCR's clusters. These examples are meant to supplement our official documentation on [running and monitoring jobs](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/). Before using these scripts, it's important to understand the basics of batch computing as well as CCR-specific usage guidelines and limitations. Please refer to the full documentation for detailed instructions and best practices.

At CCR you should use the bash shell for your Slurm batch scripts. The first line in each example (`#!/bin/bash -l`) is required. Slurm batch script files in this repository have a `.bash` extension, as a best practice. In bash scripts, lines beginning with `#` are treated as comments and ignored during execution. However, Slurm specifically looks for lines that start with `#SBATCH`, and these are interpreted as job directives.  

**Important**: Do not remove the `#` in front of `SBATCH`; doing so will prevent Slurm from recognizing your job options. If you want to disable a specific directive without removing it, simply comment it out by adding an extra `#` (i.e.,`##SBATCH`).

The [slurm-options.bash](slurm-options.bash) file in this directory provides a list of the most commonly used Slurm directives and a short explanation for each one. You can also refer to our [documentation](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#slurm-directives-partitions-qos) for specific cluster and partition limits. It is not necessary to use all of these directives in every job script. In the sample scripts throughout this repository, we list the required Slurm directives and a few others just as examples.

Be aware that the more specific you get when requesting resources on CCR's clusters, the fewer options the job scheduler has to place your job. When possible, it's best to only specify what you need to and let the job scheduler do it's job. If you're unsure what resources your program will require, we recommend starting small and [monitoring the progress](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#monitoring-jobs) of the job, then you can scale up. For more details, refer to the [official Slurm documentation](https://slurm.schedmd.com/documentation.html).

## Placeholders

This repository uses placeholders denoted by square brackets for values that need to be customized. Replace the following placeholders with details specific to your use case before using any commands or examples.

| Placeholder             | Options |
|-------------------------|-------------------------------------------|
| `[cluster]`             | ub-hpc, faculty |
| `[partition]`           | general-compute, debug, industry, scavenger, ub-laser, [other available options](https://docs.ccr.buffalo.edu/en/latest/hpc/clusters/#ub-hpc-compute-cluster) |
| `[qos]`                 | Typically the same as `[partition]` - refer to [CCR docs](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#slurm-directives-partitions-qos) for more information. |
| `[SlurmAccountName]`    | Use the `slimits` command to see what accounts you have access to. If not specified, your default account will be used. |
| `[CCRUsername]`         | Your CCR username |
| `[YourGroupName]`       | Your project's group name (often PI username or company name) |
| `[JobID]`               | Slurm JobID |
| `[NodeID]`              | Compute NodeID |

## Getting Started ([0_Introductory/](./0_Introductory/README.md))

This directory is designed to introduce new users to the fundamentals of submitting jobs on CCR's HPC clusters using Slurm. It provides simple, well-documented examples to help users understand key Slurm concepts and serves as a foundation before progressing to more advanced workflows. The example Slurm script [BasicExample.bash](./0_Introductory/BasicExample.bash) provides a minimalist template for submitting a job in an HPC environment. It demonstrates essential Slurm directives, such as cluster, partition, memory requirements, and more.

## Advanced Slurm Examples ([1_Advanced/](./1_Advanced/README.md))

This directory includes Slurm scripts for more complex use cases such as job arrays, parallel computing, and using the scavenger partition.

## Application Specific Scripts ([2_ApplicationSpecific/](./2_ApplicationSpecific/README.md))

This directory contains Slurm job scripts tailored for specific applications that have specific setup requirements like Alphafold, MATLAB, Python, etc. Note that not every piece of software installed on CCR's systems has an example script in this directory. A [table](./2_ApplicationSpecific/README.md#table-of-topics) of available scripts for  applications is provided for easier navigation and reference.
