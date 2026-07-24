# container-mod Personal Mode Example

In this example, we'll use the FDS container image from [DockerHub](https://hub.docker.com/r/satcomx00/fds) and process it with `container-mod` to generate a ready-to-use environment module. We will use the default (`personal`) mode, where all files are generated in the user's `$HOME` directory. This example extends the [container-mod example README](https://github.com/ubccr/ccr-examples/tree/main/containers/1_Advanced/container-mod/README.md). For more information, please refer to it.

**Generated directories and files in Personal Mode**
- `~/privatemodules/`: Stores generated modulefiles (`.lua`) for Lmod
- `~/container-apps/`: Contains all files and resources used by the generated module
	- `container-apps/images/`: Stores container images pulled from registries such as DockerHub.
	- `container-apps/repos/`: Contains metadata for all configured software, used by commands like `module spider`
	- `container-apps/tools/`: Holds generated executables (wrapper scripts) for using specific software programs

## Workflow

1. If you haven't already done so, follow the [Getting Started](../README.md) instructions.

2. To use container-mod, first make sure to request an [interactive job](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission) to utilize Apptainer as it is not installed on the login nodes.

3. From the `container-mod` installation directory, run the `container-mod` script with the `pipe` subcommand, followed by the image location. For example:
```
./container-mod pipe --container-app apptainer docker://satcomx00/fds:6.7.9
```
4. If there are no `container-mod` files previously created for the software you're setting up (e.g. module, metadata, executable files), the script will ask the following info to create a new entry:

	- Application name, version, description, homepage URL 
	- Available programs: Software commands used to trigger certain behaviors (E.g., fds, abaqus, OpenSees, etc.)

For this example, we use this information:
 ```
 No profile specified. Running in personal mode.
 Initializing...
'fds' not found in application info database.
Let's create a new entry...
Enter a simple description of the application: Fire Dynamics Simulator
Enter the application's homepage URL: https://pages.nist.gov/fds-smv/
Enter the available programs (comma-separated): fds, fds.sh, fds_openmp, fds2ascii, test_mpi
  ```

For an example metadata file, please refer to the official `container-mod` [documentation](https://github.com/TuftsRT/container-mod#how-it-works).

5. Once the required information is provided, `container-mod` will use Apptainer to pull the image from the website you provided and automatically generate the module file and requested wrapper scripts for the executables associated with the software application.

6. In order to use the newly generated module, the path the modules are stored, must be in your environment.  Make sure you've completed step 3 in the [Getting Started](../README.md) instructions.

7. Load the module using `module load` and verify the software executable works as expected:
```
module load fds/6.7.9
fds_openmp
```
