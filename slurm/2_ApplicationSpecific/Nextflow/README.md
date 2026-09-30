# Nextflow

This example demonstrates how to configure Nextflow to submit workflow processes to Slurm on CCR systems.

The example is intentionally simple and is meant to demonstrate CCR-specific configuration rather than teach Nextflow pipeline development. For information on creating and developing Nextflow workflows, refer to the official Nextflow documentation.

## Files

- `main.nf` - A simple example Nextflow workflow.
- `nextflow.config` - CCR-specific Slurm configuration for running Nextflow processes.

## CCR Software

Nextflow is available through CCR's software module system.

```bash
module load nextflow/25.10.2
```

## Running the Example

The included configuration uses the Slurm executor so that Nextflow processes are submitted as Slurm jobs on CCR compute nodes.

Before running the example, replace the placeholder Slurm account, partition, and QOS values in `nextflow.config` with values appropriate for your CCR account.

Additional examples for using CCR software modules and containers with Nextflow will be added as this example is developed.
