# Example Micro-C Pipeline container

## Building the container

A brief guide to building the Micro-C container follows:<br/>
Please refer to CCR's [container documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/) for more detailed information on building and using Apptainer.

1. Start an interactive job

> [!IMPORTANT]
> Apptainer is not available on the CCR login nodes and the compile nodes may not provide enough resources for you to build a container.  We recommend requesting an interactive job on a compute node to conduct this build process.<br/>
> See CCR docs for more info on [running jobs](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission).

```
salloc --cluster=ub-hpc --partition=debug --qos=debug --exclusive --time=01:00:00
```

Sample output:
```
salloc: Pending job allocation [JobID]
salloc: job [JobID] queued and waiting for resources
salloc: job [JobID] has been allocated resources
salloc: Granted job allocation [JobID]
salloc: Nodes [NodeID] are ready for job
CCRusername@[NodeID]:~$
```

2. Navigate to your build directory & set a temp directory for cache

You should now be on the compute node allocated to you.  In this example we're using our project directory for our build directory.  Ensure you've placed your `openff-toolkit.def` and `environment.yml` file in your build directory

```
cd /projects/academic/[YourGroupName]/[CCRusername]
mkdir cache
export APPTAINER_CACHEDIR=/projects/academic/[YourGroupName]/[CCRusername]/cache
```

3. Build your container

```
apptainer build Micro-C-$(arch).sif Micro-C.def
```
Expected output:
```
...
...
INFO:    Adding environment to container
INFO:    Creating SIF file...
INFO:    Build complete: Micro-C-x86_64.sif
```

## Running the container

Start an interactive job e.g.

```
salloc --cluster=ub-hpc --partition=general-compute --qos=general-compute --mem=128GB --nodes=1 --cpus-per-task=1 --tasks-per-node=32 --time=05:00:00
```

...then run the container


```
cd /projects/academic/[YourGroupName]/[CCRusername]
apptainer shell -B /util:/util,/scratch:/scratch,/vscratch:/vscratch,/projects:/projects Micro-C-$(arch).sif
```
Expected prompt:
```
Apptainer>
```

To download the HTML documents - from the "Apptainer>" prompt:

```
pushd /var/tmp
mkdir Micro-C_html
cd Micro-C_html/
(cd /opt/Micro-C/HiChiP/docs/build && tar cf - --transform 's|^html|HiChiP/|' html/) | tar xf -
(cd /opt/Micro-C/docs/build && tar cf - --transform 's|^html|Micro-C/|' html/) | tar xf -
cd ..
rm -f ~/Micro-C_html.zip
zip -r ~/Micro-C_html.zip Micro-C_html/
rm -rf Micro-C_html/
popd
```

This will create a Micro-C_html.zip file in your home directory
you can download this, then expand the zip file on your computer and
view the files e.g. on a Mac

Open a Terminal e.g. [Utilities] [Terminal.app]
```
cd ~/Downloads
scp [CCRusername]@vortex.ccr.buffalo.edu:Micro-C_html.zip .
unzip Micro-C_html.zip
```
In Finder go to [Downloads] [Micro-C_html]
In both the [HiChiP] and the [Micro-C] directories, click on the "index.html" file

All the commands in the Micro-C docs should run as they appear in these docs
(paths have been changed to refer to the location of tools in the container)


See the [Micro-C](https://micro-c.readthedocs.io/en/latest/index.html) website and the [Micro-C github repo](https://github.com/dovetail-genomics/Micro-C) website for more info on Micro-C
