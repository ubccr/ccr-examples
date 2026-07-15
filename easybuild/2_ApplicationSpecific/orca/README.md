# Example Orca Easybuild

This is an example of installing Orca with Easybuild on a CCR compile node.  Orca is not provided in CCR's central software repository due to licensing restrictions.  Each group must obtain the installation media and install Orca in their own project directory.  Here we provide instructions for using an Easybuild recipe to install this in your group's project space.

Prior to starting this installation, you should be familiar with CCR's [software environments](https://docs.ccr.buffalo.edu/en/latest/software/modules/) and how to use software modules.  Please read the instructions on [building your own software](https://docs.ccr.buffalo.edu/en/latest/software/building/) - specifically on [building software for your group](https://docs.ccr.buffalo.edu/en/latest/software/building/#building-modules-for-your-group).

## Installation Steps

> [!NOTE]
> When using Easybuild, do NOT use the CCR login nodes. Always use a compile node or do this from a compute node in an OnDemand desktop session or interactive job. See CCR docs for more info on [running jobs](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission). 
> These installations can use a decent amount of disk space so we recommend you use your project directory for all software installations. You'll need to set the `$CCR_BUILD_PREFIX` [environment variable](https://docs.ccr.buffalo.edu/en/latest/software/building/#building-modules-for-your-group) to point to your project directory, or else it will default to installing in your home directory.

1. Load the Easybuild module
```
module load easybuild
```

2. Upload your Orca software installation file to CCR and place in your home or project directory.  We recommend downloading the x86_64, `.tar.xv` archive version.  

3. Create Orca Easybuild recipe  
In the folder that your Orca software was uploaded to, create a file called `ORCA-6.0.1-gompi-2021b.eb`  Copy the contents from [CCR's ORCA Easybuild recipe example](ORCA-6.0.1-gompi-2021b.eb) and place them in your new recipe file.  Edit the file as described, save and exit the editor.  There are several things to be aware of with this recipe file:  
- You MUST name the file in the same way that CCR provides in this example
- If you're installing a different version of Orca, you must update the Easybuild recipe name with the updated version number AND change the version number within your Easybuild recipe on line 7.  
- You will need to update the checksum value on line 20 to match the checksum of your software installation media.  To get the checksum of a file, run:  `sha256sum filename`  

4. Install the software

```
eb ORCA-6.0.1-gompi-2021b.eb
```

## Using your module  

Once the installation completes successfully, when you search for the module you should see it listed in a section at the top with your group's installation path listed.  For example:  

```
module spider orca
```
Expected output:
```
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  orca: orca/6.0.1
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    Description:
      ORCA is a flexible, efficient and easy-to-use general purpose tool for quantum chemistry with specific emphasis on spectroscopic properties of open-shell molecules. It features a wide variety of standard quantum chemical methods
      ranging from semiempirical methods to DFT to single- and multireference correlated ab initio methods. It can also treat environmental and relativistic effects.

    Properties:
      Chemistry libraries/apps

    You will need to load all module(s) on any one of the lines below before the "orca/6.0.1" module is available to load.

      gcc/11.2.0  openmpi/4.1.1

    Help:

      Description
      ===========
      ORCA is a flexible, efficient and easy-to-use general purpose tool for quantum
      chemistry with specific emphasis on spectroscopic properties of open-shell
      molecules. It features a wide variety of standard quantum chemical methods
      ranging from semiempirical methods to DFT to single- and multireference
      correlated ab initio methods. It can also treat environmental and relativistic
      effects.


      More information
      ================
       - Homepage: https://orcaforum.kofo.mpg.de

```

To load the orca module, load it's dependencies as listed in the `module spider` output and the orca module:  

```
$ module load gcc/11.2.0  openmpi/4.1.1 orca/6.0.1
$ orca --help
```

## Troubleshooting  

This installation is normally quite fast.  If it does not complete successfully, please refer to the log files it reports in the output of the installation attempt to see what the issue might be.  They are verbose but very informative. 

We provide a full [Easybuild tutorial](https://docs.ccr.buffalo.edu/en/latest/howto/easybuild/) to better understand how this tool works.  We highly recommend referring to it if you run into any issues.  The [Frequently Asked Questions](https://docs.ccr.buffalo.edu/en/latest/howto/easybuild/#frequently-asked-questions) section covers most common errors.

If you have any issues with these instructions, please contact [CCR Help](https://docs.ccr.buffalo.edu/en/latest/help/)

