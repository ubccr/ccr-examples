# Using the Scavenger Partition

In an effort to maximize the use of all available cores within our center, we provide access to all compute nodes whenever they are idle. This means that academic UB-HPC users will have access to idle nodes on the industry partition as well as nodes in the faculty cluster. These idle nodes are available through the scavenger partitions on the UB-HPC and faculty clusters and jobs are allowed to run on them when there are no other pending jobs scheduled for them.

When a user with access to the partition submits a job requesting resources, any jobs running in the scavenger partition are stopped and re-queued. This means if you're running a job in the scavenger partition on the industry cluster and an industry user submits a job requiring the resources you're consuming, your job will be stopped.

An example Scavenger script, [ScavengerExample.bash](./ScavengerExample.bash) is provided for reference. Be sure to modify parts of the script to suit your specific needs. For more details, refer to the [Advanced README](../README.md).

## Requirements for using the Scavenger Partitions:

- Your jobs MUST be able to checkpoint otherwise you'll lose any work when your jobs are stopped and re-queued.
- You must be an advanced user that understands the queuing system, runs efficient jobs, and can get checkpointing working on your jobs independently. CCR staff can not devote the time to helping you write your code.
- If your jobs are determined to cause problems on any of the private cluster nodes and we receive complaints from the owners of those nodes, your access to the scavenger partitions will be removed.

## How to Check Available Scavenger Resources

We provide a few scripts that users can run on the login nodes to see what's currently available for scavenging:

- To check available resources on the UB-HPC and Faculty clusters, use: `/usr/local/bin/scavenger-checker`,
Add `-all` to view information for all nodes: `/usr/local/bin/scavenger-checker-all`
- To get a detailed breakdown of all compute nodes in the cluster, use: `/usr/local/bin/scavenger-profiler`, 
For a complete view across all nodes, use: `/usr/local/bin/scavenger-profiler-all`

## Disable Automatic Requeuing:

As mentioned above, jobs in the scavenger partition that are preempted and cancelled are automatically requeued. If you don't want your job requeued, use the Slurm option `--no-requeue`.
