# container-mod Example Workflow

In this example, we'll use the FDS container image from [DockerHub](https://hub.docker.com/r/satcomx00/fds) and process it with container-Mod to generate a ready-to-use environment module. We will use personal mode, where all files are generated in user's `$HOME` directory. More details can be found in our [documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/#container-mod).

1. Clone the [container-Mod repository](https://github.com/TuftsRT/container-mod) into your working directory.

**Important files and their descriptions**
- `container-Mod`: Main executable script
- `repos/`: Stores all metadata for all software used by commands such as `module spider`
- `profiles/`: Stores different profiles that define where generated files are placed, instead of the default personal mode (`$HOME`)

**Generated Directories and Files (Personal Mode)**
- `~/container-apps/`: Directory created in personal that contains all files and resources used by the generated module
	a. `container-apps/images/`: Stores container images pulled from registries such as DockerHub. (Local images stay in their original location)
	b. `container-apps/repos/`: Contains metadata for all configured software, used by commands like `module spider`
	c. `container-apps/tools/`: Holds generated executables (wrapper scripts) for using specific software programs
- `~/privatemodules/`: Stores generated modulefiles (`.lua`) for Lmod

**Subcommands used with the `container-mod` script**
- `pull`: Pulls a container image into the desired directory
- `module`: Generates the module file
- `exec`: Generates wrapper scripts (subcommands for the software)
- `pipe`: Important and most useful container-mod command; runs pull, module and exec in sequence

> [!IMPORTANT]
> To use container-mod, first make sure to request an interactive job to utilize Apptainer.

2. Run the container-mod script with one of the above commands, followed by the image location. Sample command:
```
./container-mod  pipe  docker://satcomx00/fds:6.7.9
```
(You can also use local images (e.g. from /util/software/containers/), pipe will not pull the image, local images stay in their location) 

> [!NOTE]
> If no profile is selected, container-mod will run in personal mode (all related files will get generated in $HOME).

3. If container-mod doesn’t find any software-related files beforehand (module, metadata, executable files), it will ask the following info only once:
- Application name, version, description, homepage URL 
- Available programs: Software commands used to trigger certain behaviors (abaqus, OpenSees, etc.) 

4. Once info is provided, container-mod will execute Apptainer commands on the image and generate module files if script finishes successfully.

5. To use the generated modules, you will need to edit the $MODULEPATH to include the full ~/privatemodules path, and you can do this in a few ways:
- Use the command: 
```
module use ~/privatemodules (Only eligible for the current session) 
```
- Edit the ~/.ccr/modulepaths file to include the full path
- Or add the module use command in your ~/.bashrc so its gets executed at startup (use at your own risk) 

Once done, verify with commands like echo $MODULEPATH, module avail, show, spider etc. 

6. Load the module with module load and verify the software executables (software commands) work as expected. Example command:
```
module show fds/6.7.9
module load fds/6.7.9
```
