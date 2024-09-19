#!/bin/bash

##############################################################################
vasp_version=""
image_tarball_dir=""
##############################################################################

if ! podman image exists "localhost/vasp-${vasp_version}-gpu-single-node"
then
  # load the image on this node
  echo "Loading the VASP image from the tarball - this takes some time..."
  podman load --input "${image_tarball_dir}/podman-image-vasp-${vasp_version}-gpu-single-node.tar"
fi

# Run one MPI task per GPU (with one task per GPU)
if [ "${SLURM_JOB_ID}" = "" ]
then
  # get the number of GPUs by counting the available /dev/nvidia[0-9]+ devices
  num_gpus="$(/projects/ccrstaff/general/podman/get_nvidia_gpu_instance_number | wc -l)"
else
  # get the number of GPUs from the Slurm job allocation
  num_gpus="$(scontrol show job ${SLURM_JOB_ID} | grep -E AllocTRES= | sed -e 's|.*gres/gpu=||' -e 's|,.*$||')"
fi

# If running outdide of Slurm, try to set some reasonable default values
if [ "${SLURMTMPDIR}" = "" ]
then
  if [ -d "/scratch" ]
  then
    SLURMTMPDIR="/scratch"
  else
    SLURMTMPDIR="/tmp"
  fi
fi
if [ "${SLURM_JOB_USER}" = "" ]
then
  if [ "${PARENT_USER}" != "" ]
  then
    SLURM_JOB_USER="${PARENT_USER}"
  else
    SLURM_JOB_USER="$(id -un)"
  fi
fi  

echo "Starting the podman instance of vasp-${vasp_version}-gpu-single-node"
podman run --rm -it \
 $(/projects/ccrstaff/general/podman/podman_cgroup_nvidia_cards) \
 --security-opt=label=disable \
 --annotation run.oci.keep_original_groups=1 \
 --storage-opt=overlay.ignore_chown_errors=true \
 --network=host \
 --ipc=host \
 --mount type=bind,source=${HOME},target=/home/ubuntu/,bind-propagation=slave,z \
 $([ "${HOME}" != "/home/ubuntu" ] && echo "--mount type=bind,source=${HOME},target=${HOME},bind-propagation=slave,z") \
 --mount type=bind,source=/etc/ssh/ssh_known_hosts,target=/etc/ssh/ssh_known_hosts,readonly,bind-propagation=slave,z \
 --mount type=bind,source=/scratch,target=/scratch,bind-propagation=slave,z \
 --mount type=bind,source=/vscratch,target=/vscratch,bind-propagation=slave,z \
 --mount type=bind,source=/projects,target=/projects,bind-propagation=slave,z \
 --mount type=bind,source=/util,target=/util,bind-propagation=slave,z \
 --env='SLURMTMPDIR' \
 --env='SLURM_JOB_USER' \
 --user 1000 \
 --uidmap "1000:0:1" \
 --gidmap "1000:0:1" \
 "localhost/vasp-${vasp_version}-gpu-single-node"

