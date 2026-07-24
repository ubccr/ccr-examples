# container-mod Custom Profile Example

In this example, we'll use the Abaqus 2024 container image available on CCR's storage at `/util/software/containers/x86_64/abaqus-2024.sif`. We will use the `--profile` option with a custom profile to generate `container-mod` output files in your group's project directory, creating a ready-to-use shared Abaqus container module. This example extends the [container-mod README](https://github.com/ubccr/ccr-examples/tree/main/containers/1_Advanced/container-mod/README.md). For more information, please refer to it. 

## Creating a Custom Profile

Profiles are simple shell files stored in the `profiles/` directory. They define where `container-mod` stores generated output files and include the following:
- `MOD_EXISTING_DIR_DEF`: Directory to store the generated Lmod modulefile (`.lua`)
- `PUBLIC_IMAGEDIR`: Stores container images pulled from online registries. (Local images stay in their original location)
- `PUBLIC_EXECUTABLE_DIR`: Directory to store generated wrapper scripts
- `BIND_PATH`: Paths to bind into the container

For example, to generate output files and create a usable module for your project group (`[YourGroupName]`), create a file named `project` in the `profiles/` directory, containing:
```
MOD_EXISTING_DIR_DEF="/projects/academic/[YourGroupName]/privatemodules"
PUBLIC_IMAGEDIR="/projects/academic/[YourGroupName]/images"
PUBLIC_EXECUTABLE_DIR="/projects/academic/[YourGroupName]/executables"
BIND_PATH="/vscratch/grp-[YourGroupName]:/vscratch/grp-[YourGroupName],/projects/academic/[YourGroupName]:/projects/academic/[YourGroupName],/scratch:/scratch,/util:/util"
```
NOTE: Not all project directories are in `/projects/academic`  Please refer to our [documentation](https://docs.ccr.buffalo.edu/en/latest/hpc/storage/#enterprise-level-network-attached-storage) for a list of all storage options.

## Workflow

1. If you haven't already done so, follow the [Getting Started](../README.md) instructions.

2. To use container-mod, first make sure to request an [interactive job](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission) to utilize Apptainer as it isn't installed on the login nodes.

3. Run the `container-mod` script with the `pipe` subcommand, specifying the profile named "project," required options, and the locally stored image. For example:
```
./container-mod pipe --profile project --write-to-profile-dirs --container-app apptainer /util/software/containers/x86_64/abaqus-2024.sif
```

>[!NOTE]
>Local images stay in their original location

4. If there are no `container-mod` files previously created for the software you're setting up (module, metadata, executable files), the script will ask the following info to create a new entry:

	- Application name, version, description, homepage URL 
	- Available programs: Software commands used to trigger certain behaviors (E.g., fds, abaqus, OpenSees, etc.)
For this example, we use this information:
```
Loading system profile: project
Initializing...
'abaqus' not found in application info database.
Let's create a new entry...
Enter a simple description of the application: Abaqus Finite Element Analysis Suite
Enter the application's homepage URL: https://discover.3ds.com/
Enter the available programs (comma-separated): abaqus, abq2024
Local image file detected: /util/software/containers/x86_64/abaqus-2024.sif
[...]
```
For an example metadata file, please refer to the official `container-mod` [documentation](https://github.com/TuftsRT/container-mod#how-it-works).

5. Once the required information is provided, `container-mod` will automatically generate the module file and solicited wrapper scripts into the directories specified in your `project` profile file.

6. In order to use the newly generated module, the path the modules are stored, must be in your environment.  Make sure you've completed step 3 in the [Getting Started](../README.md) instructions.

7. Load the module using `module load` and verify the software executables work as expected:
```
module load abaqus/2024
abaqus
```
