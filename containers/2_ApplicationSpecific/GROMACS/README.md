# Examples for using nvidia's GROMACS container

GROMACS is an open-source software suite for high-performance molecular dynamics and output analysis.

The interactive and Slurm examples use nvidia's container.
The container supports nvidia GPUs, but is limited to a single node.

The interactive examples follow the [Lysozyme in Water GROMACS tutorial](http://www.mdtutorials.com/gmx/lysozyme/01_pdb2gmx.html)
and the long Slurm example script does the same computations.

The interacrive examples use "xmgrace" - instructions for buildind a grace
container are below.
This is NOT required to use nvidia's GROMACS container.  The sample Slurm
scrtips do NOT need this.


## Building a container with grace/xmgrace

1. Start an interactive job in the debug queue
see the [CCR documantation on Slurm jobs](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs) for more information

e.g.

```bash
salloc --cluster=ub-hpc --partition=debug --qos=debug --mem=0 --exclusive --time=01:00:00
```

2. Change to your build directory
e.g.

```bash
cd /projects/academic/[YourGroupName]/GROMACS
```

Set the target directory for all your container images
e.g.

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
#curl -L -o "grace.def" "https://raw.githubusercontent.com/tonykew/ccr-examples/refs/heads/GROMACS/containers/2_ApplicationSpecific/GROMACS/grace.def"
curl -L -o "grace.def" "https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/GROMACS/grace.def"
```

Build the grace container image

```bash
apptainer build "${CONTAINER_DIR}/grace-$(arch).sif" "grace.def"
```

Verify that the build was successful

```bash
apptainer run \
 --bind /util:/util,/scratch:/scratch \
 --bind /vscratch/grp-[YourGroupName]:/vscratch/grp-[YourGroupName] \
 --bind /projects/academic/[YourGroupName]:/projects/academic/[YourGroupName] \
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


## Example Scripts

Provided in this repository are a couple of example GROMACS Slurm jobs.

### Short Slurm example

x86_64  
[slurm_nvidia_GROMACS_short_example.bash](./slurm_nvidia_GROMACS_short_example.bash)

ARM64  
[slurm_ARM64_nvidia_GROMACS_short_example.bash](./slurm_ARM64_nvidia_GROMACS_short_example.bash)


### Long Slurm example

This example does all the computations from the [Lysozyme in Water GROMACS tutorial](http://www.mdtutorials.com/gmx/lysozyme/01_pdb2gmx.html)

x86_64  
[slurm_nvidia_GROMACS_long_example.bash](./slurm_nvidia_GROMACS_long_example.bash)

ARM64  
[slurm_ARM64_nvidia_GROMACS_long_example.bash](./slurm_ARM64_nvidia_GROMACS_long_example.bash)

