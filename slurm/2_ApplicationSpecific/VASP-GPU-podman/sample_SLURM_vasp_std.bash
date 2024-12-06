#!/bin/bash -l

# Slurm account
#SBATCH --account="[YourGroupName]"

#SBATCH --clusters=ub-hpc
#SBATCH --partition=general-compute --qos=general-compute
#SBATCH --job-name="VASP_GPU"
#SBATCH --nodes=1
#SBATCH --gpus-per-node=1
#SBATCH --exclusive
#SBATCH --output=%j.out
# 1 hour walltime
#SBATCH --time=01:00:00

# Path to the vasp support scipts (you shouldn't need change this)
bin_dir="/projects/academic/[YourGroupName]/VASP/bin"

##############################################################################
# Configure the VASP data directory here:
data_dir="/projects/academic/[YourGroupName]/[CCRusername]/VASP/data"
##############################################################################

echo "-------------------------------------------------------------------------------"
echo "Job start: $(date "+%F %T")"
echo "-------------------------------------------------------------------------------"

# Add the VASP bin directory to the path
if [ -d "${bin_dir}" ]
then
  PATH=${bin_dir}:${PATH}
else
  echo "binary directory bin_dir=\"${bin_dir}\" does not exist" >&2
  echo "Bailing" >&2
  exit 1
fi

# cd to the data directory
cd "${data_dir}"
if [ "$?" != "0" ]
then
  echo "cd to the data directory \"${data_dir}\" failed - Bailing" >&2
  exit 1
fi

##############################################################################
# run vasp_std, vasp_gam or vasp_ncl in the data directory
vasp_std
#vasp_gam
#vasp_ncl
##############################################################################

echo
echo "-------------------------------------------------------------------------------"
echo "Job end: $(date "+%F %T")"
echo "-------------------------------------------------------------------------------"
