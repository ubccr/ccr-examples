# AlphaFold 3 Examples

## Initial example

Change to your AlphaFold-3 directory

```
cd /projects/academic/[YourGroupName]/AlphaFold-3
```

Then create the sample `fold_input.json` from [the github example](https://github.com/google-deepmind/alphafold3?tab=readme-ov-file#installation-and-running-your-first-prediction)

```
mkdir -p ./af_input ./af_input_inference ./af_output
cat > ./af_input/fold_input.json << EOF
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

Allocate a (non GPU) node for the Data Pipeline

```
salloc --partition=general-compute --qos=general-compute --nodes=1 --tasks-per-node=1 --cpus-per-task=32 --exclusive --mem=0
```

Change to your AlphaFold-3 directory

```
cd /projects/academic/[YourGroupName]/AlphaFold-3
```

Then run the AlphaFold-3 container:

```
apptainer shell \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 ./AlphaFold-3-$(arch).sif
```

sample output:

> ```
> 
> No GPU detected - run Data Pipeline only"
> 
> ```

From the "Apptainer>" prompt, run the AlphaFold Data Pipeline

```
python3 "/app/alphafold/run_alphafold.py" \
 --db_dir="/util/software/data/alphafold3/" \
 --model_dir="./models" \
 --input_dir="./af_input" \
 --force_output_dir \
 --output_dir="./af_input_inference" \
 --run_data_pipeline \
 --norun_inference
```

sample output:

> ```
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
> Output will be written in ./af_output/2PV7
> Running data pipeline...
> Running data pipeline for chain A...
> I0801 11:56:02.812026 12994031186688 pipeline.py:82] Getting protein MSAs for sequence GMRESYANENQFGFKTINSDIHKIVIVGGYGKLGGLFARYLRASGYPISILDREDWAVAESILANADVVIVSVPINLTLETIERLKPYLTENMLLADLTSVKREPLAKMLEVHTGAVLGLHPMFGADIASMAKQVVVRCDGRFPERYEWLLEQIQIWGAKIYQTNATEHDHNMTYIQALRHFSTFANGLHLSKQPINLANLLALSSPIYRLELAMIGRLFAQDAELYADIIMDKSENLAVIETLKQTYDEALTFFENNDRQGFIDAFHKVRDWFGDYSEQFLKESRQLLQQANDLKQG
> I0801 11:56:02.823610 12990619055808 jackhmmer.py:85] Query sequence: GMRESYANENQFGFKT... (len 298)
> I0801 11:56:02.823754 12990616954560 jackhmmer.py:85] Query sequence: GMRESYANENQFGFKT... (len 298)
> I0801 11:56:02.823838 12990614853312 jackhmmer.py:85] Query sequence: GMRESYANENQFGFKT... (len 298)
> I0801 11:56:02.823915 12990612752064 jackhmmer.py:85] Query sequence: GMRESYANENQFGFKT... (len 298)
> I0801 11:56:02.824559 12990619055808 subprocess_utils.py:82] Launching subprocess "/hmmer/bin/jackhmmer -o /dev/null -A /scratch/8114/tmp/tmpei6515_l/output.sto --noali --F1 0.0005 --F2 5e-05 --F3 5e-07 --cpu 8 -N 1 -E 0.0001 --incE 0.0001 --seq_limit 10000 /scratch/8114/tmp/tmpei6515_l/query.fasta /util/software/data/alphafold3//uniref90_2022_05.fa"
> I0801 11:56:02.824636 12990616954560 subprocess_utils.py:82] Launching subprocess "/hmmer/bin/jackhmmer -o /dev/null -A /scratch/8114/tmp/tmpbr9alhtx/output.sto --noali --F1 0.0005 --F2 5e-05 --F3 5e-07 --cpu 8 -N 1 -E 0.0001 --incE 0.0001 --seq_limit 5000 /scratch/8114/tmp/tmpbr9alhtx/query.fasta /util/software/data/alphafold3//mgy_clusters_2022_05.fa"
> I0801 11:56:02.824855 12990614853312 subprocess_utils.py:82] Launching subprocess "/hmmer/bin/jackhmmer -o /dev/null -A /scratch/8114/tmp/tmpfgih3e50/output.sto --noali --F1 0.0005 --F2 5e-05 --F3 5e-07 --cpu 8 -N 1 -E 0.0001 --incE 0.0001 --seq_limit 5000 /scratch/8114/tmp/tmpfgih3e50/query.fasta /util/software/data/alphafold3//bfd-first_non_consensus_sequences.fasta"
> I0801 11:56:02.825290 12990612752064 subprocess_utils.py:82] Launching subprocess "/hmmer/bin/jackhmmer -o /dev/null -A /scratch/8114/tmp/tmpjaczu4t3/output.sto --noali --F1 0.0005 --F2 5e-05 --F3 5e-07 --cpu 8 -N 1 -E 0.0001 --incE 0.0001 --seq_limit 50000 /scratch/8114/tmp/tmpjaczu4t3/query.fasta /util/software/data/alphafold3//uniprot_all_2021_04.fa"
> I0801 11:59:01.002737 12990614853312 subprocess_utils.py:111] Finished Jackhmmer (bfd-first_non_consensus_sequences.fasta) in 178.177 seconds
> I0801 12:09:08.993300 12990619055808 subprocess_utils.py:111] Finished Jackhmmer (uniref90_2022_05.fa) in 786.168 seconds
> I0801 12:14:39.616684 12990612752064 subprocess_utils.py:111] Finished Jackhmmer (uniprot_all_2021_04.fa) in 1116.791 seconds
> I0801 12:18:38.732069 12990616954560 subprocess_utils.py:111] Finished Jackhmmer (mgy_clusters_2022_05.fa) in 1355.907 seconds
> I0801 12:18:38.856284 12994031186688 pipeline.py:115] Getting protein MSAs took 1356.04 seconds for sequence GMRESYANENQFGFKTINSDIHKIVIVGGYGKLGGLFARYLRASGYPISILDREDWAVAESILANADVVIVSVPINLTLETIERLKPYLTENMLLADLTSVKREPLAKMLEVHTGAVLGLHPMFGADIASMAKQVVVRCDGRFPERYEWLLEQIQIWGAKIYQTNATEHDHNMTYIQALRHFSTFANGLHLSKQPINLANLLALSSPIYRLELAMIGRLFAQDAELYADIIMDKSENLAVIETLKQTYDEALTFFENNDRQGFIDAFHKVRDWFGDYSEQFLKESRQLLQQANDLKQG
> I0801 12:18:38.856518 12994031186688 pipeline.py:121] Deduplicating MSAs for sequence GMRESYANENQFGFKTINSDIHKIVIVGGYGKLGGLFARYLRASGYPISILDREDWAVAESILANADVVIVSVPINLTLETIERLKPYLTENMLLADLTSVKREPLAKMLEVHTGAVLGLHPMFGADIASMAKQVVVRCDGRFPERYEWLLEQIQIWGAKIYQTNATEHDHNMTYIQALRHFSTFANGLHLSKQPINLANLLALSSPIYRLELAMIGRLFAQDAELYADIIMDKSENLAVIETLKQTYDEALTFFENNDRQGFIDAFHKVRDWFGDYSEQFLKESRQLLQQANDLKQG
> I0801 12:18:38.896149 12994031186688 pipeline.py:134] Deduplicating MSAs took 0.04 seconds for sequence GMRESYANENQFGFKTINSDIHKIVIVGGYGKLGGLFARYLRASGYPISILDREDWAVAESILANADVVIVSVPINLTLETIERLKPYLTENMLLADLTSVKREPLAKMLEVHTGAVLGLHPMFGADIASMAKQVVVRCDGRFPERYEWLLEQIQIWGAKIYQTNATEHDHNMTYIQALRHFSTFANGLHLSKQPINLANLLALSSPIYRLELAMIGRLFAQDAELYADIIMDKSENLAVIETLKQTYDEALTFFENNDRQGFIDAFHKVRDWFGDYSEQFLKESRQLLQQANDLKQG, found 8506 unpaired sequences, 7080 paired sequences
> I0801 12:18:38.915758 12994031186688 pipeline.py:40] Getting protein templates for sequence GMRESYANENQFGFKTINSDIHKIVIVGGYGKLGGLFARYLRASGYPISILDREDWAVAESILANADVVIVSVPINLTLETIERLKPYLTENMLLADLTSVKREPLAKMLEVHTGAVLGLHPMFGADIASMAKQVVVRCDGRFPERYEWLLEQIQIWGAKIYQTNATEHDHNMTYIQALRHFSTFANGLHLSKQPINLANLLALSSPIYRLELAMIGRLFAQDAELYADIIMDKSENLAVIETLKQTYDEALTFFENNDRQGFIDAFHKVRDWFGDYSEQFLKESRQLLQQANDLKQG
> I0801 12:18:39.173181 12994031186688 subprocess_utils.py:82] Launching subprocess "/hmmer/bin/hmmbuild --informat stockholm --hand --amino /scratch/8114/tmp/tmp5g2cu1zv/output.hmm /scratch/8114/tmp/tmp5g2cu1zv/query.msa"
> I0801 12:18:40.707435 12994031186688 subprocess_utils.py:111] Finished Hmmbuild in 1.534 seconds
> I0801 12:18:40.710435 12994031186688 subprocess_utils.py:82] Launching subprocess "/hmmer/bin/hmmsearch --noali --cpu 8 --F1 0.1 --F2 0.1 --F3 0.1 -E 100 --incE 100 --domE 100 --incdomE 100 -A /scratch/8114/tmp/tmp4pw8dq17/output.sto /scratch/8114/tmp/tmp4pw8dq17/query.hmm /util/software/data/alphafold3/pdb_seqres_2022_09_28.fasta"
> I0801 12:19:32.723795 12994031186688 subprocess_utils.py:111] Finished Hmmsearch (pdb_seqres_2022_09_28.fasta) in 52.013 seconds
> I0801 12:19:33.322724 12994031186688 pipeline.py:52] Getting 4 protein templates took 54.41 seconds for sequence GMRESYANENQFGFKTINSDIHKIVIVGGYGKLGGLFARYLRASGYPISILDREDWAVAESILANADVVIVSVPINLTLETIERLKPYLTENMLLADLTSVKREPLAKMLEVHTGAVLGLHPMFGADIASMAKQVVVRCDGRFPERYEWLLEQIQIWGAKIYQTNATEHDHNMTYIQALRHFSTFANGLHLSKQPINLANLLALSSPIYRLELAMIGRLFAQDAELYADIIMDKSENLAVIETLKQTYDEALTFFENNDRQGFIDAFHKVRDWFGDYSEQFLKESRQLLQQANDLKQG
> Running data pipeline for chain A took 1410.62 seconds
> Running data pipeline for chain B...
> Running data pipeline for chain B took 0.11 seconds
> Writing model input JSON to ./af_input_inference/2PV7/2PV7_data.json
> Skipping model inference...
> Fold job 2PV7 done, output written to ./af_input_inference/2PV7
> 
> Done running 1 fold jobs.
> ```

The JSON output file (as seen in the above output) is `./af_output/2PV7/2PV7_data.json`

```
ls -l ./af_output/2PV7/2PV7_data.json
```

sample output:

> ```
> -rw-rw-r-- 1 [CCRusername] nogroup 7301275 Aug  1 11:12 ./af_output/2PV7/2PV7_data.json
> ```

The `./af_output/2PV7` directory will be used as the input directory for the Inference run

exit the container and exit the interactive Slurm job

```
exit
exit
```

Allocate a node with at least one GPU e.g.

```
salloc --partition=general-compute --qos=general-compute --nodes=1 --gpus-per-node=1 --exclusive --mem=0
```

Change to your AlphaFold-3 directory

```
cd /projects/academic/[YourGroupName]/AlphaFold-3
```

Then run the AlphaFold-3 container (with nvidia GPU support):


```
apptainer shell \
 -B /projects:/projects,/scratch:/scratch,/util:/util,/vscratch:/vscratch \
 --nv \
 ./AlphaFold-3-$(arch).sif
```

sample output:

> ```
> 
> # Running on a GPU with a compute capability less than 8
> # i.e. this GPU predates the Ampere GPUs
> # Setting environment variable XLA_FLAGS to use this GPU
> 
> export XLA_FLAGS="--xla_disable_hlo_passes=custom-kernel-fusion-rewriter"
> 
> # You must also add the "--flash_attention_implementation=xla" to
> # /app/alphafold/run_alphafold.py for this GPU to work:
>
> export ALPHAFOLD3_EXTRA_OPTIONS="--flash_attention_implementation=xla"
> 
> # Setting environment variables for a GPU with less than 80GB RAM
> 
> export XLA_PYTHON_CLIENT_PREALLOCATE="false"
> export TF_FORCE_UNIFIED_MEMORY="true"
> export XLA_CLIENT_MEM_FRACTION="3.2"
> 
> ```

From the "Apptainer>" prompt, run AlphaFold Inference with the output from the Data Pipeline run

```
python3 "/app/alphafold/run_alphafold.py" \
 --db_dir="/util/software/data/alphafold3/" \
 --model_dir="./models" \
 --input_dir="./af_input_inference/2PV7" \
 --force_output_dir \
 --output_dir="./af_output" \
 --norun_data_pipeline \
 --run_inference \
 ${ALPHAFOLD3_EXTRA_OPTIONS}
```

sample output:

> ```
> I0801 12:47:10.343384 5943330644736 xla_bridge.py:895] Unable to initialize backend 'rocm': module 'jaxlib.xla_extension' has no attribute 'GpuAllocatorConfig'
> I0801 12:47:10.345354 5943330644736 xla_bridge.py:895] Unable to initialize backend 'tpu': INTERNAL: Failed to open libtpu.so: libtpu.so: cannot open shared object file: No such file or directory
> 
> Running AlphaFold 3. Please note that standard AlphaFold 3 model parameters are
> only available under terms of use provided at
> https://github.com/google-deepmind/alphafold3/blob/main/WEIGHTS_TERMS_OF_USE.md.
> If you do not agree to these terms and are using AlphaFold 3 derived model
> parameters, cancel execution of AlphaFold 3 inference with CTRL-C, and do not
> use the model parameters.
> 
> Found local devices: [CudaDevice(id=0), CudaDevice(id=1)], using device 0: cuda:0
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
> I0801 12:47:23.672448 5943330644736 pipeline.py:173] processing 2PV7, random_seed=1
> I0801 12:47:23.927361 5943330644736 pipeline.py:266] Calculating bucket size for input with 596 tokens.
> I0801 12:47:23.927573 5943330644736 pipeline.py:272] Got bucket size 768 for input with 596 tokens, resulting in 172 padded tokens.
> Featurising data with seed 1 took 10.36 seconds.
> Featurising data with 1 seed(s) took 18.59 seconds.
> Running model inference and extracting output structure samples with 1 seed(s)...
> Running model inference with seed 1...
> Running model inference with seed 1 took 855.06 seconds.
> Extracting inference results with seed 1...
> Extracting 5 inference samples with seed 1 took 0.70 seconds.
> Running model inference and extracting output structures with 1 seed(s) took 855.77 seconds.
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
> total 10590
> -rw-rw-r-- 1 [CCRusername] nogroup 3117129 Aug  1 11:46 2PV7_confidences.json
> -rw-rw-r-- 1 [CCRusername] nogroup 7301275 Aug  1 11:31 2PV7_data.json
> -rw-rw-r-- 1 [CCRusername] nogroup  409731 Aug  1 11:46 2PV7_model.cif
> -rw-rw-r-- 1 [CCRusername] nogroup     146 Aug  1 11:46 2PV7_ranking_scores.csv
> -rw-rw-r-- 1 [CCRusername] nogroup     332 Aug  1 11:46 2PV7_summary_confidences.json
> drwxrwsr-x 2 [CCRusername] nogroup    4096 Aug  1 11:46 seed-1_sample-0
> drwxrwsr-x 2 [CCRusername] nogroup    4096 Aug  1 11:46 seed-1_sample-1
> drwxrwsr-x 2 [CCRusername] nogroup    4096 Aug  1 11:46 seed-1_sample-2
> drwxrwsr-x 2 [CCRusername] nogroup    4096 Aug  1 11:46 seed-1_sample-3
> drwxrwsr-x 2 [CCRusername] nogroup    4096 Aug  1 11:46 seed-1_sample-4
> -rw-rw-r-- 1 [CCRusername] nogroup   13036 Aug  1 11:46 TERMS_OF_USE.md
> ```

