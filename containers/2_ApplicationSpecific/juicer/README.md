# Example Juicer container

Juicer is a pipeline for generating and analyzing Hi-C maps. For more information and usage details, visit the [official Juicer GitHub repository](https://github.com/aidenlab/juicer).

## Pulling the container

The Juicer software can be pulled from Docker Hub to the CCR's HPC environment using Apptainer. This process follows the same steps detailed in the [introductory container example](../../0_Introductory/README.md#pulling-the-container), which you can use as a guide. Please refer to CCR's [container documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/) for more information on using Apptainer.

Log into a compute node, navigate to your project directory, and set a temporary directory for cache there.

Once ready, pull the Juicer container from Docker Hub:

```
export APPTAINER_CACHEDIR=/projects/academic/[YourGroupName]/[CCRusername]/cache
apptainer pull juicer.sif docker://arimaxiang/arima_juicer:1.6
```

After the pull completes, the Apptainer image will be saved as `juicer.sif` in your current working directory.  

> [!NOTE]
> Juicer containers are also listed on [GitHub](https://github.com/ArimaGenomics/Juicer_pipeline_containers), but CCR recommends using the pulling instructions shown here for the best compatibility with our environment.

## Running the container

With the container image pulled, you can run the Juicer software with the instructions from the GitHub repository. You can also find more detailed instructions for how to use Juicer in this [GitHub Repository](https://github.com/aidenlab/juicer/wiki/Usage).

First, you make a directory to store your `fastq` files and move your files there:
```
export OUTPUT_DIR="/projects/academic/[YourGroupName]/[CCRusername]/juicer"
mkdir -p $OUTPUT_DIR/fastq/
mv test_sample_R*.fastq.gz $OUTPUT_DIR/fastq/
```

You should also specify a directory containing your reference genome:
```
export INPUT_reference="/projects/academic/[YourGroupName]/[CCRusername]/reference"
```

Finally, you'll run `juicer.sh` with the following command. You should modify the reference files as necessary for your use case.
```
apptainer exec -B $OUTPUT_DIR -B $INPUT_reference juicer.sif juicer.sh \
-d $OUTPUT_DIR -D /opt/ \
-p $INPUT_reference/hg38.chrom.sizes \
-y $INPUT_reference/hg38_GATC_GANTC.txt \
-z $INPUT_reference/hg38.fa \
-t 20 &> $OUTPUT_DIR"/juicer.log"
```

If you need to use `HiCCUP` with a GPU when using Juicer, you will need to add the `--nv` flag to the `apptainer exec` command. More instructions on using containers with GPUs can be found in [CCR's documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/#gpu-enabled-containers-with-apptainer).

## Additional Information

- The [Placeholders](../../../README.md#placeholders) section lists the available options for each placeholder used in the example scripts.
- For more info on accessing shared project and global scratch directories, resource options, and other important container topics, please refer to the CCR [container documentation](https://docs.ccr.buffalo.edu/en/latest/howto/containerization/) 
