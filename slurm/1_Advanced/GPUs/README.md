# Example script for GPU usage

This directory includes a [basic example](./BasicGPUExample.bash) that shows how to request and run a GPU-enabled job on CCR's clusters.  

## How to use

CCR's academic cluster has a mix of compute nodes from various generations of hardware with a variety of GPU types in them. Most of these compute nodes have either 1 or 2 GPUs, while one node has 12 
A16 GPUs.  The faculty cluster has a variety of GPU nodes that are available when idle through the `scavenger` partition.  Use the `snodes` command to search for details on both clusters.  See [here](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#node-features) for more info.  Use the [Slurm dashboard](https://dashboard.ccr.buffalo.edu/slurm/ubhpc) to see what types of GPU nodes are currently available in the UB-HPC cluster.

The provided [script](./BasicGPUExample.bash) is a minimal Slurm example that requests a GPU. Make sure to modify parts of the script to suit your GPU requirements and specific needs. For 
more details, refer to the [Advanced README](../README.md).

If you need more than the default, you can specify hardware requirements using the Slurm `--constraint` directive in the batch script. Supported GPU types include `A16`, `A40`, `A100`, `H100`, `GH200`, and `V100`.

For an example, see the [slurm-options.sh](../../slurm-options.sh) file. For additional options and details refer to our [documentation](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#slurm-directives-partitions-qos).

## Monitoring GPU Usage

### Using Grafana Charts

CCR provides detailed performance metrics through Grafana charts, including GPU, CPU, and memory usage for running and completed jobs. 
- Access via OnDemand: Navigate to Active Jobs, click the dropdown for your job, and select `View detailed metrics` for Grafana.
- Access via Terminal: You need to query Slurm for the appropriate start and end times and get the node list. To do this, we provide a script that can be run in the terminal that creates the Grafana 
URL for your job:
```
ccr-jobview-url [JobID] [cluster]
```
Then you would paste the outputed link into your browser.

### Using NVIDIA Tools

Login to the node where your job is currently running, following [these instructions](https://docs.ccr.buffalo.edu/en/latest/hpc/login/#compute-node-logins). Once on the node use this command to see 
the GPU(s) your job has been assigned and the current usage:
```
nvidia-smi
```
Sample output:
```
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 570.86.15              Driver Version: 570.86.15      CUDA Version: 12.8     |
|-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA GH200 480GB             On  |   00000009:01:00.0 Off |                    0 |
| N/A   27C    P0             73W /  700W |       1MiB /  97871MiB |      0%      Default |
|                                         |                        |             Disabled |
+-----------------------------------------+------------------------+----------------------+

+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|  No running processes found                                                             |
+-----------------------------------------------------------------------------------------+
```

## Advanced

### Running Across Multiple GPU Nodes

Though you could request multiple nodes with GPUs, our GPU nodes are under heavy demand and wait times can be long, even when only requesting a single GPU. Please monitor your jobs using Grafana to 
ensure your code runs on 2 GPUs before requesting multiple nodes.

### Using all CPUs on a multi-GPU node

By default, GPUs are bound to specifc CPUs, so even with the `--exclusive` flag, your job only uses CPUs tied to your GPU. To access all CPUs on the node, add 
this to your script:
```
#SBATCH --gres-flags=disable-binding
```
More information can be found [here](https://docs.ccr.buffalo.edu/en/latest/faq/#how-do-i-request-all-cpus-on-a-node-with-more-than-one-gpu).

### GH200 GPU Nodes

The two NVIDIA GraceHopper compute nodes each have 2 GH200 GPUs and 72 ARM64 Neoverse CPUs and are available in the arm64 partition. For access to this partition, PIs should [request an 
allocation](https://docs.ccr.buffalo.edu/en/latest/portals/coldfront/#request-an-allocation) in ColdFront. The CPUs in these compute nodes are ARM64 based architecture and will require codes to be 
compiled for that architecture. To manually compile, request a node using an [interactive login](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission) where you'll be able to 
access compilers appropriate for this architecture. We recommend using [NVIDIA containers](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/#arm64-containers) specifically for `arm64` 
architecture rather than compiling your own codes.

