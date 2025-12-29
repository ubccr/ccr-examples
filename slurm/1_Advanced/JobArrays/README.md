# Example Script for Slurm Job Arrays

This directory includes an [example script](./job-array-example.bash) that shows how to run a Job Array on CCR's clusters. Be sure to modify parts of the script to suit your specific needs.

## What Are Job Arrays
Job Arrays let you submit multiple similar jobs using a single Slurm batch script. Each job in the array shares the same requested resources specified in your batch script.

## Specifying Arrays
The resource flag `--array` sets a job array with specified index values to be submitted. The formatting for this is as follows:  
```
#SBATCH --array=0-3      #  Submits a job array between index values 0 and 3.  
#SBATCH --array=1,3,5,7  #  Submits a job array with the index values of 1, 3, 5, and 7.
```

> Note: We can limit the amount of tasks running in a job array with the `%` operator. For example, if we submit `#SBATCH --array=0-100%4`, Slurm will run the first four tasks. When one finishes, the next task in the array will start automatically. However, the total number of tasks run in that job array still must not exceed the partition limit.

## Using Array IDs
As shown in [job-array-example.bash](./job-array-example.bash), the environment variables $SLURM_ARRAY_JOB_ID and $SLURM_ARRAY_TASK_ID can be used in the body of the batch script and passed to other commands such as `srun` or in the case of this example, `echo`. However, environment variables can NOT be used in `#SBATCH` directives such as `--output` and `--error`. Instead, you must use these format symbols to specify unique output file names:

- `%A` is the job array master job ID ($SLURM_ARRAY_JOB_ID)
- `%a` is the individual job index number ($SLURM_ARRAY_TASK_ID)
```
#SBATCH --output="slurm-%A_%a.out"  #  Generates files with names: "slurm-${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}.out"
```

## Example:
```
##  Specify what jobs in the array will run
#SBATCH --array=0-3

##  Output files format
#SBATCH --output="slurm-%A_%a.out"
```
The above job array with this formatting would generate the following output files if [JobID] was the ID of the job you ran:
- `"slurm-[JobID]_0.out"`
- `"slurm-[JobID]_1.out"`
- `"slurm-[JobID]_2.out"`
- `"slurm-[JobID]_3.out"`

An example of running this job, then checking the file outputs:
```
sbatch job-array-example.bash
Submitted batch job [JobID]

cat slurm-[JobID]_0.out
Hello World from job [JobID], task 0 on node:[NodeID].core.ccr.buffalo.edu

cat slurm-[JobID]_1.out
Hello World from job [JobID], task 1 on node:[NodeID].core.ccr.buffalo.edu

cat slurm-[JobID]_2.out
Hello World from job [JobID], task 2 on node:[NodeID].core.ccr.buffalo.edu

cat slurm-[JobID]_3.out
Hello World from job [JobID], task 3 on node:[NodeID].core.ccr.buffalo.edu
```


  ## Learn More
- [CCR's Documentation](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#job-arrays)
- [Slurm Documentation](https://slurm.schedmd.com/job_array.html)
