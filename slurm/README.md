# Example Slurm scripts

These are examples of how to setup a slurm job on CCR's clusters. Refer to our documentation on [running and monitoring jobs](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/) for detailed information.  These examples supplement the documentation.  It's important to understand the concepts of batch computing and CCR's specific cluster use and limits prior to using these examples.

## How to use

The `slurm-options.sh` file in this directory provides a list of the most commonly used Slurm directives and a short explanation for each one.  It is not necessary to use all of these directives in every job script.  In the sample scripts throughout this repository, we list the required Slurm directives and a few others just as examples.  Refer to the `slurm-options.sh` file for a more complete list of directives and also to our [documentation](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#slurm-directives-partitions-qos) for specific cluster and partition limits.  Know that the more specific you get when requesting resources on CCR's clusters, the fewer options the job scheduler has to place your job.  When possible, it's best to only specify what you need to and let the scheduler do it's job.  If you're unsure what resources your program will require, we recommend starting small and [monitoring the progress](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#monitoring-jobs) of the job, then you can scale up.

At CCR you should use the bash shell for your Slurm scripts; you'll see this on the first line of every example we share.  In a bash script, anything after the `#` is considered a comment and is not interpretted when the script is run.  In the case of Slurm scripts though, the Slurm scheduler is specifically looking for lines that start with `#SBATCH` and will interpret those as requests for your job.  Do NOT remove the `#` in front of the `SBATCH` command or your batch script will not work properly.  If you don't want Slurm to look at a particular `SBATCH` line in your script, put two `#` in front of the line.  

## Navigating these directories  

- `0_Introductory` - contains beginner batch scripts for the ub-hpc and faculty clusters  
- `1_Advanced` - contains batch scripts for more complicated use cases such as job arrays and using the scavenger partition  
- `2_ApplicationSpecific` - contains batch scripts for a variety of applications that have special setup requirements.  You will not find an example script for every piece of software installed on CCR's systems  



