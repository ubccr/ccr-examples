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

Run the workflow with:

```bash
nextflow run main.nf
```

## Using CCR Software Modules

CCR software modules can be loaded directly within a Nextflow process using the `module` directive.

For example:

```nextflow
process PYTHON_VERSION {
    module 'gcccore/11.3.0'
    module 'python/3.10.4-bare'

    script:
    """
    python --version
    """
}
```

Some software modules require prerequisite modules to be loaded first. Use `module spider [software/version]` to check module dependencies before adding them to a Nextflow process.

## Running Containerized Processes

Nextflow can also run processes inside containers on CCR compute nodes.

Containerized Nextflow processes can run on CCR compute nodes using Apptainer. A Nextflow process can specify a local container image using the `container` directive.

For example:

```nextflow
process CONTAINER_TEST {
    container '/path/to/container.sif'

    script:
    """
    echo "Hello from inside the container"
    """
}
```

Container images should be prepared in a location accessible from the compute nodes. Make sure the container includes the shell and software required by the Nextflow process.

For more detailed information about writing Nextflow workflows, process directives, channels, executors, and container support, refer to the official Nextflow documentation.
