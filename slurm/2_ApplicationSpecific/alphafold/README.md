# Example AlphaFold job

Provided is an example AlphaFold Slurm batch job [alpha-fold-test.bash](./alpha-fold-test.bash) and example protein sequence data [T11050.fasta](./T1050.fasta) for validation and testing.

Notes on running AlphaFold:

- AlphaFold does not currently support NVidia H100 cards. So you'll want to use any of our A100 or V100 GPU nodes.
- CCR has downloaded the full genetic databases and model parameters, which are automatically included when running `run_alphafold.py`. The full path can be found here:
    ```
    echo $ALPHAFOLD_DATA_DIR
    /util/software/data/alphafold
    ```
- Many of the examples you'll find online run AlphaFold in Docker. You do not want to do this. In such examples, substitute `python3 docker/run_docker.py` with the script provided by the AlphFold module `run_alphafold.py`. They will have the same CLI arguments.
