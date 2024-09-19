# Example faculty cluster job

This is an example of how to setup a slurm job on the faculty cluster.  Substitute `partition_name` for the partition you'd like to run your job on and ensure that this same name is used in the `--qos` line.  To see what access you have to faculty partitions, please view your allocations in [ColdFront](https://coldfront.ccr.buffalo.edu).  

## How to use

TODO: write me

## How to launch an interactive job on the faculty cluster  

Use the `salloc` command and the same Slurm directives as you use in a batch script to request an interactive job session.  Please refer to our [documentation](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission) for proper setup of the request and command to use to access the allocated node.