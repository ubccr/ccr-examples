# Example Container Workflows

This directory contains example workflows for running containers on CCR's clusters. These examples are designed to supplement our official documentation on [containerization](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/). Before using these workflows, it's important to understand the basics of containers and CCR-specific guidelines. Please refer to the full documentation for detailed instructions and best practices.

At CCR, we use Singularity/Apptainer which allows you to execute software without requiring root privilages. CCR provides some commonly used container images, but you can also build your own (from sources like DockerHub, Podman, etc.) and run them with Apptainer. CCR provides a few pre-built containers available in: `/util/software/containers`. For in-depth information about Apptainer, you can refer to the official [Apptainer documentation](https://apptainer.org/documentation/).

## Getting Started ([Introductory/](./0_Introductory/README.md))

Here we present a minimalist example of container usage in CCR's HPC environment. Python is used as an example due to it being a common software that benefits from containerization.

## Advanced Topics ([Advanced/](./1_Advanced/README.md))

Coming Soon

## Application Specific Containers ([ApplicationSpecific/](./2_ApplicationSpecific/README.md))

This directory provides container workflows tailored for specific applications (e.g., Conda, Abaqus, Juicer). Not every software package has a container example here, but a [table of available workflows](./2_ApplicationSpecific/README.md#table-of-topics) is provided for easier navigation.
