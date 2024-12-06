# Example VASP GPU podman build and sample SLURM script

This is how to build VASP for GPU use, with a sample Slurm script

## How to build

To build VASP with nvidia GPU support takes about 45 minutes on a debug node.

Start an interactive job on a debug node.
This example allcates a GPU to the job, but all tests are curenlty commented
due to issues with using nvidia GPUs with "podman build"

```
salloc --partition=debug --qos=debug --nodes=1 --gpus-per-node=1 --cpus-per-task=1 --tasks-per-node=32 --exclusive
```

Create a directory for the podman OCI images e.g.
```
mkdir -p /projects/academic/ccrgroup/oci_archive_dir
```

Create a directory for the podman scripts e.g.
```
mkdir -p /projects/academic/ccrgroup/VASP/bin
```

Download the files to the Slurm temporary directory

```
cd ${SLURMTMPDIR}
wget https://github.com/tonykew/ccr-examples/raw/main/slurm/2_ApplicationSpecific/VASP-GPU-podman/Containerfile
wget https://github.com/tonykew/ccr-examples/raw/main/slurm/2_ApplicationSpecific/VASP-GPU-podman/build_vasp.bash
wget https://github.com/tonykew/ccr-examples/raw/main/slurm/2_ApplicationSpecific/VASP-GPU-podman/fix_nvhpc_.pc_files.bash
wget https://github.com/tonykew/ccr-examples/raw/main/slurm/2_ApplicationSpecific/VASP-GPU-podman/run_vasp.bash
wget https://github.com/tonykew/ccr-examples/raw/main/slurm/2_ApplicationSpecific/VASP-GPU-podman/run_vasp_shell.bash
wget https://github.com/tonykew/ccr-examples/raw/main/slurm/2_ApplicationSpecific/VASP-GPU-podman/sample_SLURM_vasp_std.bash
chmod 755 build_vasp.bash fix_nvhpc_.pc_files.bash
```

Copy the vasp tarball to the Slurm temporary directory
e.g.

```
cp /some/path/vasp.6.4.3.tgz ${SLURMTMPDIR}
```

Then run the script to build VASP for nvidia GPUs, with the two directories
created earlier

Usage for the build script:

```
./build_vasp.bash 
usage: ./build_vasp.bash oci_image_archive_directory bin_directory
e.g.
./build_vasp.bash /projects/academic/ccrgroup/oci_archive_dir/ /projects/academic/ccrgroup/VASP/bin
```

...so, using the two directories created earlier:

```
./build_vasp.bash /projects/academic/ccrgroup/oci_archive_dir /projects/academic/ccrgroup/VASP/bin
```


## How to use

There is a sample SLURM script in the scripts directory you
provided for the build.
e.g.

```
/projects/academic/ccrgroup/VASP/bin/sample_SLURM_vasp_std.bash
```

copy the script, and change the "data_dir=" line to the directory with
your data files in (i.e. "INCAR" etc.)
e.g.

```
##############################################################################
data_dir="/projects/academic/ccrgroup/username/data"
##############################################################################
```

The sample SLURMscript runs "vasp_std"

```
##############################################################################
# run vasp_std, vasp_gam or vasp_ncl in the data directory
vasp_std
#vasp_gam
#vasp_ncl
##############################################################################
```

comment the "vasp_std" line and uncomment the "vasp_gam" or "vasp_ncl" line
as needed

Make any other changes you might need to the #SBATCH options
such as cluster, queue and qos names, run time etc.
then submit the job

e.g.
```
sbatch my_script.bash
```
