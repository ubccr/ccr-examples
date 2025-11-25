# Adding Contributions

If you have an example you think would benefit users of the CCR community, you can follow these steps to create a fork of this repository and submit a pull request for CCR staff to review:

1. [Fork this repo](https://github.com/ubccr/ccr-examples/fork)

2. Clone your fork and enter its directory:

    ```bash
    git clone https://github.com/[YourUser]/ccr-examples.git
    cd ccr-examples
    ```

3. Start adding to or updating the repository!

4. Submit a [pull request](https://github.com/ubccr/ccr-examples/pulls)

## Standards and Guidelines

Keep examples organized in respective per example directories following the established [directory structure](README.md#navigating-the-repository) and remember to apply any necessary changes to existing files (e.g., table of contents). Please do your best to align the format of your submission with the following standards:

### README Files

- Include a `README.md` file with clear and concise instructions on how to modify and reproduce the example.
- Separate your `README` into sections and clearly ennumerate steps required to reproduce the example.
- Avoid repetition by providing links to information already detailed in the [CCR documentation](https://docs.ccr.buffalo.edu/en/latest/) or other `README` files in this repository. For example, you do NOT need to explicitly provide details about [interactive jobs](https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#interactive-job-submission) and [accessing login nodes](https://docs.ccr.buffalo.edu/en/latest/hpc/login/#logging-in), or re-define [placeholders](/slurm/README.md#placeholders).
- Do not include command prompts (e.g., `$`, `>`) inside code blocks for ease of copying code. If you feel that the change of command prompt is critical to user understanding, you can indicate what the prompts look like in the text preceding the associated command.
    > Running the following command on a compute node will change your command prompt from `CCRusername@cpn-d01-06:~$` to `Apptainer>`, indicating that you're now in the Apptainer shell environment:
    >
    > ```bash
    > apptainer shell r-demo.sif
    > ```

- Only provide command outputs if they're essential to the user's understanding, and separate them into their own clearly labeled code blocks.
- Stylize any commands outside of code blocks using `code snippets`.
- Use [alerts](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#alerts) (note, warning, danger, important) to emphasize important points of your `README`. This can be particularly useful for calling out links to CCR documentation.

### Additional Files

- Include as few files as possible to avoid clutter, but be sure everything needed to reproduce the example is provided.
- Do not include large data sets, instead use `$ENV` variables to specify the path to data/supplemental files.
- File names should be descriptive and concise with appropriate extensions, using a dash `-` to separate words if necessary.
- Provide brief comments in separate lines preceding the associated code.
- Comment lines in Slurm scripts should begin with `##   ` to clearly differentiate comments and Slurm constraints.

### Use of Variables

- Use the defined [placeholders](slurm/README.md#placeholders) instead of their associated case specific values.
- Use `$SLURM` variables to specify Slurm specific information (e.g., `$SLURM_JOB_ID`, `$SLURM_NPROCS`, `$SLURM_NODEFILE`, `$SLURMTMPDIR`, `$SLURM_SUBMIT_DIR`).
- Use Unix `$ENV` variables wherever possible (e.g., `$PATH`, `$TEMP`, `$HOME`), including those specific to EasyBuild (e.g., `$EBROOT`).
- Avoid using regular expressions unless required, and briefly comment on their function if necessary.

## Reference Materials

- For a nice overview of GitHub's markdown syntax [see here](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax).
