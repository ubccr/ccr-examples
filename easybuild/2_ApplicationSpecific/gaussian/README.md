# Example Gaussian Easybuild

This is an example of installing Gaussian with Easybuild on a CCR compile node.  Gaussian is not provided in CCR's central software repository due to licensing restrictions.  Each group must obtain the installation media and install Gaussian in their own project directory.  Here we provide instructions for using an Easybuild recipe to install this in your group's project space.

Prior to starting this installation, you should be familiar with CCR's [software environments](https://docs.ccr.buffalo.edu/en/latest/software/modules/) and how to use software modules.  Please read the instructions on [building your own software](https://docs.ccr.buffalo.edu/en/latest/software/building/) - specifically on [building software for your group](https://docs.ccr.buffalo.edu/en/latest/software/building/#building-modules-for-your-group).

## Installation Steps

> [!NOTE]
> When using Easybuild, do NOT use the CCR login nodes. Always use a compile node or do this from a compute node in an OnDemand desktop session or interactive job. See CCR docs for more info on [running jobs](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission). 
> These installations can use a decent amount of disk space so we recommend you use your project directory for all software installations. You'll need to set the `$CCR_BUILD_PREFIX` [environment variable](https://docs.ccr.buffalo.edu/en/latest/software/building/#building-modules-for-your-group) to point to your project directory, or else it will default to installing in your home directory.

1. Load the Easybuild module
```
module load easybuild
```

2. Upload your Gaussian software installation file to CCR and place in your home or project directory

3. Create Gaussian Easybuild recipe  
In the folder that your Gaussian software was uploaded to, create a file called `Gaussian-16.C.02-AVX2.eb`  Copy the contents from [this example](Gaussian-16.C.02-AVX2.eb) Easybuild recipe and place them in your new recipe file.  Edit the file as described, save and exit the editor.  There are several things to be aware of with this recipe file:  
- You MUST name the file in the same way that CCR provides in this example
- If you're installing a different version of Gaussian, you must update the Easybuild recipe name with the updated version number AND change the version number within your Easybuild recipe on line 7.  
- You MUST update line 32 of your Easybuild recipe with the full path of where you've stored your installation media. What we have for that line in our example is simply a placeholder.  
- You will need to update the checksum value on line 33 to match the checksum of your software installation media.  To get the checksum of a file, run:  `sha256sum filename`  

4. Install the software

```
eb Gaussian-16.C.02-AVX2.eb --umask=007
```

## Using your module  

> [!NOTE]
> To make your custom modules appear in `module avail`, `module spider` etc., you can set the `$CCR_CUSTOM_BUILD_PATHS` environment variable following the instructions outlined in [CCR's module building documentation](https://docs.ccr.buffalo.edu/en/latest/software/building/#building-modules-for-your-group).
> To ensure the path gets picked up on login, point it to `~/.ccr/modulepaths`.

Once the installation completes successfully, when you search for the module you should see it listed in a section at the top with your group's installation path listed.  For example:  

```
module spider gaussian
```
Expected output:
```
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  gaussian: gaussian/16.C.02-AVX2
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    Description:
      Gaussian provides state-of-the-art capabilities for electronic structure modeling. Gaussian 09 is licensed for a wide variety of computer systems. All versions of Gaussian 09 contain every scientific/modeling feature, and none imposes any
      artificial limitations on calculations other than your computing resources and patience. This is the official gaussian AVX2 build.

    Properties:
      Chemistry libraries/apps

    This module can be loaded directly: module load gaussian/16.C.02-AVX2

    Help:

      Description
      ===========
      Gaussian provides state-of-the-art capabilities for electronic structure
      modeling. Gaussian 09 is licensed for a wide variety of computer
      systems. All versions of Gaussian 09 contain every scientific/modeling
      feature, and none imposes any artificial limitations on calculations
      other than your computing resources and patience.

      This is the official gaussian AVX2 build.


      More information
      ================
       - Homepage: https://www.gaussian.com/
```

To load the module run:
```
module load gaussian/16.C.02-AVX2
gaussian --help
```

## Troubleshooting  

This installation will take awhile.  If it does not complete successfully, please refer to the log files it reports in the output of the installation attempt to see what the issue might be.  They are verbose but very informative. 

We provide a full [Easybuild tutorial](https://docs.ccr.buffalo.edu/en/latest/howto/easybuild/) to better understand how this tool works.  We highly recommend referring to it if you run into any issues.  The [Frequently Asked Questions](https://docs.ccr.buffalo.edu/en/latest/howto/easybuild/#frequently-asked-questions) section covers most common errors.

If you have any issues with these instructions, please contact [CCR Help](https://docs.ccr.buffalo.edu/en/latest/help/)

