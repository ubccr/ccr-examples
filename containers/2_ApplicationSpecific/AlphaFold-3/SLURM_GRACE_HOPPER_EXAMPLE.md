# AlphaFold 3 Grace Hopper GPU Examples

## Obtain the model parameters file from Google

NOTE:
ALphaFold 3 requires a model parameters file.
You must request the file by completing the [AlphaFold 3 model parameter request form](https://forms.gle/svvpY4u2jsHEwWYS6) and agree to the software [terms of use](https://github.com/google-deepmind/alphafold3/blob/main/WEIGHTS_TERMS_OF_USE.md)

If you are granted access to the file, Google will email you a download link.

Here is an example to setup this file for use:

Change to your AlphaFold-3 directory

```
cd /projects/academic/[YourGroupName]/AlphaFold-3
```

then fetch the model parameters file:

```
curl -o af3.bin.zst [download URL]
zstd -d af3.bin.zst
rm af3.bin.zst
chmod 440 af3.bin
mkdir -p ./models/
mv af3.bin models/
chmod 550 ./models/
```


## Build the ARM64 container image

First, build the x86_64 container as per the [README.md](./README.md) since
the Data Pipeline in this example will be run on the much more readily
available x86_64 nodes (and the Data Pipeline does not use a GPU.)
Then follow the [BUILD-ARM64.md](./BUILD-ARM64.md) instructions to build AlphaFold
for ARM64


# Slurm batch job

Change to your AlphaFold-3 directory

```
cd /projects/academic/[YourGroupName]/AlphaFold-3
```

Copy the sample Slurm scripts [slurm_GH200_AlphaFold-3_Data_Pipeline_example.bash](./slurm_GH200_AlphaFold-3_Data_Pipeline_example.bash)
and [slurm_GH200_AlphaFold-3_Inference_example.bash](./slurm_GH200_AlphaFold-3_Inference_example.bash) to this directory then
modify for your use case.

You should change the SLURM cluster, partition, qos, account; and change
the `[YourGroupName]` in the cd command.
Use the `slimits` command to see what accounts and QOS settings you have access to.

For example:

```
cat slurm_GH200_AlphaFold-3_Data_Pipeline_example.bash
```

abridged sample output:

> ```
> [...]
> ## Select a cluster, partition, qos and account that is appropriate for your use case
> ## Available options and more details are provided in CCR's documentation:
> ##   https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#slurm-directives-partitions-qos
> #SBATCH --cluster="ub-hpc"
> #SBATCH --partition="debug"
> #SBATCH --qos="debug"
> #SBATCH --account="ccradmintest"
> 
> [...]
> 
> ## change to the AlphaFold-3 directory
> cd /projects/academic/ccradmintest/AlphaFold-3
> [...]
> ```

```
cat slurm_GH200_AlphaFold-3_Inference_example.bash
```

abridged sample output:

> ```
> [...]
> ## Select the account that is appropriate for your use case
> ## Available options and more details are provided in CCR's documentation:
> ##   https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#slurm-directives-partitions-qos
> #SBATCH --account="ccradmintest"
> 
> [...]
> 
> ## change to the AlphaFold-3 directory
> cd /projects/academic/ccradmintest/AlphaFold-3
> [...]
> ```

Create the input directory and file for this example:

```
mkdir -p "./af_input/2PV7"
cat > "./af_input/2PV7/fold_input.json" << EOF
{
  "name": "2PV7",
  "sequences": [
    {
      "protein": {
        "id": ["A", "B"],
        "sequence": "GMRESYANENQFGFKTINSDIHKIVIVGGYGKLGGLFARYLRASGYPISILDREDWAVAESILANADVVIVSVPINLTLETIERLKPYLTENMLLADLTSVKREPLAKMLEVHTGAVLGLHPMFGADIASMAKQVVVRCDGRFPERYEWLLEQIQIWGAKIYQTNATEHDHNMTYIQALRHFSTFANGLHLSKQPINLANLLALSSPIYRLELAMIGRLFAQDAELYADIIMDKSENLAVIETLKQTYDEALTFFENNDRQGFIDAFHKVRDWFGDYSEQFLKESRQLLQQANDLKQG"
      }
    }
  ],
  "modelSeeds": [1],
  "dialect": "alphafold3",
  "version": 1
}
EOF
```

Note that the input directory, "./af_input/2PV7" in this case, is configured in
the "slurm_AlphaFold-3_Data_Pipeline_example_dev.bash" file:

> ```
> [...]
> 
> # Set the input directory
> input_dir="./af_input/2PV7"
> 
> [...]
> ```

You only need to submit the Data Pipeline Slurm script.  If the Data Pipeline
completes without errors, it will submit the Inference script with the output
from the Data Pipeline automatically

```
sbatch ./slurm_GH200_AlphaFold-3_Data_Pipeline_example.bash
```

sample output:

> ```
> Submitted batch job 20815714 on cluster ub-hpc
> ```

The Slurm output file in this case is slurm-20815714.out
Once this Slurm job completed:

```
cat slurm-20815714.out
```

sample output:

> ```
> Running the Data Pipeline on compute node: cpn-i14-38
> 
> No GPU detected - run Data Pipeline only
> 
> I0805 21:07:39.113325 8489005757184 pipeline.py:82] Getting protein MSAs for sequence GMRESYANENQFGFKTINSDIHKIVIVGGYGKLGGLFARYLRASGYPISILDREDWAVAESILANADVVIVSVPINLTLETIERLKPYLTENMLLADLTSVKREPLAKMLEVHTGAVLGLHPMFGADIASMAKQVVVRCDGRFPERYEWLLEQIQIWGAKIYQTNATEHDHNMTYIQALRHFSTFANGLHLSKQPINLANLLALSSPIYRLELAMIGRLFAQDAELYADIIMDKSENLAVIETLKQTYDEALTFFENNDRQGFIDAFHKVRDWFGDYSEQFLKESRQLLQQANDLKQG
> I0805 21:07:39.124824 8483872749248 jackhmmer.py:85] Query sequence: GMRESYANENQFGFKT... (len 298)
> I0805 21:07:39.124971 8483876951744 jackhmmer.py:85] Query sequence: GMRESYANENQFGFKT... (len 298)
> I0805 21:07:39.125054 8483874850496 jackhmmer.py:85] Query sequence: GMRESYANENQFGFKT... (len 298)
> I0805 21:07:39.125136 8483879052992 jackhmmer.py:85] Query sequence: GMRESYANENQFGFKT... (len 298)
> I0805 21:07:39.125661 8483872749248 subprocess_utils.py:82] Launching subprocess "/hmmer/bin/jackhmmer -o /dev/null -A /scratch/20815714/tmp/tmp9y80gyso/output.sto --noali --F1 0.0005 --F2 5e-05 --F3 5e-07 --cpu 8 -N 1 -E 0.0001 --incE 0.0001 --seq_limit 50000 /scratch/20815714/tmp/tmp9y80gyso/query.fasta /util/software/data/alphafold3//uniprot_all_2021_04.fa"
> I0805 21:07:39.125741 8483876951744 subprocess_utils.py:82] Launching subprocess "/hmmer/bin/jackhmmer -o /dev/null -A /scratch/20815714/tmp/tmp9o30y50l/output.sto --noali --F1 0.0005 --F2 5e-05 --F3 5e-07 --cpu 8 -N 1 -E 0.0001 --incE 0.0001 --seq_limit 5000 /scratch/20815714/tmp/tmp9o30y50l/query.fasta /util/software/data/alphafold3//mgy_clusters_2022_05.fa"
> I0805 21:07:39.126211 8483874850496 subprocess_utils.py:82] Launching subprocess "/hmmer/bin/jackhmmer -o /dev/null -A /scratch/20815714/tmp/tmp4pmmo09i/output.sto --noali --F1 0.0005 --F2 5e-05 --F3 5e-07 --cpu 8 -N 1 -E 0.0001 --incE 0.0001 --seq_limit 5000 /scratch/20815714/tmp/tmp4pmmo09i/query.fasta /util/software/data/alphafold3//bfd-first_non_consensus_sequences.fasta"
> I0805 21:07:39.126365 8483879052992 subprocess_utils.py:82] Launching subprocess "/hmmer/bin/jackhmmer -o /dev/null -A /scratch/20815714/tmp/tmpxbhdmsp2/output.sto --noali --F1 0.0005 --F2 5e-05 --F3 5e-07 --cpu 8 -N 1 -E 0.0001 --incE 0.0001 --seq_limit 10000 /scratch/20815714/tmp/tmpxbhdmsp2/query.fasta /util/software/data/alphafold3//uniref90_2022_05.fa"
> I0805 21:09:18.979786 8483874850496 subprocess_utils.py:111] Finished Jackhmmer (bfd-first_non_consensus_sequences.fasta) in 99.853 seconds
> I0805 21:14:11.522703 8483879052992 subprocess_utils.py:111] Finished Jackhmmer (uniref90_2022_05.fa) in 392.395 seconds
> I0805 21:20:03.463367 8483872749248 subprocess_utils.py:111] Finished Jackhmmer (uniprot_all_2021_04.fa) in 744.337 seconds
> I0805 21:26:36.066916 8483876951744 subprocess_utils.py:111] Finished Jackhmmer (mgy_clusters_2022_05.fa) in 1136.941 seconds
> I0805 21:26:36.150882 8489005757184 pipeline.py:115] Getting protein MSAs took 1137.04 seconds for sequence GMRESYANENQFGFKTINSDIHKIVIVGGYGKLGGLFARYLRASGYPISILDREDWAVAESILANADVVIVSVPINLTLETIERLKPYLTENMLLADLTSVKREPLAKMLEVHTGAVLGLHPMFGADIASMAKQVVVRCDGRFPERYEWLLEQIQIWGAKIYQTNATEHDHNMTYIQALRHFSTFANGLHLSKQPINLANLLALSSPIYRLELAMIGRLFAQDAELYADIIMDKSENLAVIETLKQTYDEALTFFENNDRQGFIDAFHKVRDWFGDYSEQFLKESRQLLQQANDLKQG
> I0805 21:26:36.151124 8489005757184 pipeline.py:121] Deduplicating MSAs for sequence GMRESYANENQFGFKTINSDIHKIVIVGGYGKLGGLFARYLRASGYPISILDREDWAVAESILANADVVIVSVPINLTLETIERLKPYLTENMLLADLTSVKREPLAKMLEVHTGAVLGLHPMFGADIASMAKQVVVRCDGRFPERYEWLLEQIQIWGAKIYQTNATEHDHNMTYIQALRHFSTFANGLHLSKQPINLANLLALSSPIYRLELAMIGRLFAQDAELYADIIMDKSENLAVIETLKQTYDEALTFFENNDRQGFIDAFHKVRDWFGDYSEQFLKESRQLLQQANDLKQG
> I0805 21:26:36.175981 8489005757184 pipeline.py:134] Deduplicating MSAs took 0.02 seconds for sequence GMRESYANENQFGFKTINSDIHKIVIVGGYGKLGGLFARYLRASGYPISILDREDWAVAESILANADVVIVSVPINLTLETIERLKPYLTENMLLADLTSVKREPLAKMLEVHTGAVLGLHPMFGADIASMAKQVVVRCDGRFPERYEWLLEQIQIWGAKIYQTNATEHDHNMTYIQALRHFSTFANGLHLSKQPINLANLLALSSPIYRLELAMIGRLFAQDAELYADIIMDKSENLAVIETLKQTYDEALTFFENNDRQGFIDAFHKVRDWFGDYSEQFLKESRQLLQQANDLKQG, found 8506 unpaired sequences, 7080 paired sequences
> I0805 21:26:36.190894 8489005757184 pipeline.py:40] Getting protein templates for sequence GMRESYANENQFGFKTINSDIHKIVIVGGYGKLGGLFARYLRASGYPISILDREDWAVAESILANADVVIVSVPINLTLETIERLKPYLTENMLLADLTSVKREPLAKMLEVHTGAVLGLHPMFGADIASMAKQVVVRCDGRFPERYEWLLEQIQIWGAKIYQTNATEHDHNMTYIQALRHFSTFANGLHLSKQPINLANLLALSSPIYRLELAMIGRLFAQDAELYADIIMDKSENLAVIETLKQTYDEALTFFENNDRQGFIDAFHKVRDWFGDYSEQFLKESRQLLQQANDLKQG
> I0805 21:26:36.360739 8489005757184 subprocess_utils.py:82] Launching subprocess "/hmmer/bin/hmmbuild --informat stockholm --hand --amino /scratch/20815714/tmp/tmp58zwhtd6/output.hmm /scratch/20815714/tmp/tmp58zwhtd6/query.msa"
> I0805 21:26:37.356931 8489005757184 subprocess_utils.py:111] Finished Hmmbuild in 0.996 seconds
> I0805 21:26:37.359088 8489005757184 subprocess_utils.py:82] Launching subprocess "/hmmer/bin/hmmsearch --noali --cpu 8 --F1 0.1 --F2 0.1 --F3 0.1 -E 100 --incE 100 --domE 100 --incdomE 100 -A /scratch/20815714/tmp/tmpb8uoegmq/output.sto /scratch/20815714/tmp/tmpb8uoegmq/query.hmm /util/software/data/alphafold3/pdb_seqres_2022_09_28.fasta"
> I0805 21:27:15.256038 8489005757184 subprocess_utils.py:111] Finished Hmmsearch (pdb_seqres_2022_09_28.fasta) in 37.897 seconds
> I0805 21:27:15.731178 8489005757184 pipeline.py:52] Getting 4 protein templates took 39.54 seconds for sequence GMRESYANENQFGFKTINSDIHKIVIVGGYGKLGGLFARYLRASGYPISILDREDWAVAESILANADVVIVSVPINLTLETIERLKPYLTENMLLADLTSVKREPLAKMLEVHTGAVLGLHPMFGADIASMAKQVVVRCDGRFPERYEWLLEQIQIWGAKIYQTNATEHDHNMTYIQALRHFSTFANGLHLSKQPINLANLLALSSPIYRLELAMIGRLFAQDAELYADIIMDKSENLAVIETLKQTYDEALTFFENNDRQGFIDAFHKVRDWFGDYSEQFLKESRQLLQQANDLKQG
> 
> Running AlphaFold 3. Please note that standard AlphaFold 3 model parameters are
> only available under terms of use provided at
> https://github.com/google-deepmind/alphafold3/blob/main/WEIGHTS_TERMS_OF_USE.md.
> If you do not agree to these terms and are using AlphaFold 3 derived model
> parameters, cancel execution of AlphaFold 3 inference with CTRL-C, and do not
> use the model parameters.
> 
> 
> Running fold job 2PV7...
> Output will be written in ./af_input_inference/2PV7
> Running data pipeline...
> Running data pipeline for chain A...
> Running data pipeline for chain A took 1176.68 seconds
> Running data pipeline for chain B...
> Running data pipeline for chain B took 0.06 seconds
> Writing model input JSON to ./af_input_inference/2PV7/2PV7_data.json
> Skipping model inference...
> Fold job 2PV7 done, output written to ./af_input_inference/2PV7
> 
> Done running 1 fold jobs.
> Submitting Inference job with the input directory "./af_input_inference/2PV7"
> Submitted batch job 20815736 on cluster ub-hpc
> ```

From the last line of the above output, we can see that slurm job 20815736 was
submitted.
The output file for this job will be slurm-20815736.out
Once that job completes

```
cat slurm-20815736.out
```

sample output:

> ```
> Running the Inference on compute node: cpn-v14-17
> GPU info:
> GPU 0: NVIDIA GH200 480GB (UUID: GPU-19cc4f01-db58-d83b-e9af-3a814d9dbaeb)
> Running Inference with the input directory "./af_input_inference/2PV7"
> 
> # Setting environment variable XLA_FLAGS to work around a known XLA issue that
> # will greatly increase compilation time
> 
> export XLA_FLAGS="--xla_gpu_enable_triton_gemm=false"
> 
> # Setting environment variables for folding up to 5,120 tokens on A100 80GB
> 
> export XLA_PYTHON_CLIENT_PREALLOCATE="true"
> export XLA_CLIENT_MEM_FRACTION="0.95"
> 
> I0805 21:27:35.870015 89716103071264 xla_bridge.py:895] Unable to initialize backend 'rocm': module 'jaxlib.xla_extension' has no attribute 'GpuAllocatorConfig'
> I0805 21:27:35.922832 89716103071264 xla_bridge.py:895] Unable to initialize backend 'tpu': INTERNAL: Failed to open libtpu.so: libtpu.so: cannot open shared object file: No such file or directory
> I0805 21:27:55.446711 89716103071264 pipeline.py:173] processing 2PV7, random_seed=1
> I0805 21:27:55.632332 89716103071264 pipeline.py:266] Calculating bucket size for input with 596 tokens.
> I0805 21:27:55.632656 89716103071264 pipeline.py:272] Got bucket size 768 for input with 596 tokens, resulting in 172 padded tokens.
> 
> Running AlphaFold 3. Please note that standard AlphaFold 3 model parameters are
> only available under terms of use provided at
> https://github.com/google-deepmind/alphafold3/blob/main/WEIGHTS_TERMS_OF_USE.md.
> If you do not agree to these terms and are using AlphaFold 3 derived model
> parameters, cancel execution of AlphaFold 3 inference with CTRL-C, and do not
> use the model parameters.
> 
> Found local devices: [CudaDevice(id=0)], using device 0: cuda:0
> Building model from scratch...
> Checking that model parameters can be loaded...
> 
> Running fold job 2PV7...
> Output will be written in ./af_output/2PV7
> Skipping data pipeline...
> Writing model input JSON to ./af_output/2PV7/2PV7_data.json
> Predicting 3D structure for 2PV7 with 1 seed(s)...
> Featurising data with 1 seed(s)...
> Featurising data with seed 1.
> Featurising data with seed 1 took 6.37 seconds.
> Featurising data with 1 seed(s) took 12.74 seconds.
> Running model inference and extracting output structure samples with 1 seed(s)...
> Running model inference with seed 1...
> Running model inference with seed 1 took 56.58 seconds.
> Extracting inference results with seed 1...
> Extracting 5 inference samples with seed 1 took 0.61 seconds.
> Running model inference and extracting output structures with 1 seed(s) took 57.19 seconds.
> Writing outputs with 1 seed(s)...
> Fold job 2PV7 done, output written to ./af_output/2PV7
> 
> Done running 1 fold jobs.
> ```

Note from the above output the location of the AlphaFold run output files

```
ls -l ./af_output/2PV7
```

sample output:

> ```
> total 10592
> -rw-rw-r-- 1 [CCRusername] [CCRgroupname] 3119594 Aug  5 21:28 2PV7_confidences.json
> -rw-rw-r-- 1 [CCRusername] [CCRgroupname] 7301275 Aug  5 21:27 2PV7_data.json
> -rw-rw-r-- 1 [CCRusername] [CCRgroupname]  409731 Aug  5 21:28 2PV7_model.cif
> -rw-rw-r-- 1 [CCRusername] [CCRgroupname]     147 Aug  5 21:28 2PV7_ranking_scores.csv
> -rw-rw-r-- 1 [CCRusername] [CCRgroupname]     332 Aug  5 21:28 2PV7_summary_confidences.json
> drwxrwsr-x 2 [CCRusername] [CCRgroupname]    4096 Aug  5 21:28 seed-1_sample-0
> drwxrwsr-x 2 [CCRusername] [CCRgroupname]    4096 Aug  5 21:28 seed-1_sample-1
> drwxrwsr-x 2 [CCRusername] [CCRgroupname]    4096 Aug  5 21:28 seed-1_sample-2
> drwxrwsr-x 2 [CCRusername] [CCRgroupname]    4096 Aug  5 21:28 seed-1_sample-3
> drwxrwsr-x 2 [CCRusername] [CCRgroupname]    4096 Aug  5 21:28 seed-1_sample-4
> -rw-rw-r-- 1 [CCRusername] [CCRgroupname]   13036 Aug  5 21:28 TERMS_OF_USE.md
> ```

