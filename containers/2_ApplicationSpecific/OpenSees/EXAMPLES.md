# Examples of running the commands shown in the OpenSees Documents

This is a selection of examples from [UC Berkeley OpenSees Examples](https://opensees.berkeley.edu/wiki/index.php?title=Examples) and [OpenSeesPy Examples](https://openseespydoc.readthedocs.io/en/latest/src/examples.html)

There are both TCL scripts and Python scripts

None of these example produces graphical output (graphical output will only be seen in CCR's [OnDemand portal](https://ondemand.ccr.buffalo.edu))

The following examples assume you have started an interactive Slurm session with multiple cores in the job e.g.

```
salloc --cluster=ub-hpc --partition=general-compute --qos=general-compute --exclusive --time=10:00:00
```

...and started the container like this:

```
apptainer shell -B /util:/util,/scratch:/scratch,/projects/academic/[YourGroupName]:/projects /path/to/OpenSees-$(arch).sif
Apptainer>
```

**All the following commands are run from the Apptainer> prompt**

## Elastic Column Pushover

Example from: https://opensees.github.io/OpenSeesExamples/introductoryStructural/elasticCantileverColumnPushover/example.html

Download the tcl script

```
curl -o ECP_example.tcl https://opensees.github.io/OpenSeesExamples/_downloads/1f17737837e85b8f0966a6fa1053ac84/example.tcl
```

...then run the script

```
OpenSees ECP_example.tcl
```

expected output:

> ```
>
>
>          OpenSees -- Open System For Earthquake Engineering Simulation
>                  Pacific Earthquake Engineering Research Center
>                         Version 3.7.2 64-Bit
>
>       (c) Copyright 1999-2016 The Regents of the University of California
>                               All Rights Reserved
>   (Copyright and Disclaimer @ http://www.berkeley.edu/OpenSees/copyright.html)
>
>
> Done!
> ```

The run produced output files in a Data subdirectory

```
ls -l Data/
```

sample output:

> ```
> -rw-rw-r-- 1 [CCRusername] nogroup 14115 Jul  1 10:18 DBase.out
> -rw-rw-r-- 1 [CCRusername] nogroup  8055 Jul  1 10:18 DCol.out
> -rw-rw-r-- 1 [CCRusername] nogroup 36106 Jul  1 10:18 DFree.out
> -rw-rw-r-- 1 [CCRusername] nogroup 17392 Jul  1 10:18 Drift.out
> -rw-rw-r-- 1 [CCRusername] nogroup 55400 Jul  1 10:18 FCol.out
> -rw-rw-r-- 1 [CCRusername] nogroup 33232 Jul  1 10:18 RBase.out
> ```



## Pushover Analysis of 2-Story Moment Frame

Example From: https://opensees.berkeley.edu/wiki/index.php?title=Pushover_Analysis_of_2-Story_Moment_Frame

Download the tcl scripts

```
curl -o Pushover_example.zip https://opensees.berkeley.edu/wiki/images/7/78/Pushover_example.zip
unzip -o Pushover_example.zip && rm Pushover_example.zip
```

You should have seven tcl files at this point:

```
ls -l DisplayModel2D.tcl DisplayPlane.tcl pushover_concentrated.tcl pushover_distributed.tcl rotLeaningCol.tcl rotSect2DModIKModel.tcl rotSpring2DModIKModel.tcl
```

expected output:

> ```
> -rw-rw-r-- 1 [CCRusername] nogroup  3236 Jun 23  2010 DisplayModel2D.tcl
> -rw-rw-r-- 1 [CCRusername] nogroup  6791 Oct  7  2009 DisplayPlane.tcl
> -rw-rw-r-- 1 [CCRusername] nogroup 24277 Sep 18  2010 pushover_concentrated.tcl
> -rw-rw-r-- 1 [CCRusername] nogroup 21316 Sep 18  2010 pushover_distributed.tcl
> -rw-rw-r-- 1 [CCRusername] nogroup  1090 Jul 16  2010 rotLeaningCol.tcl
> -rw-rw-r-- 1 [CCRusername] nogroup  3919 Aug 28  2010 rotSect2DModIKModel.tcl
> -rw-rw-r-- 1 [CCRusername] nogroup  3890 Aug 30  2010 rotSpring2DModIKModel.tcl
> ```

There are two pushover tcl scripts we can run:

```
OpenSees pushover_concentrated.tcl
```

sample output:

> ```
>
>          OpenSees -- Open System For Earthquake Engineering Simulation
>                  Pacific Earthquake Engineering Research Center
>                         Version 3.7.2 64-Bit
>
>       (c) Copyright 1999-2016 The Regents of the University of California
>                               All Rights Reserved
>   (Copyright and Disclaimer @ http://www.berkeley.edu/OpenSees/copyright.html)
>
>
> WARNING: DO NOT USE THE "Bilin" MATERIAL, IT HAS BEEN REPLACED. Use "IMKBilin" or "HystereticSM" INSTEAD.
> ProfileSPDLinDirectSolver::solve() -  aii < 0 (i, aii): (9, 0)
> T1 = 0.8198074473990256 s
> T2 = 0.20812628532312813 s
> WARNING: analysis .. TransientAnalysis already exists => wipeAnalysis not invoked, problems may arise
> Model Built
> Running Pushover...
> Pushover complete
> ```

This run produces output files in the Concentrated-Pushover-Output subdirectory

```
ls -l Concentrated-Pushover-Output
```

Sample outout:

> ```
> total 2005
> -rw-rw-r-- 1 [CCRusername] nogroup  32281 Jul  1 10:58 Drift-Roof.out
> -rw-rw-r-- 1 [CCRusername] nogroup  32407 Jul  1 10:58 Drift-Story1.out
> -rw-rw-r-- 1 [CCRusername] nogroup  32358 Jul  1 10:58 Drift-Story2.out
> -rw-rw-r-- 1 [CCRusername] nogroup 159526 Jul  1 10:58 Fcol111.out
> -rw-rw-r-- 1 [CCRusername] nogroup 159460 Jul  1 10:58 Fcol121.out
> -rw-rw-r-- 1 [CCRusername] nogroup 135334 Jul  1 10:58 Fcol731.out
> -rw-rw-r-- 1 [CCRusername] nogroup 320068 Jul  1 10:58 MRFbeam-Mom-Hist.out
> -rw-rw-r-- 1 [CCRusername] nogroup 131476 Jul  1 10:58 MRFbeam-Rot-Hist.out
> -rw-rw-r-- 1 [CCRusername] nogroup 640516 Jul  1 10:58 MRFcol-Mom-Hist.out
> -rw-rw-r-- 1 [CCRusername] nogroup 322872 Jul  1 10:58 MRFcol-Rot-Hist.out
> -rw-rw-r-- 1 [CCRusername] nogroup  83169 Jul  1 10:58 Vbase.out
> ```

The other pushover tcl script:

```
OpenSees pushover_distributed.tcl
```

sample output:

> ```
>
>          OpenSees -- Open System For Earthquake Engineering Simulation
>                  Pacific Earthquake Engineering Research Center
>                         Version 3.7.2 64-Bit
>
>       (c) Copyright 1999-2016 The Regents of the University of California
>                               All Rights Reserved
>   (Copyright and Disclaimer @ http://www.berkeley.edu/OpenSees/copyright.html)
>
>
> WARNING: DO NOT USE THE "Bilin" MATERIAL, IT HAS BEEN REPLACED. Use "IMKBilin" or "HystereticSM" INSTEAD.
> ProfileSPDLinDirectSolver::solve() -  aii < minDiagTol (i, aii): (6, -6.82121e-13)
> T1 = 0.8199912211464974 s
> T2 = 0.21011836363528763 s
> WARNING: analysis .. TransientAnalysis already exists => wipeAnalysis not invoked, problems may arise
> Model Built
> Running Pushover...
> Pushover complete
> ```

This run produces output files in the Distributed-Pushover-Output subdirectory

```
ls -l Distributed-Pushover-Output
```

sample output:

> ```
> total 621
> -rw-rw-r-- 1 tkewtest nogroup  32281 Jul  1 11:02 Drift-Roof.out
> -rw-rw-r-- 1 tkewtest nogroup  32370 Jul  1 11:02 Drift-Story1.out
> -rw-rw-r-- 1 tkewtest nogroup  32379 Jul  1 11:02 Drift-Story2.out
> -rw-rw-r-- 1 tkewtest nogroup 159452 Jul  1 11:02 Fcol111.out
> -rw-rw-r-- 1 tkewtest nogroup 159540 Jul  1 11:02 Fcol121.out
> -rw-rw-r-- 1 tkewtest nogroup 134626 Jul  1 11:02 Fcol731.out
> -rw-rw-r-- 1 tkewtest nogroup  83180 Jul  1 11:02 Vbase.out
> ```


# Python examples

## Elastic Truss Analysis

Example from: https://openseespydoc.readthedocs.io/en/latest/src/truss.html

Download the tcl script

```
curl -o ElasticTruss.py  https://openseespydoc.readthedocs.io/en/latest/_downloads/ce7e03cd0f3959f5f6412cdbdd0f1ff5/ElasticTruss.py
```

Run the python script:

```
python ElasticTruss.py
```

expected output:

> ```
> Passed!
> ```

## Cantilever 2D EQ ground motion with gravity Analysis

Example from: https://openseespydoc.readthedocs.io/en/latest/src/Canti2DEQ.html

Download the tcl script and ground motion datafile

```
curl -o Canti2DEQ.py  https://openseespydoc.readthedocs.io/en/latest/_downloads/8081ec8b17600a21a98aa0cb4f9e86f8/Canti2DEQ.py
curl -o A10000.dat https://openseespydoc.readthedocs.io/en/latest/_downloads/be63293bb5508d09e1d21deb15d6851c/A10000.dat
```

Run the python script:

```
python Canti2DEQ.py
```

sample output:

> ```
> =========================================================
> Start cantilever 2D EQ ground motion with gravity example
> u2 =  -0.07441860465116278
> Passed!
> =========================================
> WARNING - the 'fullGenLapack' eigen solver is VERY SLOW. Consider using the default eigen solver.
> ```


NOTE: none of the parallel python examples here: https://openseespydoc.readthedocs.io/en/latest/src/parallelexs.html
work as expected, whether launched inside or outside of the container.  OpenSeesSP and OpenSeesMP do work in
parallel, across multiple nodes if desired.  See the Slurm example scripts to run them.

