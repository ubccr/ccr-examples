#!/bin/bash -l

# Slurm account
#SBATCH --account="ccradmin"

#SBATCH --clusters=ub-hpc
#SBATCH --partition=general-compute --qos=general-compute
#SBATCH --job-name="VASP_GPU"
#SBATCH --nodes=1
#SBATCH --gpus-per-node=1
#SBATCH --exclusive
#SBATCH --output=%j.out
# 30 minutes  walltime
#SBATCH --time=01:00:00

# directory in which to write job output file [job_id].out:
#SBATCH --chdir="/projects/academic/tonykew/tonykew/VASP"

##############################################################################
bin_dir="/vscratch/grp-tonykew/VASP/bin"
data_dir="/projects/academic/tonykew/tonykew/VASP/data"
##############################################################################

echo "-------------------------------------------------------------------------------"
echo "Job info:"
echo "-------------------------------------------------------------------------------"
echo "Job start: $(date "+%F %T")"
echo "Cluster: ${SLURM_CLUSTER_NAME}"
echo "Partition: ${SLURM_JOB_PARTITION}"
echo "QOS: ${SLURM_JOB_QOS}"
if [ "${SLURM_JOB_RESERVATION}" != "" ]
then
  echo "Reservation: ${SLURM_JOB_RESERVATION}"
fi
echo "Account: ${SLURM_JOB_ACCOUNT}"
echo "Job ID: ${SLURM_JOB_ID}"
echo "Nodes in SLURM job: ${SLURM_NODELIST}"
if [ "${SLURM_NTASKS}" != "" ]
then
  echo "Number of Tasks: ${SLURM_NTASKS}"
fi
if [ "${SLURM_NTASKS_PER_NODE}" != "" ] && [ "${SLURM_NTASKS_PER_NODE}" != "${SLURM_NTASKS}" ]
then
  echo "Number of Tasks per Node: ${SLURM_NTASKS_PER_NODE}"
else
  if [ "${SLURM_TASKS_PER_NODE}" != "" ] && [ "${SLURM_TASKS_PER_NODE}" != "${SLURM_NTASKS}" ]
  then
    echo "Number of Tasks per node: ${SLURM_TASKS_PER_NODE}"
  fi
fi
if [ "${SLURM_NTASKS_PER_CORE}" != "" ]
then
  echo "Tasks per Core: ${SLURM_NTASKS_PER_CORE}"
fi
if [ "${SLURM_NTASKS_PER_SOCKET}" != "" ]
then
  echo "Tasks per Socket: ${SLURM_NTASKS_PER_SOCKET}"
fi
if [ "${SLURM_JOB_GPUS}" != "" ]
then
  echo "Slurm job GPUs: ${SLURM_JOB_GPUS}"
fi
if [ "${SLURM_GPUS_PER_NODE}" != "" ]
then
  echo "Requested GPUs per node: ${SLURM_GPUS_PER_NODE}"
fi
if [ "${SLURM_GPUS_ON_NODE}" != "" ] && [ "${SLURM_GPUS_ON_NODE}" != "${SLURM_GPUS_PER_NODE}" ]
then
  echo "Physical GPUs on node: ${SLURM_GPUS_ON_NODE}"
fi
if [ "${SLURM_NTASKS_PER_GPU}" != "" ]
then
  echo "Tasks per GPU: ${SLURM_NTASKS_PER_GPU}"
fi
## Infiniband is not used, so the Slurm topology is irrelevant
#if [ "{SLURM_TOPOLOGY_ADDR}"  != "" ]
#then
#  echo "SLURM topology: ${SLURM_TOPOLOGY_ADDR}"
#fi
echo
echo "-------------------------------------------------------------------------------"
echo

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

if [ ! -f "INCAR" ]
then
  echo "no \"INCAR\" file found - data directory wrong? - Bailing" >&2
  exit 1
fi

# run vasp_std in the data directory
vasp_std

echo
echo "-------------------------------------------------------------------------------"
echo "Job end: $(date "+%F %T")"
echo "-------------------------------------------------------------------------------"

