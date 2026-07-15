# AlphaFold 3 Examples

## Initial example

Change to your AlphaFold-3 directory

```
cd /projects/academic/[YourGroupName]/AlphaFold-3
```

Copy the sample Slurm scripts [slurm_AlphaFold-3_Data_Pipeline_example.bash](./slurm_AlphaFold-3_Data_Pipeline_example.bash)
and [slurm_AlphaFold-3_Inference_example.bash](./slurm_AlphaFold-3_Inference_example.bash) to this directory then modify
for your use case.

You should change the SLURM cluster, partition, qos and account; then change
the `[YourGroupName]` in the cd command.
Use the `slimits` command to see what accounts and QOS settings you have access to.

Make these changes in BOTH Slurm scripts

for example:

```
cat slurm_AlphaFold-3_Data_Pipeline_example.bash
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
cat slurm_AlphaFold-3_Inference_example.bash
```

abridged sample output:

> ```
> [...]
> ## Select a cluster, partition, qos and account that is appropriate for your use case
> ## Available options and more details are provided in CCR's documentation:
> ##   https://docs.ccr.buffalo.edu/en/latest/hpc/jobs/#slurm-directives-partitions-qos
> #SBATCH --cluster="ub-hpc"
> #SBATCH --partition="general-compute"
> #SBATCH --qos="general-compute"
> #SBATCH --account="ccradmintest"
> 
> [...]
> 
> ## change to the AlphaFold-3 directory
> cd /projects/academic/ccradmintest/AlphaFold-3
> [...]
> ```

Note that the partition/qos combination does not have to be the same for the
Data Pipeline and Inference scripts.

NOTE: You can add other Slurm options to either script.
For example, if you want the Inference to run on an H100 GPU (with 80GB RAM)
add the following to (only) the Inference script, "slurm_AlphaFold-3_Inference_example.bash"

> ```
> #SBATCH --constraint="H100"
> ```

Note: This option was used in the test that follows<br>

Make sure the top level input & output dirs exist:

```
mkdir -p ./af_input ./af_input_inference ./af_output
```

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
completes wthout errors, it will submit the Inference script with the output
from the Data Pipeline automatically

```
sbatch ./slurm_AlphaFold-3_Data_Pipeline_example.bash
```

The Slurm output file should look something like this:

> ```
> Running the Data Pipeline on compute node: [NodeID]
> 
> No GPU detected - run Data Pipeline only
> 
> I0805 10:36:24.853754 6790963843840 pipeline.py:82] Getting protein MSAs for sequence GMRESYANENQFGFKTINSDIHKIVIVGGYGKLGGLFARYLRASGYPISILDREDWAVAESILANADVVIVSVPINLTLETIERLKPYLTENMLLADLTSVKREPLAKMLEVHTGAVLGLHPMFGADIASMAKQVVVRCDGRFPERYEWLLEQIQIWGAKIYQTNATEHDHNMTYIQALRHFSTFANGLHLSKQPINLANLLALSSPIYRLELAMIGRLFAQDAELYADIIMDKSENLAVIETLKQTYDEALTFFENNDRQGFIDAFHKVRDWFGDYSEQFLKESRQLLQQANDLKQG
> I0805 10:36:24.878905 6787543320256 jackhmmer.py:85] Query sequence: GMRESYANENQFGFKT... (len 298)
> I0805 10:36:24.879051 6787545421504 jackhmmer.py:85] Query sequence: GMRESYANENQFGFKT... (len 298)
> I0805 10:36:24.879122 6787547522752 jackhmmer.py:85] Query sequence: GMRESYANENQFGFKT... (len 298)
> I0805 10:36:24.879186 6787549624000 jackhmmer.py:85] Query sequence: GMRESYANENQFGFKT... (len 298)
> I0805 10:36:24.879884 6787543320256 subprocess_utils.py:82] Launching subprocess "/hmmer/bin/jackhmmer -o /dev/null -A /scratch/20805694/tmp/tmpp127ax5b/output.sto --noali --F1 0.0005 --F2 5e-05 --F3 5e-07 --cpu 8 -N 1 -E 0.0001 --incE 0.0001 --seq_limit 50000 /scratch/20805694/tmp/tmpp127ax5b/query.fasta /util/software/data/alphafold3//uniprot_all_2021_04.fa"
> I0805 10:36:24.880042 6787547522752 subprocess_utils.py:82] Launching subprocess "/hmmer/bin/jackhmmer -o /dev/null -A /scratch/20805694/tmp/tmpkgzoqlu5/output.sto --noali --F1 0.0005 --F2 5e-05 --F3 5e-07 --cpu 8 -N 1 -E 0.0001 --incE 0.0001 --seq_limit 5000 /scratch/20805694/tmp/tmpkgzoqlu5/query.fasta /util/software/data/alphafold3//mgy_clusters_2022_05.fa"
> I0805 10:36:24.880117 6787545421504 subprocess_utils.py:82] Launching subprocess "/hmmer/bin/jackhmmer -o /dev/null -A /scratch/20805694/tmp/tmpapn63i37/output.sto --noali --F1 0.0005 --F2 5e-05 --F3 5e-07 --cpu 8 -N 1 -E 0.0001 --incE 0.0001 --seq_limit 5000 /scratch/20805694/tmp/tmpapn63i37/query.fasta /util/software/data/alphafold3//bfd-first_non_consensus_sequences.fasta"
> I0805 10:36:24.880393 6787549624000 subprocess_utils.py:82] Launching subprocess "/hmmer/bin/jackhmmer -o /dev/null -A /scratch/20805694/tmp/tmprpsdj_fi/output.sto --noali --F1 0.0005 --F2 5e-05 --F3 5e-07 --cpu 8 -N 1 -E 0.0001 --incE 0.0001 --seq_limit 10000 /scratch/20805694/tmp/tmprpsdj_fi/query.fasta /util/software/data/alphafold3//uniref90_2022_05.fa"
> I0805 10:40:09.809246 6787545421504 subprocess_utils.py:111] Finished Jackhmmer (bfd-first_non_consensus_sequences.fasta) in 224.927 seconds
> I0805 10:51:38.219908 6787549624000 subprocess_utils.py:111] Finished Jackhmmer (uniref90_2022_05.fa) in 913.336 seconds
> I0805 10:57:13.377185 6787543320256 subprocess_utils.py:111] Finished Jackhmmer (uniprot_all_2021_04.fa) in 1248.497 seconds
> I0805 11:05:02.818686 6787547522752 subprocess_utils.py:111] Finished Jackhmmer (mgy_clusters_2022_05.fa) in 1717.938 seconds
> I0805 11:05:02.955891 6790963843840 pipeline.py:115] Getting protein MSAs took 1718.10 seconds for sequence GMRESYANENQFGFKTINSDIHKIVIVGGYGKLGGLFARYLRASGYPISILDREDWAVAESILANADVVIVSVPINLTLETIERLKPYLTENMLLADLTSVKREPLAKMLEVHTGAVLGLHPMFGADIASMAKQVVVRCDGRFPERYEWLLEQIQIWGAKIYQTNATEHDHNMTYIQALRHFSTFANGLHLSKQPINLANLLALSSPIYRLELAMIGRLFAQDAELYADIIMDKSENLAVIETLKQTYDEALTFFENNDRQGFIDAFHKVRDWFGDYSEQFLKESRQLLQQANDLKQG
> I0805 11:05:02.956161 6790963843840 pipeline.py:121] Deduplicating MSAs for sequence GMRESYANENQFGFKTINSDIHKIVIVGGYGKLGGLFARYLRASGYPISILDREDWAVAESILANADVVIVSVPINLTLETIERLKPYLTENMLLADLTSVKREPLAKMLEVHTGAVLGLHPMFGADIASMAKQVVVRCDGRFPERYEWLLEQIQIWGAKIYQTNATEHDHNMTYIQALRHFSTFANGLHLSKQPINLANLLALSSPIYRLELAMIGRLFAQDAELYADIIMDKSENLAVIETLKQTYDEALTFFENNDRQGFIDAFHKVRDWFGDYSEQFLKESRQLLQQANDLKQG
> I0805 11:05:02.997448 6790963843840 pipeline.py:134] Deduplicating MSAs took 0.04 seconds for sequence GMRESYANENQFGFKTINSDIHKIVIVGGYGKLGGLFARYLRASGYPISILDREDWAVAESILANADVVIVSVPINLTLETIERLKPYLTENMLLADLTSVKREPLAKMLEVHTGAVLGLHPMFGADIASMAKQVVVRCDGRFPERYEWLLEQIQIWGAKIYQTNATEHDHNMTYIQALRHFSTFANGLHLSKQPINLANLLALSSPIYRLELAMIGRLFAQDAELYADIIMDKSENLAVIETLKQTYDEALTFFENNDRQGFIDAFHKVRDWFGDYSEQFLKESRQLLQQANDLKQG, found 8506 unpaired sequences, 7080 paired sequences
> I0805 11:05:03.016971 6790963843840 pipeline.py:40] Getting protein templates for sequence GMRESYANENQFGFKTINSDIHKIVIVGGYGKLGGLFARYLRASGYPISILDREDWAVAESILANADVVIVSVPINLTLETIERLKPYLTENMLLADLTSVKREPLAKMLEVHTGAVLGLHPMFGADIASMAKQVVVRCDGRFPERYEWLLEQIQIWGAKIYQTNATEHDHNMTYIQALRHFSTFANGLHLSKQPINLANLLALSSPIYRLELAMIGRLFAQDAELYADIIMDKSENLAVIETLKQTYDEALTFFENNDRQGFIDAFHKVRDWFGDYSEQFLKESRQLLQQANDLKQG
> I0805 11:05:03.273522 6790963843840 subprocess_utils.py:82] Launching subprocess "/hmmer/bin/hmmbuild --informat stockholm --hand --amino /scratch/20805694/tmp/tmpcw7krwgn/output.hmm /scratch/20805694/tmp/tmpcw7krwgn/query.msa"
> I0805 11:05:04.825027 6790963843840 subprocess_utils.py:111] Finished Hmmbuild in 1.551 seconds
> I0805 11:05:04.828296 6790963843840 subprocess_utils.py:82] Launching subprocess "/hmmer/bin/hmmsearch --noali --cpu 8 --F1 0.1 --F2 0.1 --F3 0.1 -E 100 --incE 100 --domE 100 --incdomE 100 -A /scratch/20805694/tmp/tmpfocepdta/output.sto /scratch/20805694/tmp/tmpfocepdta/query.hmm /util/software/data/alphafold3/pdb_seqres_2022_09_28.fasta"
> I0805 11:05:56.838551 6790963843840 subprocess_utils.py:111] Finished Hmmsearch (pdb_seqres_2022_09_28.fasta) in 52.010 seconds
> I0805 11:05:57.469995 6790963843840 pipeline.py:52] Getting 4 protein templates took 54.45 seconds for sequence GMRESYANENQFGFKTINSDIHKIVIVGGYGKLGGLFARYLRASGYPISILDREDWAVAESILANADVVIVSVPINLTLETIERLKPYLTENMLLADLTSVKREPLAKMLEVHTGAVLGLHPMFGADIASMAKQVVVRCDGRFPERYEWLLEQIQIWGAKIYQTNATEHDHNMTYIQALRHFSTFANGLHLSKQPINLANLLALSSPIYRLELAMIGRLFAQDAELYADIIMDKSENLAVIETLKQTYDEALTFFENNDRQGFIDAFHKVRDWFGDYSEQFLKESRQLLQQANDLKQG
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
> Running data pipeline for chain A took 1772.73 seconds
> Running data pipeline for chain B...
> Running data pipeline for chain B took 0.11 seconds
> Writing model input JSON to ./af_input_inference/2PV7/2PV7_data.json
> Skipping model inference...
> Fold job 2PV7 done, output written to ./af_input_inference/2PV7
> 
> Done running 1 fold jobs.
> Submitting Inference job with the input directory "./af_input_inference/2PV7"
> Submitted batch job 20805762 on cluster ub-hpc
> ```

From the last line of the above output, we can see that slurm job 20805762 was
submitted.
The output file for this job will be slurm-20805762.out
Once that job completes

```
cat slurm-[JobID].out
```

sample output:

> ```
> Running the Inference on compute node: cpn-i14-33
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
> I0805 13:04:15.381234 16599081943808 xla_bridge.py:895] Unable to initialize backend 'rocm': module 'jaxlib.xla_extension' has no attribute 'GpuAllocatorConfig'
> I0805 13:04:15.411177 16599081943808 xla_bridge.py:895] Unable to initialize backend 'tpu': INTERNAL: Failed to open libtpu.so: libtpu.so: cannot open shared object file: No such file or directory
> I0805 13:13:48.549352 16599081943808 pipeline.py:173] processing 2PV7, random_seed=1
> I0805 13:13:48.703739 16599081943808 pipeline.py:266] Calculating bucket size for input with 596 tokens.
> I0805 13:13:48.703937 16599081943808 pipeline.py:272] Got bucket size 768 for input with 596 tokens, resulting in 172 padded tokens.
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
> Featurising data with seed 1 took 7.84 seconds.
> Featurising data with 1 seed(s) took 16.27 seconds.
> Running model inference and extracting output structure samples with 1 seed(s)...
> Running model inference with seed 1...
> Running model inference with seed 1 took 69.94 seconds.
> Extracting inference results with seed 1...
> Extracting 5 inference samples with seed 1 took 0.70 seconds.
> Running model inference and extracting output structures with 1 seed(s) took 70.64 seconds.
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
> total 10593
> -rw-rw-r-- 1 [CCRusername] [CCRgroupname] 3120215 Aug  5 13:15 2PV7_confidences.json
> -rw-rw-r-- 1 [CCRusername] [CCRgroupname] 7301275 Aug  5 13:13 2PV7_data.json
> -rw-rw-r-- 1 [CCRusername] [CCRgroupname]  409731 Aug  5 13:15 2PV7_model.cif
> -rw-rw-r-- 1 [CCRusername] [CCRgroupname]     146 Aug  5 13:15 2PV7_ranking_scores.csv
> -rw-rw-r-- 1 [CCRusername] [CCRgroupname]     332 Aug  5 13:15 2PV7_summary_confidences.json
> drwxrwsr-x 2 [CCRusername] [CCRgroupname]    4096 Aug  5 13:15 seed-1_sample-0
> drwxrwsr-x 2 [CCRusername] [CCRgroupname]    4096 Aug  5 13:15 seed-1_sample-1
> drwxrwsr-x 2 [CCRusername] [CCRgroupname]    4096 Aug  5 13:15 seed-1_sample-2
> drwxrwsr-x 2 [CCRusername] [CCRgroupname]    4096 Aug  5 13:15 seed-1_sample-3
> drwxrwsr-x 2 [CCRusername] [CCRgroupname]    4096 Aug  5 13:15 seed-1_sample-4
> -rw-rw-r-- 1 [CCRusername] [CCRgroupname]   13036 Aug  5 13:15 TERMS_OF_USE.md
> ```


