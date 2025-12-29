# Example R Job

Provided is an example R Slurm batch job [R_01.bash](./R_01.bash), including an R script [ex.edgeR](./ex.edgeR) for differential gene expression analysis, and an example RNA-seq data matrix from 36 
samples [edgeR_input.txt](./edgeR_input.txt) for testing.

To run the R script, put the 3 files in the same directory and simply submit the job to the scheduler from a login node with the following command:
```
sbatch R_01.bash
```

This job produces three output files: 
- `R_DEG.txt`:- Contains differentially expressed genes 
- `R_CPM.txt`:- Normalized count per million
- `R_plot.eps`:- Figures for the input data
