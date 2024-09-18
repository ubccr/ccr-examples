# Example VASP GPU podman build and sample SLURM script

This is how to build VASP for GPU use, with a sample Slurm script

## How to build

To build VASP with nvidia GPU support takes about 45 minutes on a debug node.

Get an interactive job on a debug node
This example allcates a GPU to the job, but all tests are curenlty commented
due to issues with useing nvidia GPUs with "podman build"

```
salloc --partition=debug --qos=debug --nodes=1 --gpus-per-node=1
```

Create a directory for the podman image tarballs e.g.
```
mkdir -p /projects/academic/group/podman/images
```

Create a directory for the podman scripts e.g.
```
mkdir -p /projects/academic/group/VASP/bin
```

Download the files to the Slurm temporary directory

```
cd ${SLURMTMPDIR}
wget https://github.com/tonykew/ccr-examples/raw/main/slurm/2_ApplicationSpecific/VASP-GPU-podman/Containerfile
wget https://github.com/tonykew/ccr-examples/raw/main/slurm/2_ApplicationSpecific/VASP-GPU-podman/build_vasp.bash
wget https://github.com/tonykew/ccr-examples/raw/main/slurm/2_ApplicationSpecific/VASP-GPU-podman/fix_nvhpc_.pc_files.bash
wget https://github.com/tonykew/ccr-examples/raw/main/slurm/2_ApplicationSpecific/VASP-GPU-podman/run_vasp.bash
wget https://github.com/tonykew/ccr-examples/raw/main/slurm/2_ApplicationSpecific/VASP-GPU-podman/run_vasp_shell.bash
wget https://github.com/tonykew/ccr-examples/raw/main/slurm/2_ApplicationSpecific/VASP-GPU-podman/sample_vasp_std.bash
chmod 755 build_vasp.bash
```

Then run the script to build VASP for nvidia GPUs, with the two directories
created earlier

Usage for the build script:

```
./build_vasp.bash 
usage: ./build_vasp.bash image_tarball_directory bin_directory
e.g.
./build_vasp.bash /projects/academic/mygroup/podman_images/ /projects/academic/mygroup/VASP/bin
```

...so, using the two directories created earlier:

```
./build_vasp.bash /projects/academic/group/podman/images /projects/academic/group/VASP/bin
```


## How to use

There is a sample Slurm script in the scripts directory you
provided for the build.
e.g.

```
/projects/academic/group/VASP/bin/sample_vasp_std.bash
```

copy the script, and change the "data_dir=" line to the directory with
your data files in (i.e. "INCAR" etc.)
e.g.

```
data_dir="/projects/academic/group/username/data"
```

Make any other changes you might need to the #SBATCH options
such as cluster, queue and qos names, run time etc.
then submit the job

e.g.
```
sbatch my_script.bash
```

NOTE: the script runs "vasp_std"

```
# run vasp_std in the data directory
vasp_std
```

the "vasp_std" line can bechamged to "vasp_gam" or "vasp_ncl" if you want
to run them rather than "vasp_std"

