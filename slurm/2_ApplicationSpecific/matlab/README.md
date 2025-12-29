# MATLAB on the CCR Clusters

This directory includes examples of serial, multithreaded, and GPU  MATLAB jobs.

## Serial MATLAB job ([serial/](./serial))

A serial MATLAB job is one that requires only a single CPU-core.

Provided is an example of a trivial, one-line serial MATLAB program [hello_world.m](./serial/hello_world.m) with the corresponding Slurm script [matlab-sp.bash](./serial/matlab-sp.bash) that can be modified to run a serial MATLAB job. By invoking MATLAB with `-singleCompThread` `-nodisplay` `-nosplash`, the GUI is suppressed as is the creation of multiple threads.

To run the MATLAB script, simply submit the job to the scheduler from a login node with the following command:
```
sbatch matlab-sp.bash
```
- NOTE: When you're done, make sure to quit MATLAB and then type `exit` to log out of the compute node and properly release the resources for other users.

## Multi-threaded MATLAB Job ([multithreaded/](./multithreaded))

If your code utilizes the Parallel Computing Toolbox (e.g., `parfor`) or you have intense computations that can benefit from the built-in multi-threading provided by MATLAB's BLAS implementation, you can run in multi-threaded mode. You can use up to all the CPU-cores on a single node in this mode.

Provided is an example from MathWorks of using multiple cores [for_loop.m](./multithreaded/for_loop.m). The example Slurm script [matlab-mp.bash](./multithreaded/matlab-mp.bash) can be modified to run a single node, multi-threaded MATLAB job.

- NOTE: For multi-node jobs you will need to use the [MATLAB Parallel Server](https://docs.ccr.buffalo.edu/en/latest/howto/matlab/#running-multi-node-jobs-using-matlab-parallel-server). You should always use `#SBATCH --nodes=1` for multi-threaded and serial calculations.

- NOTE: To achieve optimal performance, you must tune the `--cpus-per-task` value. Use the smallest value that gives you a significant performance boost because the more resources you request the longer your queue time may be.

By default MATLAB will restrict you to 12 worker threads. You can override this when making the parallel pool with the following line, for example, with 24 threads:
```
poolobj = parpool('local', 24);
```

## MATLAB on GPUs ([GPU/](./GPU))

MATLAB has support for running on GPUs. Provided is a MATLAB script [svd_matlab.m](./GPU/svd_matlab.m) that performs a matrix decomposition using a GPU with the corresponding slurm script [matlab-gpu.bash](./GPU/matlab-gpu.bash).

In the Slurm script `matlab-gpu.bash`, notice the new line: `#SBATCH --gpus-per-node=1`, this tells slurm to request a node with 1 GPU.
For interactive MATLAB jobs, a GPU can be requested the same way. For example, add this to your `salloc` command to request 1 GPU: `--gpus-per-node=1`.
