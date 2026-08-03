# container-mod Example Workflows

This directory contains two example \`container-mod\` workflows: [`personal/`](https://github.com/ubccr/ccr-examples/tree/main/containers/1_Advanced/container-mod/personal)  - with files saved in your home directory - and [`project/`](https://github.com/ubccr/ccr-examples/tree/main/containers/1_Advanced/container-mod/project) - with files saved in your group's projects directory. The example of the `personal` workflow utilizes an FDS container from DockerHub and runs in default (`--personal`) mode. The example of the `project` workflow is based on a locally stored `.sif` file and an example profile and uses the `--profile` mode for `container-mod`. More details can be found in [CCR's documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/#container-mod) for `container-mod`.

## Getting Started

1. If you choose to run `container-mod` in `personal` mode, change directory into your home directory.  If you choose to setup `container-mod` for your group to use, change directory into your group's project directory.  Then [clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) the [container-mod repository](https://github.com/TuftsRT/container-mod) into your working directory:
```
git clone https://github.com/TuftsRT/container-mod
```

**Important files and directories**
- `container-mod`: Main executable script
- `repos/`: Stores metadata for all software. Used by commands like `module spider`
- `profiles/`: Stores different profiles that define where output files are generated (instead of the default `personal` mode)

**Subcommands used with the `container-mod` script**
- `pull`: Pulls a container image into the desired directory
- `module`: Generates the module file
- `exec`: Generates wrapper scripts (executables for specific software programs)
- `pipe`: **Most useful container-mod command**; Runs pull, module and exec in sequence

**Useful Options**
- `--profile`: Loads the specified profile stored in `profiles/`
- `--write-to-profile-dirs`: Writes output to the directories from the profile, rather than the profile defaults
- `-c, --container-app`: Used to explicitly specify the container application, `apptainer` in our case
- `-j, --jupyter`: Creates a Jupyter kernel for the containerized software, if compatible
- `-h, --help`: For built-in help

For detailed information about the topics above and additional options, please refer to the official [`container-mod` documentation](https://github.com/TuftsRT/container-mod#usage).

2. Follow the example for the workflow that aligns with your use case:  
- [`personal/`](https://github.com/ubccr/ccr-examples/tree/main/containers/1_Advanced/container-mod/personal) - `--personal` mode
- [`project/`](https://github.com/ubccr/ccr-examples/tree/main/containers/1_Advanced/container-mod/project) - `--profile` mode

3. Add your module path to your environment
In order to see the modules you generate with `container-mod` you need to point your account to the path where the modules are stored.  You can do this each time you want to run these modules by first running this for `--personal` mode:	
```
module use ~/privatemodules
```
or this for `--profile` mode:
```
module use /projects/academic/[YourGroupName]/privatemodules
```
However, this is forgotten on logout and you'd need to specify this in your Slurm batch scripts whenever you run jobs.

To update the $PATH environment persistently and for each login & job submission, edit the `~/.ccr/modulepaths` file:  

For `--personal` mode, add the following:  
```
/user/[CCRUsername]/privatemodules
```

For `--profile` mode, add the following:
```
/projects/academic/[YourGroupName]/privatemodules
```
**With either option, make sure to LOGOUT and back in again to see the change.**

4. Once done, verify `Lmod` recognizes the new module with commands like `echo $MODULEPATH`, `module avail`, `module show`, etc.

Refer to the official [container-mod documentation](https://tuftsrtcontainer-mod.readthedocs.io/en/latest/index.html) for more information.
