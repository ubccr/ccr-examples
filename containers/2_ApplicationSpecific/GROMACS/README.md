# Examples for using nvidia's GROMACS container

GROMACS is an open-source software suite for high-performance molecular dynamics and output analysis.

The interactive and Slurm examples use nvidia's container.
The container supports nvidia GPUs, but is limited to a single node.

## Download nvidia's GROMACS container

nvidia gromacs containers are available from [nvidia's NGC repository](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/gromacs)

To Download the container, with apptainer, we start an interactive Slurm job.
e.g.

```
salloc --cluster=ub-hpc --partition=debug --qos=debug --mem=0 --exclusive --time=01:00:00
```

sample outout:

> ```
> salloc: Pending job allocation [JobID]
> salloc: job [JobID] queued and waiting for resources
> salloc: job [JobID] has been allocated resources
> salloc: Granted job allocation 19781052
> salloc: Nodes [NodeID] are ready for job
> CCRusername@[NodeID]:~$ 
> ```

Set the directory for container images e.g.

```bash
CONTAINER_DIR="/projects/academic/[CCRgroupname]/Containers"
```

The most recent version of GROMANS from NGC, at the time of writing, is
"v2026.2" so we set an environment variable for that version tag:

```bash
GROMACS_TAG="v2026.2"
```

The following will download the continer into the ${CONTAINER_DIR} directory

```bash
container_image="GROMACS-${GROMACS_TAG}-CUDA-$(arch).sif"
gromacs_url="docker://nvcr.io/nvidia/gromacs:${GROMACS_TAG}"
test ! -d "${CONTAINER_DIR}" && mkdir "${CONTAINER_DIR}"
export APPTAINER_CACHEDIR="${APPTAINER_CACHEDIR:-${SLURMTMPDIR}/apptainer}"
mkdir -p "${APPTAINER_CACHEDIR}"
apptainer pull "${CONTAINER_DIR}/${container_image}" "${gromacs_url}"
```

Quick test for the container

Set "PROJECTS_DIR" to the path to your projects directory
e.g.

```bash
export PROJECTS_DIR="/projects/academic/[YourGroupName]"
```

Check GROMACS version

```bash
apptainer run \
 --bind "/util":"/util","/scratch":"/scratch" \
 --bind "${PROJECTS_DIR}":"${PROJECTS_DIR}" \
 --nv \
 "${CONTAINER_DIR}/${container_image}" \
 gmx -version
```

Sample abridged output:

> ```
>                        :-) GROMACS - gmx, 2026.2-dev (-:
> 
> Executable:   /usr/local/gromacs/avx2_256/bin/gmx
> Data prefix:  /usr/local/gromacs/avx2_256
> Working dir:  /projects/academin/[YourGroupName]/GROMACS
> [...]
> CUDA targets:        75;80;86;90;75-virtual;80-virtual;86-virtual;90-virtual
> CUDA driver:         0.0
> CUDA runtime:        13.0
> NVSHMEM:             disabled
> 
> ```


GROMACS can generate .xvg files.
If you with to plot these files, you can build a grace container, which includes
"xmgrace" which you can use in CCR's [OnDemand portal](https://ondemand.ccr.buffalo.edu)

This is NOT required to use nvidia's GROMACS container.  The sample Slurm
scrtips do NOT need this.


## Building a container with grace/xmgrace

Within the curent Slurm job

Change to your build directory
e.g.

```bash
cd /projects/academic/[YourGroupName]/GROMACS
```

Set the directory for container images e.g.

```bash
CONTAINER_DIR="/projects/academic/[CCRgroupname]/Containers"
```

Make sure APPTAINER_TMPDIR and APPTAINER_CACHEDIR environment
variables are set to sensible values

```bash
export APPTAINER_TMPDIR="${APPTAINER_TMPDIR:-${SLURMTMPDIR}/apptainer/tmp}"
mkdir -p "${APPTAINER_TMPDIR}"
export APPTAINER_CACHEDIR="${APPTAINER_CACHEDIR:-${SLURMTMPDIR}/apptainer}"
mkdir -p "${APPTAINER_CACHEDIR}"
```

Download the .def file

```bash
curl -L -o "grace.def" "https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/GROMACS/grace.def"
```

Build the grace container image

```bash
apptainer build "${CONTAINER_DIR}/grace-$(arch).sif" "grace.def"
```

Verify that the build was successful

```bash
apptainer run \
 --bind "/util":"/util","/scratch":"/scratch" \
 --bind "${PROJECTS_DIR}":"${PROJECTS_DIR}" \
 --nv \
 "${CONTAINER_DIR}/grace-$(arch).sif" \
 grace -version
```

Sample output:

> 
> Grace-5.1.25
> 
> GUI toolkit: @(#)Motif Version 2.3.8
> Xbae version: 46004
> T1lib: 1.3.1p3-grace
> FFT: FFTW
> NetCDF support: on
> libpng: 1.6.43
> libjpeg: 80
> Built: Mon Apr  8 10:40:41 2024 on Linux #191-Ubuntu SMP Fri Feb 2 13:55:07 UTC 2024 5.4.0-173-generic x86_64
> Compiler flags: gcc -g -O2 -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer -ffile-prefix-map=/build/grace-mFwzxU/grace-5.1.25=. -fstack-protector-strong -fstack-clash-protection -Wformat -Werror=format-security -fcf-protection -fdebug-prefix-map=/build/grace-mFwzxU/grace-5.1.25=/usr/src/grace-1:5.1.25-14 -I.. -I. -I../T1lib/t1lib  -Wdate-time -D_FORTIFY_SOURCE=3  -Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -lXmHTML -lXbae -lXm -lXpm -lXmu -lXt -lXext -lX11  -lSM -lICE  ../cephes/libcephes.a -lnetcdf -lfftw3 ../T1lib/libt1.a  -ljpeg -lpng -lz -ltirpc -lm  
> 
> Registered devices:
> Dummy PostScript EPS MIF SVG PNM JPEG PNG Metafile 
> 
> (C) Copyright 1991-1995 Paul J Turner
> (C) Copyright 1996-2015 Grace Development Team
> All Rights Reserved


## Example Slurm Scripts

Provided in this repository are a couple of example GROMACS Slurm jobs.

x86_64  
[slurm_nvidia_GROMACS_example.bash](./slurm_nvidia_GROMACS_example.bash)

ARM64  
[slurm_ARM64_nvidia_GROMACS_example.bash](./slurm_ARM64_nvidia_GROMACS_example.bash)


## Other resources

[GROMACS web pages](https://www.gromacs.org)

[GROMACS Documentation](https://manual.gromacs.org)

[Lysozyme in Water GROMACS tutorial](http://www.mdtutorials.com/gmx/lysozyme/01_pdb2gmx.html)

