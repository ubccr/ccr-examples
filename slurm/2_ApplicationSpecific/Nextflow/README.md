# Nextflow

This example demonstrates how to configure Nextflow to submit workflow processes to Slurm on CCR systems.

The example is intentionally simple and is meant to demonstrate CCR-specific configuration rather than teach Nextflow pipeline development. For information on creating and developing Nextflow workflows, refer to the official Nextflow documentation.

## Files

- `main.nf` - A simple multi-process Nextflow workflow.
- `nextflow.config` - CCR-specific Slurm configuration for running Nextflow processes.
- `container-test.nf` - Initial example of running a Nextflow process with a Docker Hub container through Apptainer.
- `container.config` - Slurm and Apptainer configuration used for the initial container test.

## CCR Software

Nextflow is available through CCR's software module system.

```bash
module load nextflow/25.10.2
```

Containerized workflows also require Apptainer:

```bash
module load apptainer
```

## Running the Example

The included configuration uses the Slurm executor so that Nextflow processes are submitted as Slurm jobs on CCR compute nodes.

Before running the example, replace the placeholder Slurm account, partition, and QOS values in `nextflow.config` with values appropriate for your CCR account.

Nextflow should be launched from within a Slurm allocation rather than directly from a login node. See the [Launching Nextflow](#launching-nextflow) section below for interactive and batch examples.

Once you are on the appropriate compute node, run:

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

Some software modules require prerequisite modules to be loaded first. Use:

```bash
module spider [software/version]
```

to check module dependencies before adding them to a Nextflow process.

## Running Containerized Processes

Nextflow can run processes inside Apptainer containers on CCR compute nodes.

A Nextflow process can specify a local container image using the `container` directive.

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

Container images should be stored in a location accessible from the compute nodes, preferably within your project space.

Make sure the container includes the shell and software required by the Nextflow process.

If your workflow pulls or caches container images, set the Apptainer cache directory to a location with sufficient storage rather than using your home directory.

For example:

```bash
mkdir -p /projects/academic/[YourGroupName]/[CCRUsername]/apptainer-cache
export APPTAINER_CACHEDIR=/projects/academic/[YourGroupName]/[CCRUsername]/apptainer-cache
```

## Launching Nextflow

Nextflow workflows can be launched on CCR using either an interactive job or a batch job.

If your workflow can run without user interaction, a batch job is recommended. If you need to monitor or interact with the workflow while it is running, use an interactive job.

### Interactive Job

To launch Nextflow interactively, first request a small Slurm allocation from a login node:

```bash
salloc --clusters=[cluster] --partition=[partition] --qos=[qos] --mem=4GB --time=01:00:00 --no-shell
```

Replace `[cluster]`, `[partition]`, and `[qos]` with values appropriate for your CCR account.

Once the allocation is available, use `srun` to log in to the assigned compute node:

```bash
srun --jobid=[JobID] --export=HOME,TERM,SHELL --pty /bin/bash --login
```

Replace `[JobID]` with the job ID returned by `salloc`.

After connecting to the compute node, load the required modules:

```bash
module load apptainer
module load nextflow/25.10.2
```

If your workflow uses Apptainer containers, set the cache directory to a location with sufficient space, preferably within your project directory:

```bash
mkdir -p /projects/academic/[YourGroupName]/[CCRUsername]/apptainer-cache
export APPTAINER_CACHEDIR=/projects/academic/[YourGroupName]/[CCRUsername]/apptainer-cache
```

You can then launch the workflow from the compute node:

```bash
nextflow run main.nf
```

Nextflow itself runs inside the interactive allocation, while individual workflow processes are submitted to Slurm according to the resource settings defined in `nextflow.config`.

When you are finished, exit the compute node:

```bash
exit
```

Then cancel the interactive allocation if it is still active:

```bash
scancel [JobID]
```

### Batch Job

For workflows that do not require interaction, launch Nextflow using a Slurm batch job.

Create a batch script that requests the resources needed for the Nextflow launcher and loads both Apptainer and Nextflow before starting the workflow.

For example:

```bash
#!/bin/bash -l
#SBATCH --clusters=[cluster]
#SBATCH --partition=[partition]
#SBATCH --qos=[qos]
#SBATCH --account=[SlurmAccountName]
#SBATCH --mem=4GB
#SBATCH --time=01:00:00
#SBATCH --job-name=nextflow

module load apptainer
module load nextflow/25.10.2

mkdir -p /projects/academic/[YourGroupName]/[CCRUsername]/apptainer-cache
export APPTAINER_CACHEDIR=/projects/academic/[YourGroupName]/[CCRUsername]/apptainer-cache

nextflow run main.nf
```

Replace `[cluster]`, `[partition]`, `[qos]`, `[SlurmAccountName]`, `[YourGroupName]`, and `[CCRUsername]` with values appropriate for your CCR account and project.

Submit the script from a login node with:

```bash
sbatch nextflow-job.sh
```

The resources requested in this batch job are for the Nextflow launcher itself.

Individual Nextflow processes are submitted to Slurm according to the executor and resource settings defined in `nextflow.config`.

For example, a CCR Slurm configuration may include:

```groovy
process {
    executor = 'slurm'

    clusterOptions = '--clusters=[cluster] --partition=[partition] --qos=[qos] --account=[SlurmAccountName]'
}
```

Resource requirements such as CPUs, memory, and runtime can also be defined at the process level.

For example:

```groovy
process {
    withName: EXAMPLE_PROCESS {
        cpus = 2
        memory = '4 GB'
        time = '1h'
    }
}
```

Container images and the Apptainer cache must be stored in locations accessible from the compute nodes, preferably within project storage.

## Additional Information

This example focuses on CCR-specific setup for running Nextflow with Slurm and Apptainer.

For more detailed information about writing Nextflow workflows, process directives, channels, executors, configuration files, and container support, refer to the official Nextflow documentation:

https://www.nextflow.io/docs/latest/
