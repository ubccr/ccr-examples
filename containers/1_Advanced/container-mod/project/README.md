# container-mod Sample Profile Example

In this example, we'll use the Abaqus 2024 container image stored locally at `/util/software/containers/x86-64/abaqus-2024.sif`. We will use the `--profile` option with a custom profile to generate `container-mod` output files in your group's project directory, creating a ready-to-use shared Abaqus container module. This example extends the [container-mod README](https://github.com/ubccr/ccr-examples/tree/main/containers/1_Advanced/container-mod/README.md). For more information, please refer to it. 

## Creating a Custom Profile

Profiles are simple shell files stored in the `profiles/` directory. They define where `container-mod` stores generated output files and include the following:
-`MOD_EXISTING_DIR_DEF`: Directory to store the generated Lmod modulefile (`.lua`)
-`PUBLIC_IMAGEDIR`: Stores container images pulled from online registries. (Local images stay in their original location)
-`PUBLIC_EXECUTABLE_DIR`: Directory to store generated wrapper scripts
-`BIND_PATH`: Paths to bind into the container

For example, to generate output files and create a usable module for your project group [YourGroupName], create a file named `project` in the `profiles/` directory:
```
MOD_EXISTING_DIR_DEF="/projects/academic/[YourGroupName]/privatemodules"
PUBLIC_IMAGEDIR="/projects/academic/[YourGroupName]/images"
PUBLIC_EXECUTABLE_DIR="/projects/academic/[YourGroupName]/executables"
BIND_PATH="/vscratch:/vscratch,/projects:/projects"
```

## Workflow

2. To use container-mod, first make sure to request an [interactive job](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission) to utilize Apptainer.

3. Run the `container-mod` script with the `pipe` subcommand, specifying the profile, required options and the locally stored image. For example:
```
./container-mod pipe --profile project --write-to-profile-dirs --container-app apptainer /util/software/containers/x86-64/abaqus-2024.sif
```

>[!NOTE]
>Local images stay in their original location

4. If there are no software-related files beforehand (module, metadata, executable files), the script will ask the following info only once to create a new entry:

	- Application name, version, description, homepage URL 
	- Available programs: Software commands used to trigger certain behaviors (E.g., fds, abaqus, OpenSees, etc.) 

For an example metadata file, please refer to the official `container-mod` [README](https://github.com/TuftsRT/container-mod#how-it-works).

5. Once the required information is provided, `container-mod` will execute the necessary Apptainer commands on the image and automatically generate the module file and solicited wrapper scripts into the specified directories, if the main script finishes successfully.

5. To use the newly generated module, you will need to edit the `$MODULEPATH` env. variable to include the full path to the modulefile. You can do this in a few ways:

	- Use the command (Only eligible for the current session): 
	```
	module use /projects/academic/[YourGroupName]/privatemodules
	```
	- Edit the `~/.ccr/modulepaths` file to include `/projects/academic/[YourGroupName]/privatemodules`.

6. Once done, verify `Lmod` recognizes the new module with commands like `echo $MODULEPATH`, `module avail`, `module show`, etc. 

7. Load the module using `module load` and verify the software executables work as expected:
```
module load abaqus/2024
abaqus
```
