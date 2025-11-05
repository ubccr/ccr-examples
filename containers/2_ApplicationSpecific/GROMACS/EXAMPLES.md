# GROMACS Examples

## Lysozyme in Water example

Ref: http://www.mdtutorials.com/gmx/lysozyme/01_pdb2gmx.html


Start an interactive Slurm job, then change to your GROMACS directory e,g,

```bash
cd /projects/academic/[YourGroupName]/GROMACS
```

This example uses the hen egg white lysozyme - PDB code 1AKI
The PDB text file was downloaded from the [RCSB](http://www.rcsb.org/pdb/home/home.do) website for the crystal
structure.

This was downloaded as follows:

```bash
https://www.rcsb.org
Use the search bar top left to search for "1AKI"
on the top left hand side of the window [Download Files] [Legacy PDB Format]
```


Delete the crystal water molecules (residue "HOH" in the PDB file)

```bash
grep -v HOH 1AKI.pdb > 1AKI_clean.pdb
```

Verify thtat there a no entries listed under the comment MISSING
Incomplete internal sequences or any amino acid residues that have missing
atoms will cause pdb2gmx to fail

```bash
grep MISSING 1AKI_clean.pdb
```

No output expected


This example uses the CHARMM36 force field, downloaded from the
[MacKerell lab website](http://mackerell.umaryland.edu/charmm_ff.shtml#gromacs)

```bash
curl -L -o "charmm36-jul2022.ff.tgz" "https://mackerell.umaryland.edu/download.php?filename=CHARMM_ff_params_files/charmm36-jul2022.ff.tgz"
tar xzvf "charmm36-jul2022.ff.tgz"
```

Use "gmx pdb2gmx" to generate three files:

  The topology for the molecule.
  A position restraint file.
  A post-processed structure file.


```bash
gmx pdb2gmx -f 1AKI_clean.pdb -o 1AKI_processed.gro -water tip3p 
```

sample truncated output:

> ```
>                      :-) GROMACS - gmx pdb2gmx, 2025.3 (-:
> 
> Executable:   /usr/local/gromacs/bin/gmx_mpi
> Data prefix:  /usr/local/gromacs
> Working dir:  /vscratch/grp-ccradmintest/tkewtest/GROMACS
> Command line:
>   gmx_mpi pdb2gmx -f 1AKI_clean.pdb -o 1AKI_processed.gro -water tip3p
> 
> Note that more recent versions of the CHARMM force field may be downloaded from
> http://mackerell.umaryland.edu/charmm_ff.shtml#gromacs.
> 
> Select the Force Field:
> 
> From current directory:
> 
>  1: CHARMM all-atom force field
> 
> From '/usr/local/gromacs/share/gromacs/top':
> 
>  2: AMBER03 protein, nucleic AMBER94 (Duan et al., J. Comp. Chem. 24, 1999-2012, 2003)
> 
>  3: AMBER94 force field (Cornell et al., JACS 117, 5179-5197, 1995)
> [...]
> 15: GROMOS96 54a7 force field (Eur. Biophys. J. (2011), 40,, 843-856, DOI: 10.1007/s00249-011-0700-9)
> 
> 16: OPLS-AA/L all-atom force field (2001 aminoacid dihedrals)
> ```

Type "1" then [Enter] to select the "CHARMM all-atom force field" option

```bash
1
```

Sample truncated output

> ```
> 
> Using the Charmm36-jul2022 force field in directory ./charmm36-jul2022.ff
> 
> going to rename ./charmm36-jul2022.ff/aminoacids.r2b
> Opening force field file ./charmm36-jul2022.ff/aminoacids.r2b
> [...]
> going to rename ./charmm36-jul2022.ff/solvent.r2b
> Reading 1AKI_clean.pdb...
> WARNING: all CONECT records are ignored
> Read 'LYSOZYME', 1001 atoms
> 
> Analyzing pdb file
> Splitting chemical chains based on TER records or chain id changing.
> 
> There are 1 chains and 0 blocks of water and 129 residues with 1001 atoms
> 
>   chain  #res #atoms
> 
>   1 'A'   129   1001  
> 
> All occupancies are one
> All occupancies are one
> Opening force field file ./charmm36-jul2022.ff/atomtypes.atp
> 
> Reading residue database... (Charmm36-jul2022)
> Opening force field file ./charmm36-jul2022.ff/aminoacids.rtp
> [...]
> Opening force field file ./charmm36-jul2022.ff/solvent.c.tdb
> Analysing hydrogen-bonding network for automated assignment of histidine
>  protonation.
> Processing chain 1 'A' (1001 atoms, 129 residues)
>  213 donors and 184 acceptors were found.
> There are 255 hydrogen bonds
> Will use HISE for residue 15
> 
> Identified residue LYS1 as a starting terminus.
> 
> Identified residue LEU129 as a ending terminus.
> 9 out of 9 lines of specbond.dat converted successfully
> Special Atom Distance matrix:
>                     CYS6   MET12   HIS15   CYS30   CYS64   CYS76   CYS80
>                     SG48    SD87  NE2118   SG238   SG513   SG601   SG630
>    MET12    SD87   1.166
>    HIS15  NE2118   1.776   1.019
>    CYS30   SG238   1.406   1.054   2.069
>    CYS64   SG513   2.835   1.794   1.789   2.241
>    CYS76   SG601   2.704   1.551   1.468   2.116   0.765
>    CYS80   SG630   2.959   1.951   1.916   2.391   0.199   0.944
>    CYS94   SG724   2.550   1.407   1.382   1.975   0.665   0.202   0.855
>   MET105   SD799   1.827   0.911   1.683   0.888   1.849   1.461   2.036
>   CYS115   SG889   1.576   1.084   2.078   0.200   2.111   1.989   2.262
>   CYS127   SG981   0.197   1.072   1.721   1.313   2.799   2.622   2.934
>                    CYS94  MET105  CYS115
>                    SG724   SD799   SG889
>   MET105   SD799   1.381
>   CYS115   SG889   1.853   0.790
>   CYS127   SG981   2.475   1.686   1.483
> Linking CYS-6 SG-48 and CYS-127 SG-981...
> Linking CYS-30 SG-238 and CYS-115 SG-889...
> Linking CYS-64 SG-513 and CYS-80 SG-630...
> Linking CYS-76 SG-601 and CYS-94 SG-724...
> Start terminus LYS-1: NH3+
> End terminus LEU-129: COO-
> Opening force field file ./charmm36-jul2022.ff/aminoacids.arn
> 
> Checking for duplicate atoms....
> 
> Generating any missing hydrogen atoms and/or adding termini.
> 
> Now there are 129 residues with 1960 atoms
> 
> Making bonds...
> 
> Number of bonds was 1984, now 1984
> 
> Generating angles, dihedrals and pairs...
> Before cleaning: 5142 pairs
> Before cleaning: 5187 dihedrals
> 
> Making cmap torsions...
> 
> There are  127 cmap torsion pairs
> 
> There are 5187 dihedrals,  373 impropers, 3547 angles
>           5106 pairs,     1984 bonds and     0 virtual sites
> 
> Total mass 14313.255 a.m.u.
> 
> Total charge 8.000 e
> 
> Writing topology
> 
> Writing coordinate file...
> 
> 		--------- PLEASE NOTE ------------
> 
> You have successfully generated a topology from: 1AKI_clean.pdb.
> 
> The Charmm36-jul2022 force field and the tip3p water model are used.
> [...]
> ```

This generates three files:

```bash
ls -l topol.top posre.itp 1AKI_processed.gro
```

Sample output:


> ```
> -rw-rw-r-- 1 [CCRusername] nogroup  88246 Nov  5 09:54 1AKI_processed.gro
> -rw-rw-r-- 1 [CCRusername] nogroup  31304 Nov  5 09:54 posre.itp
> -rw-rw-r-- 1 [CCRusername] nogroup 541409 Nov  5 09:54 topol.top
> ```

Define the box dimensions using the editconf module.

```bash
gmx editconf -f 1AKI_processed.gro -o 1AKI_newbox.gro -c -d 1.2 -bt cubic
```

sample output:

> ```
>                      :-) GROMACS - gmx editconf, 2025.3 (-:
> 
> Executable:   /usr/local/gromacs/bin/gmx
> Data prefix:  /usr/local/gromacs
> Working dir:  /vscratch/grp-ccradmintest/tkewtest/GROMACS
> Command line:
>   gmx editconf -f 1AKI_processed.gro -o 1AKI_newbox.gro -c -d 1.2 -bt cubic
> 
> Note that major changes are planned in future for editconf, to improve usability and utility.
> Read 1960 atoms
> Volume: 123.376 nm^3, corresponds to roughly 55500 electrons
> No velocities found
>     system size :  3.817  4.234  3.454 (nm)
>     diameter    :  5.010               (nm)
>     center      :  2.781  2.488  0.017 (nm)
>     box vectors :  5.906  6.845  3.052 (nm)
>     box angles  :  90.00  90.00  90.00 (degrees)
>     box volume  : 123.38               (nm^3)
>     shift       :  0.924  1.217  3.688 (nm)
> new center      :  3.705  3.705  3.705 (nm)
> new box vectors :  7.410  7.410  7.410 (nm)
> new box angles  :  90.00  90.00  90.00 (degrees)
> new box volume  : 406.88               (nm^3)
> [...]
> ```

This generates one file

```bash
ls -l 1AKI_newbox.gro
```

sample output:

> ```
> -rw-rw-r-- 1 [CCRusername] nogroup 88246 Nov  5 10:06 1AKI_newbox.gro
> ```

Fill the box with solvent (water) using the solvate module 

```bash
gmx solvate -cp 1AKI_newbox.gro -cs spc216.gro -o 1AKI_solv.gro -p topol.top
```

sample output:

> ```
>                      :-) GROMACS - gmx solvate, 2025.3 (-:
> 
> Executable:   /usr/local/gromacs/bin/gmx
> Data prefix:  /usr/local/gromacs
> Working dir:  /vscratch/grp-ccradmintest/tkewtest/GROMACS
> Command line:
>   gmx solvate -cp 1AKI_newbox.gro -cs spc216.gro -o 1AKI_solv.gro -p topol.top
> 
> Reading solute configuration
> Reading solvent configuration
> 
> Initialising inter-atomic distances...
> 
> WARNING: Masses and atomic (Van der Waals) radii will be guessed
> [...]
> ++++ PLEASE READ AND CITE THE FOLLOWING REFERENCE ++++
> A. Bondi
> van der Waals Volumes and Radii
> J. Phys. Chem. (1964)
> DOI: 10.1021/j100785a001
> -------- -------- --- Thank You --- -------- --------
> 
> Generating solvent configuration
> Will generate new solvent configuration of 4x4x4 boxes
> Solvent box contains 41472 atoms in 13824 residues
> Removed 1848 solvent atoms due to solvent-solvent overlap
> Removed 1833 solvent atoms due to solute-solvent overlap
> Sorting configuration
> Found 1 molecule type:
>     SOL (   3 atoms): 12597 residues
> Generated solvent containing 37791 atoms in 12597 residues
> Writing generated configuration to 1AKI_solv.gro
> 
> Output configuration contains 39751 atoms in 12726 residues
> Volume                 :     406.882 (nm^3)
> Density                :     988.485 (g/l)
> Number of solvent molecules:  12597   
> 
> Processing topology
> Adding line for 12597 solvent molecules with resname (SOL) to topology file (topol.top)
> 
> Back Off! I just backed up topol.top to ./#topol.top.1#
> [...]
> ```

This generates one file, "1AKI_solv.gro" and updates topol.top

```bash
ls -l 1AKI_solv.gro
```

> ```
> -rw-rw-r-- 1 [CCRusername] nogroup 1788841 Nov  5 10:10 1AKI_solv.gro
> ```

```bash
diff topol.top \#topol.top.1# 
```

sample output:

> ```
> < LYSOZYME in water
> ---
> > LYSOZYME
> 18486d18485
> < SOL             12597
> ```

i.e. the "LYSOZYME" linewas changed to "LYSOZYME in water" and the
"SOL [...]" line was added"



Download the example molecular dynamics parameter (.mdp) file from
http://www.mdtutorials.com/

```bash
curl -L -o "ions.mdp" "http://www.mdtutorials.com/gmx/lysozyme/Files/ions.mdp"
```

...and move the file to an "inputs" direcory

```bash
mkdir -p "inputs"
mv "ions.mdp" "./inputs"
```

Generate an atomic-level input file (.tpr)

```bash
gmx grompp -f inputs/ions.mdp -c 1AKI_solv.gro -p topol.top -o ions.tpr
```

sample output:

> ```
>                       :-) GROMACS - gmx grompp, 2025.3 (-:
> 
> Executable:   /usr/local/gromacs/bin/gmx
> Data prefix:  /usr/local/gromacs
> Working dir:  /vscratch/grp-ccradmintest/tkewtest/GROMACS
> Command line:
>   gmx grompp -f inputs/ions.mdp -c 1AKI_solv.gro -p topol.top -o ions.tpr
> 
> Ignoring obsolete mdp entry 'ns_type'
> 
> NOTE 1 [file inputs/ions.mdp]:
>   With Verlet lists the optimal nstlist is >= 10, with GPUs >= 20. Note
>   that with the Verlet scheme, nstlist has no effect on the accuracy of
>   your simulation.
> 
> Setting the LD random seed to -102887427
> 
> Generated 167799 of the 167910 non-bonded parameter combinations
> Generating 1-4 interactions: fudge = 1
> 
> Generated 117432 of the 167910 1-4 parameter combinations
> 
> Excluding 3 bonded neighbours molecule type 'Protein_chain_A'
> 
> Excluding 2 bonded neighbours molecule type 'SOL'
> 
> NOTE 2 [file topol.top, line 18486]:
>   System has non-zero total charge: 8.000000
>   Total charge should normally be an integer. See
>   https://manual.gromacs.org/current/user-guide/floating-point.html
>   for discussion on how close it should be to an integer.
> 
> 
> 
> Analysing residue names:
> There are:   129    Protein residues
> There are: 12597      Water residues
> Analysing Protein...
> Number of degrees of freedom in T-Coupling group rest is 81459.00
> The integrator does not provide a ensemble temperature, there is no system ensemble temperature
> 
> NOTE 3 [file inputs/ions.mdp]:
>   You are using a plain Coulomb cut-off, which might produce artifacts.
>   You might want to consider using PME electrostatics.
> 
> 
> 
> This run will generate roughly 3 Mb of data
> 
> There were 3 NOTEs
> [...]
> ```

This generates two files:

```bash
ls -l ions.tpr mdout.mdp 
```

sample output:

> ```
> -rw-rw-r-- 1 [CCRusername] nogroup 1173404 Nov  5 12:01 ions.tpr
> -rw-rw-r-- 1 [CCRusername] nogroup   10972 Nov  5 12:01 mdout.mdp
> ```

Replace water molecules with the ions

```bash
gmx genion -s ions.tpr -o 1AKI_solv_ions.gro -p topol.top -pname NA -nname CL -neutral
```

sample abridged output:

```bash
                      :-) GROMACS - gmx genion, 2025.3 (-:

Executable:   /usr/local/gromacs/bin/gmx
Data prefix:  /usr/local/gromacs
Working dir:  /vscratch/grp-ccradmintest/tkewtest/GROMACS
Command line:
  gmx genion -s ions.tpr -o 1AKI_solv_ions.gro -p topol.top -pname NA -nname CL -neutral

Reading file ions.tpr, VERSION 2025.3 (single precision)
Reading file ions.tpr, VERSION 2025.3 (single precision)
Will try to add 0 NA ions and 8 CL ions.
Select a continuous group of solvent molecules
Group     0 (         System) has 39751 elements
Group     1 (        Protein) has  1960 elements
Group     2 (      Protein-H) has  1001 elements
Group     3 (        C-alpha) has   129 elements
Group     4 (       Backbone) has   387 elements
Group     5 (      MainChain) has   515 elements
Group     6 (   MainChain+Cb) has   632 elements
Group     7 (    MainChain+H) has   644 elements
Group     8 (      SideChain) has  1316 elements
Group     9 (    SideChain-H) has   486 elements
Group    10 (    Prot-Masses) has  1960 elements
Group    11 (    non-Protein) has 37791 elements
Group    12 (          Water) has 37791 elements
Group    13 (            SOL) has 37791 elements
Group    14 (      non-Water) has  1960 elements
Select a group: 
```

Select the "SOL" option "13"

at the "Select a group: " prompt

```bash
13
```

sample output:

> ```
> Selected 13: 'SOL'
> Number of (3-atomic) solvent molecules: 12597
> 
> Processing topology
> Replacing 8 solute molecules in topology file (topol.top)  by 0 NA and 8 CL ions.
> 
> Back Off! I just backed up topol.top to ./#topol.top.2#
> Using random seed -209750018.
> Replacing solvent molecule 7036 (atom 23068) with CL
> Replacing solvent molecule 705 (atom 4075) with CL
> Replacing solvent molecule 8703 (atom 28069) with CL
> Replacing solvent molecule 12082 (atom 38206) with CL
> Replacing solvent molecule 4139 (atom 14377) with CL
> Replacing solvent molecule 12230 (atom 38650) with CL
> Replacing solvent molecule 3250 (atom 11710) with CL
> Replacing solvent molecule 10939 (atom 34777) with CL
> [...]
> ```

This generates one file, "1AKI_solv_ions.gro" and updates topol.top

```bash
ls -l 1AKI_solv_ions.gro
```

sample output:

> ```
> -rw-rw-r-- 1 [CCRusername] nogroup 1788130 Nov  5 12:13 1AKI_solv_ions.gro
> ```

```bash
diff topol.top '#topol.top.2#'
```

sample output:


> ```
> < SOL         12589
> < CL               8
> ---
> > SOL             12597
> ```

i.e. 8 water molecules have been replaced by CL ions



>>> TO DO <<<
cleanup /vscratch dir references
