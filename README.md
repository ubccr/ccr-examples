# CCR Examples

This repository contains examples for use on [UB CCR's](https://buffalo.edu/ccr) high performance computing clusters.  These should be used in conjuction with [CCR's documentation](https://docs.ccr.buffalo.edu) - where the concepts and policies for using CCR's systems are explained.  As a supplement to the documentation, there are recorded workshops on a variety of topics available on [CCR's YouTube channel](https://youtube.com/@ubccr) which are accessible to all users, and an [Intro to CCR course](https://ublearns.buffalo.edu/d2l/le/discovery/view/course/285151) in UB Learns for users affiliated with the University at Buffalo.  

While the repository is updated regularly, there is always a chance information contained herein is inaccurate.  Please report any issues by filing a [bug report](https://github.com/ubccr/ccr-examples/issues/new), or even better if you can correct the error, file a pull request with a fix!  Although you will see some application specific Slurm scripts or container instructions, there is not an example for every piece of software installed on CCR's systems.  Users are expected to modify existing examples for their specific application usage as appropriate.  If you have questions or run into problems using these examples, please submit a ticket to CCR Help, rather than submit an issue in Github.  

## Repository Contents

- [slurm/](slurm/README.md) - Example Slurm batch jobs
- [containers/](containers/README.md) - Examples for using containers
- [easybuild/](easybuild/README.md) - Examples for installing software with Easybuild

## Navigating the Repository

Each major example topic is separated into `0_Introductory`, `1_Advanced` and `2_ApplicationSpecific` sub-directories (some of which are coming soon!).  The `0_Introductory` directories are meant to include the most basic of examples, with the contents of `1_Advanced` directories adding complexity in a modular and widely applicable manner.  The `2_ApplicationSpecific` directories include examples that require special settings or data.

While you may find some comments in the example files themselves, you can expect to find additional information in `README` files associated with each example.  GitHub renders `README.md` files using Markdown syntax when viewed in web browsers.  This feature is leveraged throughout the repository, with hyperlinks provided for ease of navigation where applicable.  For many users, it will be easiest to parse the information in the `README` files using a web browser.

## Running Examples

In order to run any examples on the CCR clusters, the files must first be moved to an appropriate directory.  This can be done by downloading raw files to your local machine through a web browser, and then uploading them to the CCR HPC environment via a number of methods outlined in the documentation on [data transfer](https://docs.ccr.buffalo.edu/en/latest/hpc/data-transfer/).  Users may also clone the repository directly from GitHub onto CCR storage.  Please note that in some cases an example is made up of multiple files, each of which must be transferred and kept in the same relative paths to one another to run successfully.

After verifying that the desired example performs as expected when run as is, users are meant to modify the examples to suit their needs.  Information on what to modify and why can be found in associated `README` files, as well as in comments within the example files themselves.

## Cloning the Repository

Login to a CCR login node or use the terminal app in OnDemand to access a login node.  
In your `$HOME` or group's project directory, clone this repository.  
```
git clone https://github.com/ubccr/ccr-examples.git
cd ccr-examples
```
Navigate to the directory with the example that you'd like to use and copy that script to your working directory.  Modify the script as appropriate for your workflow or applications.

## Adding Contributions

If you have an example you think would benefit users of the CCR community, please refer to the [contribution guidelines](Contributions.md) for details about example formatting and content.

## License

This work is licensed under the GPLv3 license. See the LICENSE file.
