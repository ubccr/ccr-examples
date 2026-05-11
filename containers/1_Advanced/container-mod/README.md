# container-mod Example Workflow

In this example, we'll use the FDS container image from [DockerHub](https://hub.docker.com/r/satcomx00/fds) and process it with `container-mod` to generate a ready-to-use environment module. We will use personal mode, where all files are generated in the user's `$HOME` directory. More details can be found in [CCR's documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/#container-mod) for `container-mod`.

## How to use

1. Clone the [container-mod repository](https://github.com/TuftsRT/container-mod) into your working directory.

**Important files and their descriptions**
- `container-mod`: Main executable script
- `repos/`: Stores metadata for all software used by commands such as `module spider`
- `profiles/`: Stores different profiles that define where generated files are placed, instead of the default personal mode (`$HOME`)

**Subcommands used with the `container-mod` script**
- `pull`: Pulls a container image into the desired directory
- `module`: Generates the module file
- `exec`: Generates wrapper scripts (executables for specific software programs)
- `pipe`: Important and most useful container-mod command; **runs pull, module and exec in sequence**

**Generated directories and files (Personal Mode)**
- `~/privatemodules/`: Stores generated modulefiles (`.lua`) for Lmod
- `~/container-apps/`: Contains all files and resources used by the generated module
	- `container-apps/images/`: Stores container images pulled from registries such as DockerHub. (Local images stay in their original location)
	- `container-apps/repos/`: Contains metadata for all configured software, used by commands like `module spider`
	- `container-apps/tools/`: Holds generated executables (wrapper scripts) for using specific software programs

For detailed information about the topics above and the available options for use, please refer to the [official documentation](https://github.com/TuftsRT/container-mod#usage).

> [!IMPORTANT]
> To use container-mod, first make sure to request an [interactive job](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission) to utilize Apptainer.

2. Run the `container-mod` script with one of the above Subcommands, followed by the image location. For example:
```
./container-mod pipe docker://satcomx00/fds:6.7.9
```
(You can also use local images (e.g. from /util/software/containers/); local images stay in their original location) 

> [!NOTE]
> Currently, CCR only supports personal mode and cannot guarantee functionality with profiles.

3. If there are no software-related files beforehand (module, metadata, executable files), the script will ask the following info only once to create a new entry:

	- Application name, version, description, homepage URL 
	- Available programs: Software commands used to trigger certain behaviors (E.g., fds, abaqus, OpenSees, etc.) 

For an example metadata file, please refer to the official `container-mod` [README](https://github.com/TuftsRT/container-mod#how-it-works).

4. Once the required information is provided, `container-mod` will execute the necessary Apptainer commands on the image and automatically generate the module file and solicited wrapper scripts, if the main script finishes successfully.

5. To use the newly generated module, you will need to edit your `$MODULEPATH` to include: `/user/[CCRUsername]/privatemodules`. You can do this in a few ways:

	- Use the command (Only eligible for the current session): 
	```
	module use ~/privatemodules
	```
	- Edit the `~/.ccr/modulepaths` file to include `/user/[CCRUsername]/privatemodules`.

6. Once done, verify `Lmod` recognizes the new module with commands like `echo $MODULEPATH`, `module avail`, `module show`, etc. 

7. Load the module using `module load` and verify the software executables work as expected:
```
module load fds/6.7.9
fds
```

Congratulations! You've just built your own container module!! 
