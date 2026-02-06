# Example Quantum ESPRESSO Slurm scripts using nvidia's QE container

Quantum ESPRESSO is an integrated suite of Open-Source computer codes for
electronic-structure calculations and materials modeling at the nanoscale,
plane waves, and pseudopotentials

## Slurm scripts

These Slurm scripts are templates.
You will have to provide cluster, partition, qos, account information,
and possibly "cpus-per-task" depending on the nodes you wish to use.

There are many "--constraint=" line examples in each Slurm script.  
There must be only one "--constraint=" line starting with "#SBATCH"  
If you use multiple "#SBATCH --constraint=" lines, only the last one
will be used to constrain the job.

e.g.

```
#SBATCH --constraint="EMERALD-RAPIDS-IB&H100"
```

This example requests an H100 GPU node connected to the "EMERALD-RAPIDS-IB"
Infiniband network."


For the single node examples, replace "[CCRgroupname]" in the "CONTAINER_DIR=" line:

```
CONTAINER_DIR="/projects/academic/[CCRgroupname]/QE"
```

For the multi node examples ALSO replace "[CCRgroupname]" in the
"GS" Global Scratch line:

```
GS="/vscratch/[CCRgroupname]/QE/${TIMESTAMP}"
```

## Quantum ESPRESSO Slurm script examples

### One node scripts

x86_64

[QE 1 GPU 1 node Slurm Script](https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/Quantum_ESPRESSO/quantum_espresso_1_GPU_1_node.bash)  
[QE 2 GPUs 1 node Slurm Script](https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/Quantum_ESPRESSO/quantum_espresso_2_GPU_1_node.bash)

ARM64

[QE 1 GPU 1 ARM64 node Slurm Script](https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/Quantum_ESPRESSO/quantum_espresso_1_GPU_1_node_ARM64.bash)  


### Two node scripts:

x86_64

[QE 1 GPU 2 node Slurm Script](https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/Quantum_ESPRESSO/quantum_espresso_1_GPU_2_nodes.bash)  
[QE 2 GPU 2 node Slurm Script](https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/Quantum_ESPRESSO/quantum_espresso_2_GPU_2_nodes.bash)

ARM64

[QE 1 GPU 2 ARM64 node Slurm Script](https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/Quantum_ESPRESSO/quantum_espresso_1_GPU_2_nodes_ARM64.bash)


See the [Quantum ESPRESSO website](https://www.quantum-espresso.org) and [Quantum ESPRESSO Documentation](https://www.quantum-espresso.org/documentation/) for more information on Quantum ESPRESSO.  
For more info on the container image, see the [nvidia Quantum ESPRESSO container page](https://catalog.ngc.nvidia.com/orgs/hpc/containers/quantum_espresso) on their NGC Catalogue website.

