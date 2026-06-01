# container-mod Personal Mode Example

In this example, we'll use the FDS container image from [DockerHub](https://hub.docker.com/r/satcomx00/fds) and process it with `container-mod` to generate a ready-to-use environment module. We will use personal mode, where all files are generated in the user's `$HOME` directory. This example extends the [container-mod README](https://github.com/ubccr/ccr-examples/tree/main/containers/1_Advanced/container-mod/README.md). For more information, please refer to it.

**Generated directories and files in Personal Mode**
- `~/privatemodules/`: Stores generated modulefiles (`.lua`) for Lmod
- `~/container-apps/`: Contains all files and resources used by the generated module
	- `container-apps/images/`: Stores container images pulled from registries such as DockerHub.
	- `container-apps/repos/`: Contains metadata for all configured software, used by commands like `module spider`
	- `container-apps/tools/`: Holds generated executables (wrapper scripts) for using specific software programs

2. To use container-mod, first make sure to request an [interactive job](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission) to utilize Apptainer.

3. Run the `container-mod` script with the `pipe` subcommand, followed by the image location. For example:
```
./container-mod pipe docker://satcomx00/fds:6.7.9
```

4. If there are no software-related files beforehand (module, metadata, executable files), the script will ask the following info only once to create a new entry:

	- Application name, version, description, homepage URL 
	- Available programs: Software commands used to trigger certain behaviors (E.g., fds, abaqus, OpenSees, etc.) 

For an example metadata file, please refer to the official `container-mod` [README](https://github.com/TuftsRT/container-mod#how-it-works).

4. Once the required information is provided, `container-mod` will execute the necessary Apptainer commands on the image and automatically generate the module file and requested wrapper scripts for programs, if the main script finishes successfully.

5. To use the newly generated module, you will need to edit the `$MODULEPATH` env. variable to include the full path to the modulefile (`/user/[CCRUsername]/privatemodules`). You can do this in a few ways:

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
