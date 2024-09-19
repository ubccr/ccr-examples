#!/bin/bash

if [ "${1}" = "" ] || [ ! -d "${1}" ] || [ "${2}" = "" ] || [ ! -d "${2}" ]
then
  echo "usage: ${0} image_tarball_directory bin_directory" >&2
  echo "e.g." >&2
  echo "${0} /projects/academic/mygroup/podman_images/ /projects/academic/mygroup/VASP/bin" >&2
  exit 1
fi

tarball_dir="${1}"
bin_dir="${2}"

if [ "${tarball_dir}" = "" ] || [ ! -d "${tarball_dir}" ]
then
  echo "image_tarball_directory \"${tarball_dir}\" doesn't exist - bailing" >&2
  exit 1
fi

if [ "${bin_dir}" = "" ] || [ ! -d "${bin_dir}" ]
then
  echo "bin_directory \"${bin_dir}\" doesn't exist - bailing" >&2
  exit 1
fi

if [ ! -f "Containerfile" ]
then
  echo "Containerfile missing? - bailing" >&2
  exit 1
fi

vasp_version="$(grep -E '^[[:space:]]*ARG[[:space:]]*vasp_version' Containerfile | awk -F= '{print $2}')"
if [ "${vasp_version}" = "" ]
then
  echo "Failed to get VASP version from the Containerfile - bailing" >&2
  exit 1
fi

if [ ! -f "vasp.${vasp_version}.tgz" ]
then
  echo "VASP source tarball \"vasp.${vasp_version}.tgz\" missing - bailing" >&2
  exit 1
fi

echo "Cleaning up any old build cruft"
podman image prune --force > /dev/null 2>&1 ||:
podman image rm localhost/vasp-${vasp_version}-gpu-single-node > /dev/null 2>&1 ||:

echo "Starting Build..."
podman build \
 --network=host \
 --ipc=host \
 --volume ${HOME}/.ssh:/root/.ssh:z,ro,rprivate \
 --volume ${HOME}/.ssh:/home/ubuntu/.ssh:z,ro,rprivate \
 --volume /etc/ssh/ssh_known_hosts:/etc/ssh/ssh_known_hosts:z,ro,rprivate \
 $(/projects/ccrstaff/general/podman/get_nvidia_gpu_instance_number | while read gpu_num
  do echo -n "--device /dev/nvidia${gpu_num}:/dev/nvidia${gpu_num}:rw "
  done) \
 --env='SLURMTMPDIR' \
 --env='SLURM_JOB_USER' \
 --security-opt=label=disable \
 --tag="vasp-${vasp_version}-gpu-single-node" .
if [ "$?" != "0" ]
then
  echo "Build failed - bailing" >&2
  exit 1
fi

echo "Saving container tarball"
podman save \
 --format=oci-archive \
 --output="${tarball_dir}/podman-image-vasp-${vasp_version}-gpu-single-node.tar" \
 "localhost/vasp-${vasp_version}-gpu-single-node"

echo "copying the run scripts"
if [ -f "run_vasp.bash" ]
then
  for prog_name in vasp_gam vasp_ncl vasp_std
  do
    sed -E -e "s|^vasp_version=.*|vasp_version=\"${vasp_version}\"|" \
     -e "s|^image_tarball_dir=.*|image_tarball_dir=\"${tarball_dir}\"|" \
     -e "s|VASP_PROG_NAME|${prog_name}|" \
     "run_vasp.bash" > "${bin_dir}/${prog_name}-${vasp_version}.bash"
    chmod 755 "${bin_dir}/${prog_name}-${vasp_version}.bash"
    ln -sf "${bin_dir}/${prog_name}-${vasp_version}.bash" "${bin_dir}/${prog_name}"
  done
else
  echo "script \"run_vasp.bash\" missing?" >&2
fi
if [ -f "run_vasp_shell.bash" ]
then
  sed -E -e "s|^vasp_version=.*|vasp_version=\"${vasp_version}\"|" \
   -e "s|^image_tarball_dir=.*|image_tarball_dir=\"${tarball_dir}\"|" \
   "run_vasp_shell.bash" > "${bin_dir}/run_vasp_shell-${vasp_version}.bash"
  chmod 755 "${bin_dir}/run_vasp_shell-${vasp_version}.bash"
  ln -sf "${bin_dir}/run_vasp_shell-${vasp_version}.bash" "${bin_dir}/run_vasp_shell"
else
  echo "script \"run_vasp_shell.bash\" missing?" >&2
fi
# Provide a sample Slurm script
if [ -f sample_vasp_std.bash ]
then
  grp_group="$(groups | sed 's/ /\n/g' | grep ^grp- | head -1 | sed 's/^grp-//')"
  if [ "${grp_group}" != "" ]
  then
    if [ -d "/projects/academic/${grp_group}" ] || [ -d "/projects/rpci/${grp_group}" ]
    then
      if [ -d "/projects/academic/${grp_group}" ]
      then
        base_dir="/projects/academic/${grp_group}/$(id -un)/VASP"
      else
        base_dir="/projects/rpci/${grp_group}/$(id -un)/VASP"
      fi
      default_acct="$(sacctmgr -rnp show User "$(id -un)" | awk -F'|' '{print $2}')"
      sed -E -i -e "/#SBATCH[[:space:]]+--account=/s|\".*\"|\"${default_acct}\"|" \
       -e "/#SBATCH[[:space:]]+--chdir=/s|\".*\"|\"${base_dir}\"|" \
       -e "s|^bin_dir=.*|bin_dir=\"${bin_dir}\"|" \
       -e "s|^data_dir=.*|data_dir=\"${base_dir}/data\"|" \
       "sample_vasp_std.bash"
    fi
  fi
  cp "sample_vasp_std.bash" "${bin_dir}/sample_vasp_std.bash"
else
  echo "sample script \"sample_vasp_std.bash\" missing?" >&2
fi
echo

echo "Run \"vasp_std\" in a container instance with:"
echo "  ${bin_dir}/vasp_std"
echo 
echo "Run \"vasp_gam\" in a container instance with:"
echo "  ${bin_dir}/vasp_gam"
echo 
echo "Run \"vasp_ncl\" in a container instance with:"
echo "  ${bin_dir}/vasp_ncl"
echo
echo "Run a specific version of any of the above:"
echo "e.g."
echo "   ${bin_dir}/vasp_std-${vasp_version}.bash"
echo
echo
echo "Run a shell in the Vasp container with:"
echo "  ${bin_dir}/run_vasp_shell"
echo
echo
echo "Example Slurm script:"
echo "  ${bin_dir}/sample_vasp_std.bash"
echo
