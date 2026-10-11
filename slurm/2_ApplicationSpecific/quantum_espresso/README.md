# Quantum ESPRESSO on the CCR Clusters

This directory includes examples of single and multi-node Quantum Espresso CPU and GPU Slurm scipts

In these examples the Quantum ESPRESSO binary "pw.x" is only provided the input file as a parameter.
To effectively use Quantum ESPRESSO in parallel there are additional parameters that should be set
(specific to your use case) to distribute the processing over the requested resources, that is:
-nimage, -npools, -nband, -ntg, -ndiag or -northo (shorthands, respectively: -ni, -nk, -nb, -nt, -nd) 

See the [Quantum ESPRESSO Parallelization levels documentation](https://www.quantum-espresso.org/Doc/user_guide/node20.html) for more information


## Example CPU Scripts

[quantum_espresso_CPU_1_node.bash](./quantum_espresso_CPU_1_node.bash)  
[quantum_espresso_CPU_2_node.bash](./quantum_espresso_CPU_2_node.bash)

## Example GPU Scripts

[quantum_espresso_1_GPU_1_node.bash](./quantum_espresso_1_GPU_1_node.bash)  
[quantum_espresso_1_GPU_2_node.bash](./quantum_espresso_1_GPU_2_node.bash)  
[quantum_espresso_2_GPU_1_node.bash](./quantum_espresso_2_GPU_1_node.bash)  
[quantum_espresso_2_GPU_2_node.bash](./quantum_espresso_2_GPU_2_node.bash)


