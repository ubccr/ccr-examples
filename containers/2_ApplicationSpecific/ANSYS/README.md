# ANSYS container

[ANSYS](https://ansys.synopsys.com) is a commercial suite of engineering simulation software products.

> [!WARNING]
> ANSYS is a suite of commercial programs.
> You MUST have appropriate licenses for every ANSYS product you use
> Roswell Park researchers and other commercial users should utilize their own license with ANSYS products

UB provides an educational license for ANSYS.  The license is for
**academic purposes only**  
All the [examples](./EXAMPLES.md) use the academic license file.


CCR providses a couple of pre-built ANSYS container:

ANSYS release 2026 R1 - installed from CD (no service packs applied)

```bash
/util/software/containers/x86_64/ANSYS-2026_R1-x86_64.sif
```

ANSYS release 2026 R1 - installed from CD, with Service Pack 4 applied

```bash
/util/software/containers/x86_64/ANSYS-2026_R1.04-x86_64.sif
```

The following link will always point to the lastest patched version:

```bash
/util/software/containers/x86_64/ANSYS-x86_64.sif 
```

See the [EXAMPLES file](./EXAMPLES.md) for information on running applications
in an ANSYS container.  


## Sample Slurm scripts

[ANSYS LS-DYNA example batch script](https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/ANSYS/ANSYS_lsdyna_single_node_MPI.bash)  
[ANSYS LS-DYNA example batch script](https://raw.githubusercontent.com/ubccr/ccr-examples/refs/heads/main/containers/2_ApplicationSpecific/ANSYS/ANSYS_lsdyna_single_node_OpenMP.bash)  


## Documentation Resources

For more information on ANSYS see the [ANSYS Help Center](https://ansyshelp.ansys.com/public/account/secured?returnurl=/Views/Secured/main_page.htm) and the [ANSYS YouTube Channel](https://www.youtube.com/channel/UCdymxOTZSP8RzRgFT8kpYpA)

