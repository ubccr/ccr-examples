# LS-DYNA  

  LS-DYNA is a general-purpose finite element program capable of simulating complex real world problems.

## Example Scripts

Provided in this repository are two example LS-DYNA Slurm jobs: [lsdyna.bash](./lsdyna_single_node_smp.bash) is a script for running shared memory parallel (SMP) LS-DYNA, [lsdyna_single_node_mpp.bash](./lsdyna_single_node_mpp.bash) and [lsdyna_multi_node_mpp.bash](./lsdyna_multi_node_mpp.bash) are scripts with examples for message passing parallel (MPP) LS-DYNA.  We provide examples of single and double precision for both options. Please uncomment the line with the command you want to use and add a `#` to the beginning of the line with the command you don't want to use.  SMP should be run on a single node.  MPP can run on multiple cores of a single node or potentially across multiple nodes.  You can find an example input file `ball_and_plate.k` for testing purposes on CCR's systems in `/util/software/examples/lsdyna`.  These scripts may need to be modified to properly work for your problem.  Please refer to the Ansys LS-DYNA [manuals](https://lsdyna.ansys.com/manuals/) for further information and options.

## Executables

LS-DYNA is now part of the Ansys software bundle. To load the module, use `module load ansys/2023R1`

The LS-DYNA executables do not show up in the path any longer. To use them properly, you'll need to use these commands:

- Single Precision - SMP: `$EBROOTANSYS/v231/ansys/bin/linx64/lsdyna_sp.e`
- Double Precision - SMP: `$EBROOTANSYS/v231/ansys/bin/linx64/lsdyna_dp.e`
- Single precision - MPP: `$EBROOTANSYS/v231/ansys/bin/linx64/lsdyna_sp_mpp.e`
- Double precision - MPP: `$EBROOTANSYS/v231/ansys/bin/linx64/lsdyna_dp_mpp.e`

## Memory Specification

The LS-DYNA command line option `MEMORY` specifies memory per node with a base unit words. This is not the same thing as requesting memory (or RAM) for your job.  The argument can be specified in words or megawords (denoted by m). For single precision LS-DYNA, a word is 4 bytes and a megaword is 4 MB. For double precision, a word is 8 bytes and a megaword is 8MB.

Example: (Single Precision)

```
MEMORY=300m     #300 megawords = 300 megawords * 4 MB = 1200 MB (~1.2GB)
MEMORY=600      #600 words = 600 words * 4 B = 2400 KB
```

Example: (Double Precision)

```
MEMORY=300m     #300 megawords = 300 megawords * 8 MB = 2400 MB (~2.4GB)
MEMORY=600      #600 words = 600 words * 8 B = 4800 KB
```

Thanks to [Texas A&M](https://hprc.tamu.edu/kb/Software/LST/ls-dyna/) for their excellent documentation.  Additional information on LS-DYNA memory specifications can be found in documentation by [MCW Research Computing](https://docs.rcc.mcw.edu/software/lsdyna/#memory-allocation), [UCONN](https://kb.uconn.edu/space/SH/26033653105/LS-Dyna+Guide#Memory-allocation), and the Ansys documentation [here](https://lsdyna.ansys.com/memory-for-implicit-analyses/), [here](https://www.d3view.com/a-few-words-on-memory-settings-in-ls-dyna/), and [here](https://www.dynasupport.com/howtos/implicit/implicit-memory-notes).  
