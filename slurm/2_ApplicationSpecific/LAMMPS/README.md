# LAMMPS Slurm Example

LAMMPS (Large-scale Atomic/Molecular Massively Parallel Simulator) is an open-source molecular dynamics software package used to simulate materials, biomolecules, polymers, and other particle-based systems.

Provided in this repository is a [Slurm script](./slurm_LAMMPS_example.bash) and a small [LAMMPS input file](./in.lammps) that can be used as a starting point for running LAMMPS simulations as batch jobs on CCR's clusters.

## How to use

The provided input file runs a small Lennard-Jones particle simulation. It is intended only as a quick test to demonstrate how to submit and run a LAMMPS job on CCR.

Ensure that the Slurm script and input file are in the same working directory. Before submitting the job, replace the placeholders in the Slurm script with values appropriate for your CCR account and allocation.

Submit the batch job by running the following command:

```bash
sbatch slurm_LAMMPS_example.bash
