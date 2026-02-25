#!/bin/bash -l

## This file is intended to serve as a template to be downloaded and modified for your use case.
## For more information, refer to the following resources whenever referenced in the script-
## README- https://github.com/ubccr/ccr-examples/tree/main/slurm/README.md
##  DOCUMENTATION- https://docs.ccr.buffalo.edu/en/latest/hpc/jobs

## Select a cluster, partition, qos and account that is appropriate for your use case
## Available options and more details are provided in CCR's documentation:
##   https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#slurm-directives-partitions-qos
#SBATCH --cluster=[cluster]
#SBATCH --partition=[partition]
#SBATCH --qos=[qos]
#SBATCH --account=[SlurmAccountName]

## Job runtime limit, the job will be canceled once this limit is reached. Format- dd-hh:mm:ss
#SBATCH --time=01:00:00

## Refer to DOCUMENTATION for details on the following Slurm directives
## This example uses a node with (at least) one GPU
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --gpus-per-node=1
##SBATCH --cpus-per-task=28

## Using conainer shared namespace when running apptainer [...] gmx mdrun [...]
## so ask for the whole node (security measure)
#SBATCH --exclusive

## Use all the memory on the node.
#SBATCH --mem=0


## CONTAINER_DIR == directory with the Quantum ESPRESSO container image
CONTAINER_DIR="/projects/academic/[CCRgroupname]/Containers"

## For the latest version of the nvidia GROMACS container see:
##   https://catalog.ngc.nvidia.com/orgs/hpc/containers/gromacs
GROMACS_TAG="2023.2"

## Set the number of OpenMPI threads per task
## Use ${SLURM_CPUS_PER_TASK} if "#SBATCH --cpus-per-task=[...]" is used above,
## otherwise, divide the number of CPU cores by the number of GPUs allocated to the job
export OMP_NUM_THREADS="${SLURM_CPUS_PER_TASK:-$((${SLURM_JOB_CPUS_PER_NODE} / ${SLURM_GPUS_ON_NODE}))}"

## Change the nvidia cache dir from ~/.nv/ComputeCache
export CUDA_CACHE_PATH="${SLURMTMPDIR:-/var/tmp}/nv_$(id -nu)"
mkdir -p "${CUDA_CACHE_PATH}"

## Enable the direct GPU communication capabilities of MPI
export GMX_ENABLE_DIRECT_GPU_COMM=1

container_image="gromacs-${GROMACS_TAG}-$(arch).sif"

# make sure APPTAINER_TMPDIR is set to a sensible default
export APPTAINER_TMPDIR="${APPTAINER_TMPDIR:-${SLURMTMPDIR}/apptainer/tmp}"
mkdir -p "${APPTAINER_TMPDIR}"

## Fetch the nvidia GROMACS container, if necessary
gromacs_url="docker://nvcr.io/hpc/gromacs:${GROMACS_TAG}"
test ! -d "${CONTAINER_DIR}" && mkdir "${CONTAINER_DIR}"
pushd "${CONTAINER_DIR}" > /dev/null
if ! test -f "${container_image}"
then
  export APPTAINER_CACHEDIR="${APPTAINER_CACHEDIR:-${SLURMTMPDIR}/apptainer}"
  mkdir -p "${APPTAINER_CACHEDIR}"
  echo "Fetching the nvidia GROMACS container..."
  apptainer --silent pull "${container_image}" "${gromacs_url}"
  if test ! -f "${container_image}"
  then
    echo "apptainer pull failed - bailing!" >&2
    exit 1
  fi
  echo "container downloaded sucessfully:"
  ls -lh "${container_image}"
  echo
fi
popd > /dev/null

## This example uses the hen egg white lysozyme - PDB code 1AKI
## This PDB text file was downloaded from http://www.rcsb.org/pdb/home/home.do
if ! test -f "./inputs/1AKI.pdb"
then
  mkdir -p "./inputs"
  curl -L -sS -o "./inputs/1AKI.pdb" "https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/GROMACS/data_files/1AKI.pdb"
fi

## Delete the crystal water molecules (residue "HOH" in the PDB file)
grep -v "HOH" "./inputs/1AKI.pdb" > "./inputs/1AKI_clean.pdb"

## Verify thtat there a no entries listed under the comment MISSING
## Incomplete internal sequences or any amino acid residues that have missing
## atoms will cause pdb2gmx to fail
grep "MISSING" "./inputs/1AKI_clean.pdb"
if [ "$?" = "0" ]
then
  echo "Warning!" >&2
  echo "The \"./inputs/1AKI.pdb\" file has MISSING entries" >&2
  echo "Incomplete internal sequences or any amino acid residues that have missing" >&2
  echo "atoms will cause pdb2gmx to fail"
  echo >&2
fi

## This example uses the CHARMM36 force field, downloaded from the
## MacKerell lab website http://mackerell.umaryland.edu
if ! test -f "charmm36-jul2022.ff.tgz"
then
  curl -L -sS -o "charmm36-jul2022.ff.tgz" "https://mackerell.umaryland.edu/download.php?filename=CHARMM_ff_params_files/charmm36-jul2022.ff.tgz"
fi
tar xzf "charmm36-jul2022.ff.tgz"


## Use "gmx pdb2gmx" to generate three files:
##   The topology for the molecule.
##   A position restraint file.
##   A post-processed structure file.
## "gmx pdb2gmx" is run as a single task:
apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --nv \
 "${CONTAINER_DIR}/${container_image}" \
 gmx pdb2gmx -f ./inputs/1AKI_clean.pdb -o 1AKI_processed.gro -water tip3p -ff charmm36-jul2022

## This generates three files:
echo "output files:"
ls -l topol.top posre.itp 1AKI_processed.gro
echo


## Define the box dimensions using the editconf module:
apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --nv \
 "${CONTAINER_DIR}/${container_image}" \
 gmx editconf -f 1AKI_processed.gro -o 1AKI_newbox.gro -c -d 1.2 -bt cubic

## This generates one file
echo "output file:"
ls -l 1AKI_newbox.gro
echo


## Fill the box with solvent (water) using the solvate module
apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --nv \
 "${CONTAINER_DIR}/${container_image}" \
 gmx solvate -cp 1AKI_newbox.gro -cs spc216.gro -o 1AKI_solv.gro -p topol.top

## This generates one file, "1AKI_solv.gro" and updates topol.top
echo "output file:"
ls -l 1AKI_solv.gro
echo "changes to \"topol.top\":"
diff topol.top \#topol.top.1#
echo


## Download the example molecular dynamics parameter (.mdp) file from
## http://www.mdtutorials.com/ to the "inputs" direcory
if ! test -f "./inputs/ions.mdp"
then
  curl -L -sS -o "./inputs/ions.mdp" "http://www.mdtutorials.com/gmx/lysozyme/Files/ions.mdp"
fi

## Generate an atomic-level input file (.tpr)
apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --nv \
 "${CONTAINER_DIR}/${container_image}" \
 gmx grompp -f inputs/ions.mdp -c 1AKI_solv.gro -p topol.top -o ions.tpr

## This generates two files:
echo "output files:"
ls -l ions.tpr mdout.mdp
echo


## Replace water molecules with the ions
echo "SOL" | apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --nv \
 "${CONTAINER_DIR}/${container_image}" \
 gmx genion -s ions.tpr -o 1AKI_solv_ions.gro -p topol.top -pname NA -nname CL -neutral

## This generates one file, "1AKI_solv_ions.gro" and updates topol.top
echo "output file:"
ls -l 1AKI_solv_ions.gro
echo "changes to \"topol.top\":"
diff topol.top '#topol.top.2#'
echo


## Download the input parameter file "minim.mdp" to the inputs directory
if ! test -f "./inputs/minim.mdp"
then
  curl -L -sS -o "./inputs/minim.mdp" "http://www.mdtutorials.com/gmx/lysozyme/Files/minim.mdp"
fi

## Run the energy minimization
apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --nv \
 "${CONTAINER_DIR}/${container_image}" \
 gmx grompp -f inputs/minim.mdp -c 1AKI_solv_ions.gro -p topol.top -o em.tpr

## This generates one file, "em.tpr" and updates mdout.mdp
echo "output file:"
ls -l em.tpr mdout.mdp 
echo


## Run the energy minimization
apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --sharens \
 --nv \
 "${CONTAINER_DIR}/${container_image}" \
 gmx mdrun -ntmpi ${SLURM_GPUS_ON_NODE} -v -deffnm em

## This generates four files:
echo "output files:"
ls -l em.log em.trr em.edr em.gro
echo


## Analyze the .edr file "em.edr"
echo "Potential" |apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --nv \
 "${CONTAINER_DIR}/${container_image}" \
 gmx energy -f em.edr -o potential.xvg

## This generates one file
echo "output file:"
ls -l potential.xvg
echo


## Equilibrate the solvent and ions around the protein:
## Phase 1 is conducted under an NVT ensemble (constant Number of particles,
## Volume, and Temperature.)

## Download the .mdp file for this example to the inputs directory
if ! test -f "./inputs/nvt.mdp"
then
  curl -L -sS -o "./inputs/nvt.mdp" "http://www.mdtutorials.com/gmx/lysozyme/Files/nvt.mdp"
fi

apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --nv \
 "${CONTAINER_DIR}/${container_image}" \
 gmx grompp -f inputs/nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr

## This generates one file, "nvt.tpr" and updates mdout.mdp
echo "output file:"
ls -l nvt.tpr mdout.mdp
echo

## Run the NVT simulation
apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --sharens \
 --nv \
 "${CONTAINER_DIR}/${container_image}" \
 gmx mdrun -ntmpi ${SLURM_GPUS_ON_NODE} -deffnm nvt

## This generates five files:
echo "output files:"
ls -l nvt.cpt nvt.gro nvt.edr nvt.trr nvt.log
echo


## Analyze the temperature progression
echo "Temperature" | apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --nv \
 "${CONTAINER_DIR}/${container_image}" \
 gmx energy -f nvt.edr -o temperature.xvg

## This generates one file
echo "output file:"
ls -l temperature.xvg
echo


## Equilibrate the solvent and ions around the protein:
## Phase 2 - Equilibration of pressure is conducted under an NPT ensemble where
## the Number of particles, Pressure, and Temperature are all constant

# Download the 500-ps NPT equilibration .mdp file "npt.mdp" to the inputs directory
if ! test -f "./inputs/npt.mdp"
then
  curl -L -sS -o "./inputs/npt.mdp" "http://www.mdtutorials.com/gmx/lysozyme/Files/npt.mdp"
fi

apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --nv \
 "${CONTAINER_DIR}/${container_image}" \
 gmx grompp -f inputs/npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr

## This generates one file, "npt.tpr" and updates mdout.mdp
echo "output files:"
ls -l npt.tpr mdout.mdp
echo


## Run the NPT simulation
apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --sharens \
 --nv \
 "${CONTAINER_DIR}/${container_image}" \
 gmx mdrun -ntmpi ${SLURM_GPUS_ON_NODE} -deffnm npt


## Analyze the pressure progression
echo "Pressure" | apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --nv \
 "${CONTAINER_DIR}/${container_image}" \
 gmx energy -f npt.edr -o pressure.xvg

## This generates one file
echo "output file:"
ls -l pressure.xvg
echo


## Examine the density using energy
echo "Density" | apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --nv \
 "${CONTAINER_DIR}/${container_image}" \
 gmx energy -f npt.edr -o density.xvg

## This generates one file
echo "output file:"
ls -l density.xvg
echo


## Now the system is equilibrated, release the position restraints and run
## production MD for data collection

## Download the 10-ns MD simulation file (md.mdp) file from
## http://www.mdtutorials.com/ to the "inputs" direcory
if ! test -f "./inputs/md.mdp"
then
  curl -L -sS -o "./inputs/md.mdp" "http://www.mdtutorials.com/gmx/lysozyme/Files/md.mdp"
fi

## Generate the .tpr file for this simulation:
apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --nv \
 "${CONTAINER_DIR}/${container_image}" \
 gmx grompp -f inputs/md.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_10.tpr

## This generates one file, "md_0_10.tpr" and updates mdout.mdp
echo "output filse:"
ls -l md_0_10.tpr mdout.mdp
echo


## Run the 10-ns MD simulation:
apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --sharens \
 --nv \
 "${CONTAINER_DIR}/${container_image}" \
 gmx mdrun -ntmpi ${SLURM_GPUS_ON_NODE} -deffnm md_0_10

## This generates six files:
echo "output files:"
ls -l md_0_10.log md_0_10.xtc md_0_10.edr md_0_10.gro md_0_10_prev.cpt md_0_10.cpt
echo


## Correcting for Periodicity Effects
## Reimage the trajectory
echo -e "Protein\nSystem" | apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --nv \
 "${CONTAINER_DIR}/${container_image}" \
 gmx trjconv -s md_0_10.tpr -f md_0_10.xtc -o md_0_10_noPBC.xtc -pbc mol -center

## This generates one file
echo "output file:"
ls -l md_0_10_noPBC.xtc
echo


# Root-Mean-Square Deviation
echo -e "Backbone\nBackbone" | apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --nv \
 "${CONTAINER_DIR}/${container_image}" \
 gmx rms -s md_0_10.tpr -f md_0_10_noPBC.xtc -o rmsd.xvg -tu ns

## This generates one file
echo "output file:"
ls -l rmsd.xvg
echo


## Calculate RMSD relative to the crystal structure
echo -e "Backbone\nBackbone" | apptainer run \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --nv \
 "${CONTAINER_DIR}/${container_image}" \
 gmx rms -s em.tpr -f md_0_10_noPBC.xtc -o rmsd_xtal.xvg -tu ns

## This generates one file
echo "output file:"
ls -l rmsd_xtal.xvg
echo

