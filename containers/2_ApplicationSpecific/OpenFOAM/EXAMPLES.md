# OpenFOAM Examples

Please Note: Graphical output (paraFoam) will only display in an [OnDemand portal](https://ondemand.ccr.buffalo.edu) session

## Text only Example

Start an interactive job e.g.

```
salloc --cluster=ub-hpc --partition=general-compute --qos=general-compute --mem=128GB --nodes=1 --cpus-per-task=1 --tasks-per-node=32 --time=01:00:00
```

...then run the container


```
cd /projects/academic/[YourGroupName]/OpenFOAM
apptainer shell -B /util:/util,/scratch:/scratch,/vscratch:/vscratch,/projects:/projects OpenFOAM-13-$(arch).sif
```

sample output:

> ```
> Run the following to use OpenFOAM:
>
>
> source /opt/openfoam13/etc/bashrc && mkdir -p "${FOAM_RUN}" "${FOAM_JOB_DIR}"
>
> Apptainer>
> ```

All the following commands are run from the "Apptainer> " prompt

Copy the line from above to use OpenFOAM

```
source /opt/openfoam13/etc/bashrc && mkdir -p "${FOAM_RUN}" "${FOAM_JOB_DIR}"
```

Example Run
Taken from the OpenFOAM 13 [Backward-facing step](https://doc.cfd.direct/openfoam/user-guide-v13/backwardstep) example

```
cd "${FOAM_RUN}"
cp -r $FOAM_TUTORIALS/incompressibleFluid/pitzDailySteady .
cd pitzDailySteady
blockMesh
```

sample output:

> ```
> /*---------------------------------------------------------------------------*\
>   =========                 |
>   \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
>    \\    /   O peration     | Website:  https://openfoam.org
>     \\  /    A nd           | Version:  13
>      \\/     M anipulation  |
> \*---------------------------------------------------------------------------*/
> Build  : 13-65eda17ad4ca
> Exec   : blockMesh
> Date   : Jul 17 2025
> Time   : 11:56:13
> Host   : "cpn-v14-13.dev.ccr.buffalo.edu"
> PID    : 3539600
> I/O    : uncollated
> Case   : /projects/academic/ccradmintest/tkewtest/OpenFOAM/tkewtest-13/run/pitzDailySteady
> nProcs : 1
> sigFpe : Enabling floating point exception trapping (FOAM_SIGFPE).
> fileModificationChecking : Monitoring run-time modified files using timeStampMaster (fileModificationSkew 10)
> allowSystemOperations : Allowing user-supplied system call operations
> 
> // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //
> Create time
> 
> Reading "blockMeshDict"
> 
> Creating block mesh from
>     "system/blockMeshDict"
> No non-linear block edges defined
> No non-planar block faces defined
> Creating topology blocks
> Creating topology patches
> 
> Creating block mesh topology
> 
> Check topology
> 
> 	Basic statistics
> 		Number of internal faces : 5
> 		Number of boundary faces : 20
> 		Number of defined boundary faces : 20
> 		Number of undefined boundary faces : 0
> 	Checking patch -> block consistency
> 
> Creating block offsets
> Creating merge list .
> 
> Creating polyMesh from blockMesh
> Creating patches
> Creating cells
> Creating points with scale 0.001
>     Block 0 cell size :
>         i : 0.00158284 .. 0.000791418
>         j : 0.000318841 .. 0.000420268
>         k : 0.001
>     Block 1 cell size :
>         i : 0.000528387 .. 0.00211355
>         j : 0.00112889 .. 0.000360188 0.00112841 .. 0.000361677 0.00112889 .. 0.000360188 0.00112841 .. 0.000361677 
>         k : 0.001
>     Block 2 cell size :
>         i : 0.000528387 .. 0.00211355
>         j : 0.000318841 .. 0.000420268 0.000320918 .. 0.000419851 0.000318841 .. 0.000420268 0.000320918 .. 0.000419851 
>         k : 0.001
>     Block 3 cell size :
>         i : 0.0020578 .. 0.00514451 0.00205699 .. 0.00514248 0.0020578 .. 0.00514451 0.00205699 .. 0.00514248 
>         j : 0.000940741 .. 0.000940741 0.0009328 .. 0.0009328 0.000940741 .. 0.000940741 0.0009328 .. 0.0009328 
>         k : 0.001
>     Block 4 cell size :
>         i : 0.0020466 .. 0.00511651 0.00204663 .. 0.00511656 0.0020466 .. 0.00511651 0.00204663 .. 0.00511656 
>         j : 0.00112889 .. 0.000257962 0.00111936 .. 0.000255785 0.00112889 .. 0.000257962 0.00111936 .. 0.000255785 
>         k : 0.001
> 
> No patch pairs to merge
> 
> Writing polyMesh
> ----------------
> Mesh Information
> ----------------
>   boundingBox: (-0.0206 -0.0254 -0.0005) (0.29 0.0254 0.0005)
>   nPoints: 25012
>   nCells: 12225
>   nFaces: 49180
>   nInternalFaces: 24170
> ----------------
> Patches
> ----------------
>   patch 0 (start: 24170 size: 30) name: inlet
>   patch 1 (start: 24200 size: 57) name: outlet
>   patch 2 (start: 24257 size: 223) name: upperWall
>   patch 3 (start: 24480 size: 250) name: lowerWall
>   patch 4 (start: 24730 size: 24450) name: frontAndBack
> 
> End
> 
> ```

```
foamRun
```

sample output:

> ```
> /*---------------------------------------------------------------------------*\
>   =========                 |
>   \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
>    \\    /   O peration     | Website:  https://openfoam.org
>     \\  /    A nd           | Version:  13
>      \\/     M anipulation  |
> \*---------------------------------------------------------------------------*/
> Build  : 13-65eda17ad4ca
> Exec   : foamRun
> Date   : Jul 17 2025
> Time   : 11:57:18
> Host   : "cpn-v14-13.dev.ccr.buffalo.edu"
> PID    : 3539615
> I/O    : uncollated
> Case   : /projects/academic/ccradmintest/tkewtest/OpenFOAM/tkewtest-13/run/pitzDailySteady
> nProcs : 1
> sigFpe : Enabling floating point exception trapping (FOAM_SIGFPE).
> fileModificationChecking : Monitoring run-time modified files using timeStampMaster (fileModificationSkew 10)
> allowSystemOperations : Allowing user-supplied system call operations
> 
> // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //
> [...]
> Time = 285s
> 
> smoothSolver:  Solving for Ux, Initial residual = 0.000122524, Final residual = 1.21333e-05, No Iterations 5
> smoothSolver:  Solving for Uy, Initial residual = 0.000992942, Final residual = 6.75593e-05, No Iterations 6
> GAMG:  Solving for p, Initial residual = 0.00123295, Final residual = 0.000112114, No Iterations 4
> time step continuity errors : sum local = 0.0047489, global = 0.000564888, cumulative = 0.55796
> smoothSolver:  Solving for epsilon, Initial residual = 0.000139397, Final residual = 8.97324e-06, No Iterations 3
> smoothSolver:  Solving for k, Initial residual = 0.000221974, Final residual = 1.35975e-05, No Iterations 4
> ExecutionTime = 7.80921 s  ClockTime = 9 s
> 
> 
> SIMPLE solution converged in 285 iterations
> 
> streamlines streamlines write:
>     Seeded 10 particles
>     Sampled 12040 locations
> 
> End
> 
> ```


## ParaFOAM

Since paraFoam is a GUI application, it must be run in an [OnDemand portal](https://ondemand.ccr.buffalo.edu) session
and generally requires at least 128GB of memory to run
For example:

Open a browser window to our [OnDemand portal](https://ondemand.ccr.buffalo.edu)

[UB-HPC & Faculty Cluster Desktop]

Cluster: UB-HPC  
Slurm Account: [Your Slurm account]  
Partition: [general-compute]  
Quality of Service: [general-compute]  
Number of Hours Requested: 4
Number of Cores: 28
Amount of Memory: 128000

[Launch]

Once the Slurm job starts you can press the button that appears
[Launch UB-HPC & Faculty Cluster Desktop]

A new window will open with the GUI displayed.

Open a terminal with:
[Applications][Terminal Emulator]

cd to your OpenFOAM directory

```
cd /projects/academic/[YourGroupName]/OpenFOAM
```

...and start the container shell
NOTE: This is NOT the same command as above, there are added bind mounts that
 are necessary to run paraFoam in CCR's OnDemand

```
apptainer shell -B /util:/util -B /scratch:/scratch -B /vscratch:/vscratch \
 -B /projects:/projects -B ${XDG_RUNTIME_DIR}:${XDG_RUNTIME_DIR} \
 -B /cvmfs:/cvmfs ./OpenFOAM-13-$(arch).sif
```

sample output:

> ```
> Run the following to use OpenFOAM:
> 
> 
> source /opt/openfoam13/etc/bashrc && mkdir -p "${FOAM_RUN}" "${FOAM_JOB_DIR}"
> 
> Apptainer> 
> ```

All the following commands are run from the "Apptainer> " prompt

copy the line from above to use OpenFOAM

```
source /opt/openfoam13/etc/bashrc && mkdir -p "${FOAM_RUN}" "${FOAM_JOB_DIR}"
```

This example uses the data generated in the text example above, following
the [Backward-facing step](https://doc.cfd.direct/openfoam/user-guide-v13/backwardstep) example
Note that those commands could have been run from the "Apptainer> " prompt here.

```
cd "${FOAM_RUN}/pitzDailySteady"
paraFoam
```

This will start with a ParaView splash screen - press the [Close] button.
In the lower left hand window pane scroll down to "Mesh Parts" and select
the dark button next to the left of the words "Mesh Parts" then press [Apply]
you will then see the mesh as a solid block of one color
You can then follow the instructions in the [OpenFOAM examples doc](https://doc.cfd.direct/openfoam/user-guide-v13/backwardstep#x5-70002.1.3) for 
this mesh

