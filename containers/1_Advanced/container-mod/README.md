# container-mod Example Workflows

This directory contains two example workflows ([`personal/`](https://github.com/ubccr/ccr-examples/tree/main/containers/1_Advanced/container-mod/personal) and [`project/`](https://github.com/ubccr/ccr-examples/tree/main/containers/1_Advanced/container-mod/project)). The `personal` workflow utilizes a container from DockerHub and runs in default (`personal`) mode. The `project` example is based on a locally stored `.sif` file and an example profile for `container-mod`. More details can be found in [CCR's documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/#container-mod) for `container-mod`.

## How to use

1. Clone the [container-mod repository](https://github.com/TuftsRT/container-mod) into your working directory.

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

For detailed information about the topics above and additional options, please refer to the official [`container-mod` README](https://github.com/TuftsRT/container-mod#usage).

2. Start an interactive job

> [!IMPORTANT]
> Apptainer is not available on the CCR login nodes and the compile nodes may not provide enough resources for you to build a container.  We recommend requesting an interactive job on a compute node to conduct this build process.<br/>
> See CCR docs for more info on [running jobs](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission).

```
salloc --cluster=ub-hpc --partition=debug --qos=debug --exclusive --time=01:00:00
```

Sample output:
```
salloc: Pending job allocation [JobID]
salloc: job [JobID] queued and waiting for resources
salloc: job [JobID] has been allocated resources
salloc: Granted job allocation [JobID]
salloc: Nodes [NodeID] are ready for job
CCRusername@[NodeID]:~$
```

3. Choose between one of the following workflows according to your use case:
- [`personal/`](https://github.com/ubccr/ccr-examples/tree/main/containers/1_Advanced/container-mod/personal)
- [`project/`](https://github.com/ubccr/ccr-examples/tree/main/containers/1_Advanced/container-mod/project)

Refer to the official `container-mod` [repository](https://github.com/TuftsRT/container-mod) for more information.
