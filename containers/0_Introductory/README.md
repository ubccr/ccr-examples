# Introductory Python Container
If you'd like to utilize a newer version of Python than what is installed in CCR's software repository or your workflow requires the use of GPUs, utilizing Python in a container environment is the ideal choice.

For container use with GPUs, please refer to our [GPU container documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/#gpu-enabled-containers-with-apptainer).

This example demonstrates how to download a Python Docker container, convert it to an Apptainer file, and run a simple script to extract the Python version.

Please refer to our [container documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/) for more information on using containers.

## Pulling the container 
1. Start an interactive job

Request a job allocation from a login node:
```
salloc --cluster=[cluster] --partition=[partition] --qos=[qos] --mem=32GB --time=01:00:00 --no-shell
```

Sample output:

```
salloc: Pending job allocation [JobID]
salloc: job [JobID] queued and waiting for resources
salloc: job [JobID] has been allocated resources
salloc: Granted job allocation [JobID]
salloc: Waiting for resource configuration
salloc: Nodes [NodeID] are ready for job
```

Once the requested node is available, use the `srun` command to login to the compute node:
```
srun --jobid=[JobID] --export=HOME,TERM,SHELL --pty /bin/bash --login
```

After connecting, you should notice your command prompt has changed from `CCRRusername@login1:~$` to `CCRRusername@[NodeID]:~$`, indicating you're now on the compute node allocated to you.

> [!NOTE]
> Refer to the CCR documentation for more information on [running interactive jobs](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission) and [pulling containers](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/#pulling-images).

2. Navigate to your build directory & set a temp directory for cache

In this example we're using our project directory for our build directory, where we must make a cache subdirectory and export the `$APPTAINER_CACHEDIR` environment variable with the following commands:
```
cd /projects/academic/[YourGroupName]/[CCRUsername] 
mkdir cache
export APPTAINER_CACHEDIR=/projects/academic/[YourGroupName]/[CCRUsername]/cache
```
   
3. Pull the specified Docker Python Image 
   
Use the `apptainer pull` command, specifying the target container file to be `python.sif`. The specified Python image is stored at `docker://python:3`.

```
apptainer pull python.sif docker://python:3
```

## Running the Container image

In this example, we are using [`print_version.py`](./print_version.py), a Python script that simply prints the version of Python. Ensure you are on a compute node and that you have copied the `print_version.py` file to your build directory. 

Run the following command:
```
apptainer exec python.sif python print_version.py
```

Your output will look similar to: `3.14.0 (main, Oct 21 2025, 11:44:31) [GCC 14.2.0]`

Once you're done with the node, use the `exit` command. Then, release your job's allocated resources by running  `scancel [JobID]`, where `[JobID]` can be obtained by the command `squeue --me`, which lists your currently running jobs.

```
exit
scancel [JobID]
```

> [!NOTE]
> If you don't cancel the job, Slurm will release the allocated resources when the time requested for the job expires and you'll be automatically logged out of the compute node.

## Additional Information

- The [Placeholders](../README.md#placeholders) section lists the available options for each placeholder used in the example scripts.
