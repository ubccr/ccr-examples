# Running Abaqus with Apptainer

Abaqus 2024 is available via an Apptainer/Singularity container. The Abaqus container file can be found in this directory: `/util/software/containers/x86_64/abaqus-2024.sif` which is accessible when logged into CCR's HPC environment.
This is a large file (10GB) so please be sure to copy it to a location where you have enough space (i.e. your project directory), or you can run the container from this location.

**Note**: Apptainer/Singularity is only available on compute and compile nodes. Please refer to our [container documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/) for more information on using containers.

## Abaqus Command Line/Batch Script

There are several options to run Abaqus from the command line. If you're unsure of the options to provide or want to run the application more interactively, use the `shell` option with Apptainer. This will drop you into the container and then you can work with Abaqus interactively. For example:
```
apptainer shell /[path-to-container]/abaqus-2024.sif
Apptainer> abaqus help
```

If you know what options you need to run Abaqus, use the `exec` option with Apptainer and specify them all in the apptainer command. For example:
```
apptainer exec /[path-to-container]/abaqus-2024.sif abaqus [options]
```

See the [Abaqus documentation](https://docs.software.vt.edu/abaqusv2024/English/?show=SIMACAEEXCRefMap/simaexc-c-analysisproc.htm) for the full list of command line options.

**Tip**: You will automatically get access to your home directory within the container as well as the directory you're in when you launch the container (`$PWD`). If you also want access to your project directory or your job's scratch directory, use the `-B` option.  This tells Apptainer/Singularity which directories on the compute node you want to bind mount into the container. Specify the full path on the compute node, followed by a colon : and then the name you'd like to give the directory in the container.  For example, to access the node's scratch directory we would specify:  `/scratch:/scratch` and once the container launches you could access your job's scratch directory in the container in `/scratch`.  To bind mount your project directory use something like: `/projects/academic/[YourGroupName]:/projects/academic/[YourGroupName]`. To bind mount more than one directory, separate them by commas.  This would update the previous example command to this:
```
apptainer exec -B /scratch:/scratch,/projects/academic/[YourGroupName]:/projects/academic/[YourGroupName] /[path-to-container]/abaqus-2024.sif abaqus [options]
```

A Slurm script [`abaqus-test.bash`](./abaqus-test.bash) is provided with all necessary configuration for running Abaqus as a batch job. Update the file paths and resource requests according to your needs and add the Abaqus options you need to use at the end of the Apptainer command line.

## Abaqus GUI

To run the Abaqus GUI using this container, first start an [OnDemand desktop](https://docs.ccr.buffalo.edu/en/latest/portals/ood/#interactive-apps) session. Once started, launch a terminal in the OnDemand desktop. Then run this command to start the container and launch the Abaqus GUI:
```
apptainer exec /[path-to-container]/abaqus-2024.sif abaqus cae -mesa
```

## Abaqus and GPUs

If you need to use GPUs with Abaqus you'll need to request a [GPU node](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#slurm-directives-partitions-qos) and add a few things to the Apptainer/Singularity command that starts the container. Add this after the rest of your bind mounts in the Apptainer/Singularity command: `,/opt/software/nvidia:/opt/software/nvidia --nv`

For example, to run the Abaqus GUI on a GPU node, the command would be:
```
apptainer exec /opt/software/nvidia:/opt/software/nvidia --nv /[path-to-container]/abaqus-2024.sif abaqus cae -mesa
```

**NOTE**: If you're using the Abaqus GUI, we recommend running on the viz partition and qos of the UB-HPC cluster. However, this will work from any GPU node.

Please refer to the [Abaqus (Simulia) documentation](https://docs.software.vt.edu/abaqusv2024/English/?show=SIMULIA_Established_FrontmatterMap/sim-r-DSDocAbaqus.htm) for additional information and support on using this software.
