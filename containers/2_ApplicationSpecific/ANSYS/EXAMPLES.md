# ANSYS container examples

[ANSYS](https://ansys.synopsys.com) is a commercial suite of engineering simulation software products.

> [!WARNING]
> ANSYS is a suite of commercial programs.
> You MUST have appropriate licenses for every ANSYS product you use
> Roswell Park researchers and other commercial users should utilize their own license with ANSYS products

UB provides an educational license for ANSYS.  The license is for **academic purposes only**
All the examples use the academic license file.

All examples use the latest ANSYS version with the most recent Support Pack.


## List of Applications in the ANSYS container images

```
ACP (GUI)            == /opt/ansys_inc/v261/ACP/ACP.sh
Autodyn              == /opt/ansys_inc/v2613/autodyn/bin/autodyn
CFD-Post (GUI)       == /opt/ansys_inc/v261/cfdpost
CFX (all GUI)        == /opt/ansys_inc/v261/CFX/bin/cfx5
                     == /opt/ansys_inc/v261/CFX/bin/cfx5launch
                     == /opt/ansys_inc/v261/CFX/bin/cfx5pre
                     == /opt/ansys_inc/v261/CFX/bin/cfx5solve
                     == /opt/ansys_inc/v261/CFX/bin/cfx5post
FENSAP-ICE (GUI)     == /opt/ansys_inc/v261/fensapice/bin/fensapiceGUI
FLUENT (GUI)         == /opt/ansys_inc/v261/fluent/bin/fluent
ICEM CFD (GUI)       == /opt/ansys_inc/v261/icemcfd/icemcfd
ICEPAK [GUI broken]  == /opt/ansys_inc/v261/icepak/icepak
Mechanical APDL      == /opt/ansys_inc/v2613/ansys/bin/mapdl
Motion               == /opt/ansys_inc/v261/Motion/solver/rundfs.sh
Sherlock (GUI)       == /opt/ansys_inc/v261/sherlock/runSherlock
TurboGrid (GUI)      == /opt/ansys_inc/v261/TurboGrid/bin/cfxtg
Polyflow Classic     == /opt/ansys_inc/v261/polyflow/bin/polyflow
Workbench (GUI)      == /opt/ansys_inc/v261/Framework/bin/Linux64/runwb2
```

NOTE: for "icepak" use the non GUI "icepak_batch"


## GUI ANSYS Applications

To run the GUI version of an application, use the [CCR OnDemand portal](https://ondemand.ccr.buffalo.edu)
Most of the GUI applications require a GPU to proveide GLX graphic support, as
shown in the example below.  

Open a browser window to our [OnDemand portal](https://ondemand.ccr.buffalo.edu)
and start a session with at least one GPU requested.  The first GPU will be
used for VirtualGL graohics acceleration.  
Note: If you request more than one GUI see the [CUDA section below](#graphics-acceleration-and-cuda-with-multiple-gpus

For example:

[UB-HPC & Faculty Cluster Desktop]

Cluster: UB-HPC  
Slurm Account: [Your Slurm account]  
Partition: [general-compute]  
Quality of Service: [general-compute]  
Number of Hours Requested: 4  
Number of Cores: 28  
Amount of Memory: 128000  
Number of GPUs: 1  

[Launch]

Once the Slurm job starts you can press the button that appears
[Launch UB-HPC & Faculty Cluster Desktop]

A new window will open with the GUI displayed.

Open a terminal with:
[Applications][Terminal Emulator]

load VirtualGL with:

```bash
module load gcc virtualgl
export VGL_DISPLAY="$(ls -d /sys/bus/pci/devices/$(nvidia-smi --query-gpu=gpu_bus_id --format=csv,noheader | tail -1 | sed 's/^0000//' | tr '[:upper:]' '[:lower:]')/drm/card* | sed -E 's|^.*(card[0-9]+)$|/dev/dri/\1|')"
```

Note: If you want to verify that the VirtualGL acceleration is working, running
"glxspheres64" unaccelerated should generate 30 to 40 frames per second:

```bash
glxspheres64
```

Whereas running glxspheres64 with "vglrun" should generate over 260 frames per
second:

```bash
vglrun glxspheres64 
```

Set "PROJECTS_DIR" to the path to your projects directory
e.g.

```bash
export PROJECTS_DIR="/projects/academic/[YourGroupName]"
```

This example runs the ANSYS GUI application "icemcfd"

```bash
vglrun apptainer run --nv --no-env=XDG_DATA_DIRS --writable-tmpfs \
 --bind "/util":"/util","/scratch":"/scratch" \
 --bind "${PROJECTS_DIR}":"${PROJECTS_DIR}" \
 --bind "/util/software/licenses/ansyslmd.ini":"/opt/ansys_inc/shared_files/licensing/ansyslmd.ini":ro \
 "/util/software/containers/x86_64/ANSYS-$(arch).sif" \
 icemcfd
```

You can replace "icemcfd" in the example above with any of the following:
ACP.sh, cfdpost, cfx5, cfx5launch, cfx5pre, cfx5solve, cfx5post, cfxtg,
fensapiceGUI, fluent, runSherlock, runwb2

Note that, currently, "icepak" does not run in GUI mode, but the non GUI
"icepak_batch" can be used as per the [Non GUI ANSYS Applications](#non-gui-ansys-applications) section.


## Graphics acceleration and CUDA with multiple GPUs

If you start an OnDemand job with multiple GPUs and use VirtualGL for graphical
acceleration (as our examples above do) you will likely want to use the last
GPU exclusively for VirtualGL acceleration, and the other(s) for CUDA
acceleration.  
Note: Not all ANSYS applications support CUDA acceleration.  

By default the CUDA_VISIBLE_DEVICES environment variable is set to list all the
availabnle GPUs, for example:

```bash
echo ${CUDA_VISIBLE_DEVICES}
```

Sample output for a two GPU job:

> ```
> 0,1
> ```

In our examples, the "export VGL_DISPLAY=[...]" line configures VirtualGL to
use the last GPU, that is GPU numnber 1 in this case.  We will want to use the
other GPU(s) for CUDA, in this case GPU number 0  
For this example:

```bash
export CUDA_VISIBLE_DEVICES=0
```

Note that, unfortunately, not all programs resepct this value, but generally
the programs that don't will have command line option to secify the usable
GPUs.  Also GPU 0 is the default first CUDA device, so this will still work for
single CUDA GPU workloads that ignore CUDA_VISIBLE_DEVICES


## Non GUI ANSYS Applications

Example Non-GUI ANSYS Application "icepak_batch"

```bash
apptainer run --nv --no-env=XDG_DATA_DIRS --writable-tmpfs \
 --bind "/util":"/util","/scratch":"/scratch" \
 --bind "${PROJECTS_DIR}":"${PROJECTS_DIR}" \
 --bind "/util/software/licenses/ansyslmd.ini":"/opt/ansys_inc/shared_files/licensing/ansyslmd.ini":ro \
 "/util/software/containers/x86_64/ANSYS-$(arch).sif" \
 icepak_batch [...]
```

