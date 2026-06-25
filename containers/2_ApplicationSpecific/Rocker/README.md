# Example Rocker Container

## Building the container
Please refer to CCR's [container documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/) for more detailed information on building and using Apptainer.

A brief guide to building a Rocker container for use in CCR's HPC environment follows:

1. Start an interactive job

> [!NOTE]
> Apptainer is not available on the CCR login nodes and the compile nodes may not provide enough resources for you to build a container. We recommend requesting an interactive job on a compute node to conduct this build process. 
> Refer to CCR's documentation for more information on [submitting an interactive job](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission).

Request a job allocation from a login node:
```
salloc --cluster=ub-hpc --partition=debug --qos=debug --exclusive --mem=8GB --time=00:30:00
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

2. Navigate to your build directory and use the Slurm job local temporary directory for cache. Ensure `Rocker.def` is in your build directory. You may clone the [CCR examples repository](/README.md) in your directory or copy and paste the contents of the `Rocker.def` file into a new file.
```
cd /projects/academic/[YourGroupName]/[CCRusername]/Rocker
export APPTAINER_CACHEDIR="${SLURMTMPDIR}"
```

3. Once ready, build the container:
```
apptainer build Rocker-$(arch).sif Rocker.def
```
Sample output:
```
INFO:    User not listed in /etc/subuid, trying root-mapped namespace
INFO:    The %post section will be run under the fakeroot command
INFO:    Starting build...
INFO:    Fetching OCI image...
..............
INFO:    Creating SIF file...
[===============================================================] 100 % 0s
INFO:    Build complete: Rocker.sif
```

## Run the container

> [!NOTE]
> It may be necessary to change the requested resources based on the R program you want to run. For this example, we will be using minimal resources to check if our container runs. Refer to the CCR documentation for more information on [submitting an interactive job](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission).

Ensure you are on a compute node before running the container.

Run the container:
```
apptainer run Rocker-x86_64.sif
```
You should see:
```
Launching R...

R version 4.5.2 (2025-10-31) -- "[Not] Part in a Rumble"
Copyright (C) 2025 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

  Natural language support but running in an English locale

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

>
```

## Editing the definition file

This section is for users who need more than just the basic version of R. Lots of programs that run in R depend on other packages. The easiest way to install additional packages in the container is by modifying the definition file to include them and then rebuilding the container.  For this example we will edit the definition file to add a package from CRAN (a general R package manager) and BioConductor (a more specific use case R package manager). 

> [!NOTE]
> Some use cases will also require Linux packages to be installed.  We provide an [example](../seurat/seurat.def) that demonstrates how to do so, which is also a good example of how this template could be modified to run a specific workflow with custom packages.

1. Navigate to your build directory.

```
cd /projects/academic/[YourGroupName]/[CCRUsername]/Rocker
```

2. Add R packages to the definition file

We are going to add `rmarkdown` and `BiocGenerics` to our definition file. These are R files from two different package managers, so we will have to install them with their respective package managers. To do this, we will first uncomment `## Rscript -e "install.packages(c('[packages]'))"` and replace `[packages]` with `rmarkdown`. It should look like

```
## Install packages in R (from CRAN)
Rscript -e "install.packages(c('rmarkdown'))"
```

To install `BiocGenerics` we need to use the `Bioconductor` package manager. To do this we will first uncomment `## Rscript -e "[PackageManager]::install(c('[packages]'))"` and replace `[PackageManager]` with `BiocManager` and `[packages]` with `BiocGenerics`. It should look like

```
## Install packages from other maintainers in R
Rscript -e "BiocManager::install(c('BiocGenerics'))"
```

Save the edited file.

Once ready, build the container:
```
apptainer build Rocker-$(arch).sif Rocker.def
```

> [!NOTE]
> If you have already built the container previously, the output will say `Build target 'Rocker-x86_64.sif' already exists and will be deleted during the build process. Do you want to continue? [y/N]`
> If you would like to keep the original container, name the `.sif` output to something else. Otherwise, you can type `y`.

3. Test the container

Ensure you are on a compute node in the same directory as your new `.sif` file. Run the container with:
```
apptainer shell Rocker-x86_64.sif
```

You should see this
```
Apptainer>
```

Now we will run R

```
R
```

You should see something like

```
R version 4.5.2 (2025-10-31) -- "[Not] Part in a Rumble"
Copyright (C) 2025 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

  Natural language support but running in an English locale

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

>
```

We will now test if the R packages were installed

```
library(rmarkdown)
library(BiocGenerics)
```

If there is any output that looks like
```
Error in library([package]) : there is no package called ‘[package]’
```
there was an issue with the installation. Otherwise, everything is working as it should.


Refer to the documentation on [Building Images with Apptainer] (https://docs.ccr.buffalo.edu/en/latest/howto/containerization/#building-images-with-apptainer) for additional information.

Refer to the R-project documentation for more information on [Installing R Packages](https://cran.r-project.org/doc/manuals/r-release/R-admin.html#Installing-packages)

## Additional Information

- The [Placeholders](../../../README.md#placeholders) section lists the available options for each placeholder used in the example scripts.
- For more information on accessing shared project and global scratch directories, resource options, and other important container topics, please refer to the CCR [container documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/) 
