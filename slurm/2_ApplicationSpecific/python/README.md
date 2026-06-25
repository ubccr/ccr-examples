# Python on the CCR Clusters

This directory includes examples of a serial and parallel Python job, with a GPU utilization example coming soon. Additional documentation about the use of Python at CCR can be found in [CCR's Python documentation](https://docs.ccr.buffalo.edu/en/latest/howto/python/).  Users affiliated with the University at Buffalo can access an open enrollment self paced course about [Using Python at CCR](https://ublearns.buffalo.edu/d2l/le/discovery/view/course/288741) through UB Learns.  The pre-recorded video portions of the course are available to all users on [CCR's YouTube channel](https://youtube.com/@ubccr).

## Serial Python job

A serial Python job is one that requires only a single CPU-core.

The provided [serial example](./serial) is of a Python program [fibonacci.py](./serial/fibonacci.py) with the corresponding Slurm script [python-sp.bash](./serial/python-sp.bash) that can be modified to run a serial Python job.

To run the Python script, simply submit the job to the scheduler from a login node with the following command:
```
sbatch python-sp.bash
```

## Parallel Python Tutorial

Parallel processing is a technique that executes multiple tasks at the same time using multiple CPU cores. There are numerous APIs available to run Python code in parallel, each with their strengths and weaknesses.

### [Joblib](./parallel)

For tasks that are embarrassingly parallel or those using large NumPy arrays, `joblib` can be an efficient and convenient solution. In this example, [fibonacci_joblib.py](./parallel/fibonacci_joblib.py), Fibonacci numbers are computed in separate processes without any dependencies across processes. This type of computation is considered **embarrassingly parallel**.

The following line in the provided example script shows how to apply the function to compute fibonacci numbers across an array of input values: 
```
results = Parallel(n_jobs=8)(delayed(fib)(n) for n in my_values)
```

In this case, we are applying the `fib` function to each value `n` in our `my_values` list. 

`n_jobs=8` creates 8 independent Python tasks where each task performs the computation in parallel. 

A corresponding Slurm script [python-joblib.bash](./parallel/python-joblib.bash) is provided. To run the example, submit the job using:
```
sbatch python-joblib.bash
```

### Important Facts for Parallel Jobs

To see runtime improvements from parallel processing, make sure to request as many CPUs for your Slurm job as the number of processes you want to run. This can be done using Slurm options such as `ntasks_per_node` or `cpus_per_task`. 

The `cpus_per_task` option specifies the number of CPU cores available to each task which can be used by threads inside the process for memory if your code is multithreaded. The `ntasks_per_node` option specifies the number of tasks placed on each node.
 
For example, if you request `ntasks_per_node=2` and `cpus-per-task=4`, you have `2 * 4 = 8` CPUs that can run tasks (or threads inside tasks) at the same time.

In the provided [joblib](./parallel/python-joblib.bash) example, `n_jobs` or the number of parallel processes, should match the number of CPUs or tasks you request in order to see any runtime improvements. The provided example Slurm script only uses 8 CPUs, so you will not see any performance improvement as `n_jobs` increases beyond 8. Furthermore, increasing the amount of processes running in parallel may not improve runtime in all cases, as there is overhead to managing each additional process.

For a more in depth discussion on `joblib`, please refer to the [Joblib documentation](https://joblib.readthedocs.io/en/stable/).
