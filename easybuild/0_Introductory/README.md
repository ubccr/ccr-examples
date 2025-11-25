# Introductory EasyBuild Example

In this example, we'll go through the process of rebuilding `SAMtools-v1.18`, which is originally compiled with `GCC 12.3.0`, using the `GCC 11.2.0` toolchain included in `ccrsoft/2023.01`.

## How to Rebuild

> [!NOTE]
> When using Easybuild, do NOT use the CCR login nodes. Always use a compile node or do this from a compute node in an OnDemand desktop session or interactive job. See CCR docs for more info on [running jobs](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission). 
> These installations can use a decent amount of disk space so we recommend you use your project directory for all software installations. You'll need to set the `$CCR_BUILD_PREFIX` [environment variable](https://docs.ccr.buffalo.edu/en/latest/software/building/#building-modules-for-your-group) to point to your project directory, or else it will default to installing in your home directory.

1. First, start by loading the Easybuild module and search for the existing `SAMtools-1.18-GCC-12.3.0` Easybuild (EB) recipe:

```
module load easybuild
eb --search samtools-1.18
```

Expected output:

```
== found valid index for /cvmfs/soft.ccr.buffalo.edu/versions/2023.01/easybuild/software/Core/easybuild/4.9.4/easybuild/easyconfigs, so using it...
 * /cvmfs/soft.ccr.buffalo.edu/versions/2023.01/easybuild/software/Core/easybuild/4.9.4/easybuild/easyconfigs/s/SAMtools/SAMtools-1.18-GCC-12.3.0.eb
```

2. To attempt to install this, we must make a copy of the existing EB recipe and modify it. The output above shows us where the EB recipe files are stored so we can easily copy to our home directory. **NOTE:** You must change the name of the EB recipe when you copy it, updating the toolchain version.

Here we update the name of the EB recipe from `SAMtools-1.18-GCC-12.3.0.eb` to `SAMtools-1.18-GCC-11.2.0.eb`. If you were to also change the version of the software package you're attempting to install, you need to change that in the EB recipe file name as well. In this example, we're not doing that.

```
cp /cvmfs/soft.ccr.buffalo.edu/versions/2023.01/easybuild/software/Core/easybuild/4.9.4/easybuild/easyconfigs/s/SAMtools/SAMtools-1.18-GCC-12.3.0.eb SAMtools-1.18-GCC-11.2.0.eb
```

The unmodified version of the file is available in this directory [here](./SAMtools-1.18-GCC-12.3.0.eb).

3. Open the recipe file in your favorite editor. The first thing to change is the toolchain line - change from 12.3.0 to 11.2.0:

```
toolchain = {'name': 'GCCcore', 'version': '11.2.0'}
```

4. Then we go through all the dependencies and build dependencies, if there are any, and verify the versions. We check to see if these packages are already installed in the ccrsoft/version that we're building this for (in this example `ccrsoft/2023.01`). If so, verify the versions are the same as the ones listed in the EB recipe and change any that are not. For this example, our dependencies (required to run the software) are:

```
dependencies = [
    ('ncurses', '6.4'),
    ('zlib', '1.2.13'),
    ('bzip2', '1.0.8'),
    ('XZ', '5.4.2'),
    ('cURL', '8.0.1'),
]
```

How do we figure out what CCR has installed?
We can look for the existing SAMtools version in `ccrsoft/2023.01` recipe built with `GCC 11.2.0` and replicate its dependency section the same way we changed the toolchain line.

**Important:** For some software installations, you will have to do the manual process of running module spider for each dependency. If the dependency isn't installed yet in the CCR software repository, Easybuild will try to build it. For the dependencies that ARE installed, we must match up the version in CCR's repository so that we're not building a second version for no reason.

```
eb --search samtools
```

Find a SAMtools recipe built with the `GCC 11.2.0` toolchain and update the dependencies section accordingly. Sample output:

```
*  /cvmfs/soft.ccr.buffalo.edu/versions/2023.01/easybuild/software/Core/easybuild/4.9.4/easybuild/easyconfigs/s/SAMtools/SAMtools-1.16.1-GCC-11.2.0.eb
```

5. Once we've updated any dependency versions, we can save the file and use the Easybuild dry run (`-M`) option to see if we've met all the dependencies and if not, which ones will Easybuild try to build for us. This will also tell us if we have an errors in the recipe file.

```
eb -M SAMtools-1.18-GCC-11.2.0.eb
```

Expected output:

```
== Temporary log file in case of crash /tmp/eb-v78o2lqs/easybuild-e0c5tsne.log
== Running parse hook for SAMtools-1.18-GCC-11.2.0.eb...
== found valid index for /cvmfs/soft.ccr.buffalo.edu/versions/2023.01/easybuild/software/Core/easybuild/4.9.4/easybuild/easyconfigs, so using it...
== Running parse hook for GCC-11.2.0.eb...
== Running parse hook for GCCcore-11.2.0.eb...
== Running parse hook for GCC-11.2.0.eb...
== Running parse hook for GCC-11.2.0.eb...
== Running parse hook for GCCcore-11.2.0.eb...
== Running parse hook for zlib-1.2.11.eb...
== Running parse hook for zlib-1.2.11-GCCcore-11.2.0.eb...
== Running parse hook for GCCcore-11.2.0.eb...
== Running parse hook for cURL-7.78.0-GCCcore-11.2.0.eb...
== Running parse hook for OpenSSL-1.1.eb...
== Running parse hook for pkgconf-1.8.0.eb...
== Running parse hook for zlib-1.2.11-GCCcore-11.2.0.eb...
== Running parse hook for cURL-7.78.0-GCCcore-11.2.0.eb...
== Running parse hook for OpenSSL-1.1.eb...
== Running parse hook for pkgconf-1.8.0.eb...

No missing modules!

== Temporary log file(s) /tmp/eb-v78o2lqs/easybuild-e0c5tsne.log* have been removed.
== Temporary directory /tmp/eb-v78o2lqs has been removed.
```

6. Easybuild is finding that all the dependencies are met and nothing else needs to be built so we can move forward with the install. Remove the dry run option, `-M`, and start the installation.

> [!WARNING] 
> Easybuild can build dependencies for us. If this output of the dry run indiciated additional dependencies were needed, we can add the `--robot` option to the end of this installation command to instruct Easybuild to try to build the dependencies. Be careful with this though! You should not be building toolchains, compilers, or major software already installed by CCR like python, java, and other large packages unless you really know what you're doing.

```
eb SAMtools-1.18-GCC-11.2.0.eb
```

Expected output:

```
== Temporary log file in case of crash /tmp/eb-allkgxg7/easybuild-6mhr_wsh.log
== Running parse hook for SAMtools-1.18-GCC-11.2.0.eb...
== found valid index for /cvmfs/soft.ccr.buffalo.edu/versions/2023.01/easybuild/software/Core/easybuild/4.9.4/easybuild/easyconfigs, so using it...
== Running parse hook for GCC-11.2.0.eb...
== Running parse hook for GCCcore-11.2.0.eb...
== Running parse hook for GCC-11.2.0.eb...
== Running parse hook for GCC-11.2.0.eb...
== Running parse hook for GCCcore-11.2.0.eb...
== Running parse hook for zlib-1.2.11.eb...
== Running parse hook for zlib-1.2.11-GCCcore-11.2.0.eb...
== Running parse hook for GCCcore-11.2.0.eb...
== Running parse hook for cURL-7.78.0-GCCcore-11.2.0.eb...
== Running parse hook for OpenSSL-1.1.eb...
== Running parse hook for pkgconf-1.8.0.eb...
...

>> command completed: exit 0, ran in < 1s
== COMPLETED: Installation ended successfully (took 1 min 18 secs)
== Results of the build can be found in the log file(s) ...

== Build succeeded for 1 out of 1
== Temporary log file(s) /tmp/eb-allkgxg7/easybuild-6mhr_wsh.log* have been removed.
== Temporary directory /tmp/eb-allkgxg7 has been removed.
```

The above output indicates that the installation completed successfully and points us to the zipped log file of the build process.

7. Now let's search for our module:

> [!NOTE]
> To make your custom modules appear in `module avail`, `module spider` etc., you can set the `$CCR_CUSTOM_BUILD_PATHS` environment variable following the instructions outlined [here](https://docs.ccr.buffalo.edu/en/latest/software/building/#building-modules-for-your-group).
> To ensure the path gets picked up on login, point it to `~/.ccr/modulepaths`.

```
module spider samtools-1.18
```

Expected output:

```
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  samtools: samtools/1.18
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    Description:
      SAM Tools provide various utilities for manipulating alignments in the SAM format, including sorting, merging, indexing and generating alignments in a per-position format.

    Properties:
      Bioinformatic libraries/apps

    You will need to load all module(s) on any one of the lines below before the "samtools/1.18" module is available to load.

      gcc/11.2.0
 
    Help:
      
      Description
      ===========
      SAM Tools provide various utilities for manipulating alignments in the SAM format, 
       including sorting, merging, indexing and generating alignments in a per-position format.
      
      
      More information
      ================
       - Homepage: https://www.htslib.org/
      
```

Load the module and look for the installation path:

```
module load gcccore/11.2.0 samtools/1.18
module show samtools/1.18
```

Expected output:

```
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   /projects/academic/[YourGroupName]/easybuild/2023.01/modules/avx512/Compiler/gcc/11.2.0/samtools/1.18.lua:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
help([[
Description
===========
SAM Tools provide various utilities for manipulating alignments in the SAM format, 
 including sorting, merging, indexing and generating alignments in a per-position format.


More information
================
 - Homepage: https://www.htslib.org/
]])
whatis("Description: SAM Tools provide various utilities for manipulating alignments in the SAM format, 
 including sorting, merging, indexing and generating alignments in a per-position format.")
whatis("Homepage: https://www.htslib.org/")
whatis("URL: https://www.htslib.org/")
conflict("samtools")
depends_on("zlib/1.2.11")
depends_on("curl/7.78.0")
...
```

Congratulations! You've just built some software!!

