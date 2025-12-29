# Python on the CCR Clusters

This directory includes examples of a serial Python job, with mutlithreaded and GPU examples coming soon.  Additional documentation about the use of Python at CCR can be found in the CCR's [Python documentation](https://docs.ccr.buffalo.edu/en/latest/howto/python/).  Users affiliated with the University at Buffalo can access an open enrollment self paced course about [Using Python at CCR](https://ublearns.buffalo.edu/d2l/le/discovery/view/course/288741) through UB Learns.  The pre-recorded video portions of the course are available to all users on [CCR's YouTube channel](https://youtube.com/@ubccr).

## Serial Python job ([serial/](./serial))

A serial Python job is one that requires only a single CPU-core.

Provided is an example of a serial Python program [fibonacci.py](./serial/fibonacci.py) with the corresponding Slurm script [python-sp.bash](./serial/python-sp.bash) that can be modified to run a serial Python job.

To run the Python script, simply submit the job to the scheduler from a login node with the following command:
```
sbatch python-sp.bash
```

## Parallel Python Tutorial
Parallel processing is a technique that executes multiple tasks at the same time using multiple CPU cores. This directory includes examples of two ways to perform parallel processing in Python.

## Multiprocessing
There are numerous APIs available to run python code in parallel, each with their strengths and weaknesses. A common API for parallel python processing is called `multiprocessing`. This library is powerful, enabling things like interprocess communication. However, for this simple demo we will use some basic functionality.

## Joblib ([fibonacci_joblib.py](./fibonacci_joblib.py))
For tasks that are embarassingly parallel or those using NumPy arrays, `joblib` can be a more efficient and convenient solution. Since our `multiprocessing` example above involves computing fibonacci numbers in separate processes without any dependencies across processes, this computation is considered **embarassingly parallel**.  Thus, we can use `joblib` to compute Fibonacci numbers in parallel.

The following line in our example script shows how to apply the function to compute fibonacci numbers across an array of input values:
```results = Parallel(n_jobs=8)(delayed(fib)(n) for n in my_values)```

In this case, we are applying the `fib` function to each value `n` in our `my_values` list. These computations will run in parallel across 8 total processes, specified by the `njobs` parameter for the parallel computation. Please note, in order to see runtime improvements across processes, you will need to make sure to request as many CPUs for your job as the number of processes you want to run. These can be requested using the slurm `ntasks_per_node` or `cpus_per_task` options, where `njobs = ntasks_per_node * cpus_per_task`.

Our example slurm script only uses 8 CPUs, so you will not see any performance improvement as `n_jobs` increases beyond 8. Furthermore, increasing the amount of processes running in parallel may not improve runtime in all cases, as there is overhead to managing each additional process.

For a more in depth discussion on `joblib`, please refer to its [documentation](https://joblib.readthedocs.io/en/stable/).

In line 23 of this example, n_jobs or the number of parallel processes, should match the number of CPUs or tasks you request in order to see any runtime improvements.
