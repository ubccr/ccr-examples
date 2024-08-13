# CCR Examples

This repository contains examples for use on [UB CCR's](https://buffalo.edu/ccr) high performance computing clusters.  These should be used in conjuction with [CCR's documentation](https://docs.ccr.buffalo.edu) - where the concepts and policies for using CCR's systems are explained.  As a supplement to the documentation, there are recorded workshops on a variety of topics available on [CCR's YouTube channel](https://youtube.com/@ubccr) and an [Intro to CCR course](https://ublearns.buffalo.edu/d2l/home/209035) in UB Learns.  

This repo is updated regularly though there is always a chance information contained herein is inaccurate.  Please report any issues by filing a [bug report](https://github.com/ubccr/ccr-examples/issues/new), or even better if you can correct the error, file a pull request with a fix!  Please note that although you will see some application specific Slurm scripts or container instructions, this repo does not contain an example for every piece of software installed on CCR's systems.  These application specific examples are available because they require special settings or data.  Users are expected to use the examples in the introductory section to modify for their application usage as appropriate.  If you have questions or run into problems using these examples, please submit a ticket to CCR Help, rather than submit an issue in Github.  

## Example Directories  

- slurm/ - Example slurm jobs
- scripts/ - Misc example scripts (coming soon!)  
- containers/ - Examples for using containers (coming soon!)  

## How to use the examples

Login to a CCR login node or use the terminal app in OnDemand to access a login node.  
In your $HOME or group's project directory, clone this repo.  
```
git clone https://github.com/ubccr/ccr-examples.git
cd ccr-examples  
```
Navigate to the directory with the example that you'd like to use and copy that script to your working directory.  Modify the script as appropriate for your workflow or applications.  


## Coding style, tips and conventions

- Keep examples organized in respective per example directories
- Do not include large data sets. Scripts should use ENV variables to specify
  path to data/suppl files.

## License

This work is licensed under the GPLv3 license. See the LICENSE file.
