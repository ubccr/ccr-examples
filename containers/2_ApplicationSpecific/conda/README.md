# Example conda container  

CCR does not support running Anaconda on its HPC systems natively for [these reasons](https://docs.ccr.buffalo.edu/en/latest/software/modules/#anaconda-python).  We realize many applications are only available via conda so, as an alternative, users can utilize conda in an Apptainer container. Utilizing a container for conda eliminates many of the problems it creates on our systems.  

This is not a perfect solution though and does require some technical expertise on your part as the CCR user.  We provide this information as an example for installing and creating a conda environment. You can modify these files to install the conda packages you require.  Any issues you may encounter will need to be worked out on your own.  

## Building the container  

This example provides an Apptainer definition file (`conda.def`) which lists a number of packages and installation steps so Apptainer can install these in an Ubuntu container environment.  This example also uses an environment file (`environment.yml`) to specify which conda packages to install during the build.  

For most use cases, you will only need to modify the `environment.yml` file where you'll add additional Python and conda packages to install in your environment. This example utilizes the [conda-forge environment](https://conda-forge.org/) to align with the most recent appropriate use license guidance from Anaconda.

The build process follows the same steps detailed in the [introductory container example](../../0_Introductory/README.md#pulling-the-container), which you can use as a guide. Please refer to CCR's [container documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/) for more information on using Apptainer.

Log into a compute node, navigate to your project directory, and set a temporary directory for cache there.

Once ready, build the container:

```
export APPTAINER_CACHEDIR=/projects/academic/[YourGroupName]/[CCRUsername]/cache
apptainer build conda-$(arch).sif conda.def
```

Sample output:

```
...
...
INFO:    Adding environment to container
INFO:    Creating SIF file...
INFO:    Build complete: conda.sif
```

> [!WARNING]
> Whenever you modify the `environment.yml` file to add more Python packages to install via conda or pip, you will need to rebuild your container.  

## Running the container  

Ensure you are on a compute node and that you have copied the `conda.def` and `environment.yml` files to your build directory. 

For our example, we have no additional conda packages installed.  However, we can test this container by running Python. 

Run the following command:
```
apptainer exec conda-$(arch).sif python
```

Sample output:
```
Python 3.10.16 | packaged by conda-forge | (main, Apr  8 2025, 20:53:32) [GCC 13.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>>
```

Alternatively, you can first get shell access into the container and then run Python.

Get shell access:
```
apptainer shell conda-$(arch).sif
```

Once in the container, run:
```
python
```

Sample output:
```
Python 3.10.16 | packaged by conda-forge | (main, Apr  8 2025, 20:53:32) [GCC 13.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>>
```

## Additional Information

- The [Placeholders](../../../README.md#placeholders) section lists the available options for each placeholder used in the example scripts.
- For more info on accessing shared project and global scratch directories, resource options, and other important container topics, please refer to the CCR [container documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/) 
