#!/bin/bash
#
# Fix broken prefix paths in all the .pc files
#
if [ "${NVHPC}" = "" ]
then
  echo "NVHPC environment variable unset??? - bailing" >&2
  exit 1
fi
if [ "${NVHPC_ROOT}" = "" ]
then
  echo "NVHPC_ROOT environment variable unset??? - bailing" >&2
  exit 1
fi
#
find "${NVHPC}" -name \*\.pc -exec grep -E -l "^prefix[[:space:]]*=[[:space:]]*\\\${hpcx_home}" {} \; | while read file
do 
  prefix_dir_end="$(cat "${file}" | grep -E "^prefix[[:space:]]*=" | sed -E "s|^prefix[[:space:]]*=[[:space:]]*\\\$\{hpcx_home\}||")"
  #echo "prefix_dir_end=\"${prefix_dir_end}\""
  prefix="$(echo "${file}" | sed -E "s|^(.*)${prefix_dir_end}/.*$|\1|")"
  #echo "prefix=\"${prefix}\""
  sed -E -i "/^prefix[[:space:]]*=/s|\\\$\{hpcx_home\}|${prefix}|" "${file}"
done
find "${NVHPC}" -name \*\.pc -exec grep -E -l "^prefix[[:space:]]*=[[:space:]]*/proj/" {} \; | while read file
do
  if cat "${file}" | grep -E -q "^prefix[[:space:]]*=.*/openmpi/"
  then
    # OpenMPI version 3.x
    prefix="$(echo "${file}" | sed -E "s|/pkgconfig/[^/]*\.pc$||")"
    #echo "prefix=\"${prefix}\""
    #sed -E "/^prefix[[:space:]]*=/s|=.*$|=${prefix}|" "${file}" | grep ^prefix
    sed -E -i "/^prefix[[:space:]]*=/s|=.*$|=${prefix}|" "${file}"
  else
    #sed -E "/^prefix[[:space:]]*=/s|=.*/comm_libs/|=${NVHPC_ROOT}/comm_libs/|" "${file}" | grep ^prefix
    sed -E -i "/^prefix[[:space:]]*=/s|=.*/comm_libs/|=${NVHPC_ROOT}/comm_libs/|" "${file}"
    # [...]comm_libs/[rest from filename]
  fi
done
find "${NVHPC}" -name \*\.pc -exec grep -E -l "^prefix[[:space:]]*=[[:space:]]*/usr/" {} \; | while read file
do
  prefix="$(echo "${file}" | sed -E "s|/lib/pkgconfig/[^/]*\.pc$||")"
  #echo "prefix=\"${prefix}\""
  #sed -E "/^prefix[[:space:]]*=/s|=.*$|=${prefix}|" "${file}" | grep ^prefix
  sed -E -i "/^prefix[[:space:]]*=/s|=.*$|=${prefix}|" "${file}"
done
# In NVHPC version 24.7 OpenMPI version 4.1.5 was built against Cuda
# version 12.4 rather than 12.5 so we add a link as a workround
# (rather than hack the prefix paths)
cd "${NVHPC_ROOT}/comm_libs"
test -e 12.4 || ln -s 12.5 12.4

