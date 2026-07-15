# Example Seurat Container with scRNA analysis

## Building the container

Please refer to CCR's [container documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/) for more detailed information on building and using Apptainer.

A brief guide to building the seurat container for scRNA analysis follows:

1. Start an interactive job

Apptainer is not available on the CCR login nodes and the compile nodes may not provide enough resources for you to build a container. We recommend requesting an interactive job on a compute node to conduct this build process. 
See CCR documentation for more info on [submitting an interactive job](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission).

```
CCRusername@cpn-h23-04:~$ salloc --cluster=ub-hpc --partition=general-compute --qos=general-compute --mem=32GB --time=02:00:00
salloc: Granted job allocation 20821331
salloc: Nodes cpn-q08-28-02 are ready for job
```

2. Navigate to your build directory & set a temp directory for cache. Ensure you've placed your `seurat.def` file in your build directory
```
CCRusername@cpn-h23-04:~$ cd /projects/academic/[YourGroupName]/[CCRusername]
CCRusername@cpn-h23-04:/projects/academic/[YourGroupName]/[CCRusername]$ mkdir cache
CCRusername@cpn-h23-04:/projects/academic/[YourGroupName]/[CCRusername]$ export APPTAINER_CACHEDIR=/projects/academic/[YourGroupName]/[CCRusername]/cache
```

3. Build the container
```
CCRusername@cpn-h23-04:/projects/academic/[YourGroupName]/[CCRusername]$ apptainer build seurat-$(arch).sif seurat.def
INFO:    The %post section will be run under the fakeroot command
INFO:    Starting build...
INFO:    Fetching OCI image..
..............
INFO:    Creating SIF file...
[========
INFO:    Build complete: seurat-x86_64.sif
```

## Run the container

1. Start an interactive job e.g.
```
$ salloc --cluster=ub-hpc --partition=general-compute --qos=general-compute --mem=128GB --nodes=1 --cpus-per-task=1 --tasks-per-node=32 --time=08:00:00
```

2. Run the container and bind mount the directory with sample files into the container:
```
CCRusername@cpn-h23-04:/projects/academic/[YourGroupName]/[CCRusername]$ apptainer shell -B /util/software/data/seurat/:/util/software/data/seurat/ seurat-x86_64.sif
Apptainer>
```

## Run the scRNA analysis ([`example_scRNA_seurat.R`](./example_scRNA_seurat.R))
```
Apptainer> R --no-save < example_scRNA_seurat.R
```
