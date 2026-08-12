# OpenFold OpenFold PDB training set data

NOTE: DO NOT do this at CCR unless the copy of the processed files in
/util/software/data/OpenFold/ do not satisfy your needs.

The following instructions take about two days to complete and you will need
about 2TB of storage space for the downloads, though this reduces to about
1.5TB once some pre-processed files are removed.


## Download OpenFold PDB training set from RODA

Change to your OpenFold directory

```
cd /projects/academic/[YourGroupName]/OpenFold
```

Start the container

```
apptainer shell \
 --writable-tmpfs \
 --bind /util:/util,/scratch:/scratch \
 --bind /vscratch/grp-[YourGroupName]:/vscratch/grp-[YourGroupName] \
 --bind /projects/academic/[YourGroupName]:/projects/academic/[YourGroupName] \
 --bind /util/software/data/OpenFold:/data \
 --bind /util/software/data/alphafold:/database \
 --bind /util/software/data/OpenFold/openfold_params:/opt/openfold/openfold/resources/openfold_params \
 --bind /util/software/data/alphafold/params:/opt/openfold/openfold/resources/params \
 --bind $(pwd)/output:/output \
 --nv \
 OpenFold-$(arch).sif
```

expected output:

> ```
> Apptainer> 
> ```

All the following commands are run from the "Apptainer>" prompt.

Following the download example [here](https://openfold.readthedocs.io/en/latest/OpenFold_Training_Setup.html)

Download alignments corresponding to the original PDB training set of OpenFold
and their mmCIF 3D structures.

```
mkdir -p alignment_data/alignment_dir_roda
aws s3 cp s3://openfold/pdb/ alignment_data/alignment_dir_roda/ --recursive --no-sign-request
mkdir -p pdb_data
aws s3 cp s3://openfold/pdb_mmcif.zip pdb_data/ --no-sign-request
aws s3 cp s3://openfold/duplicate_pdb_chains.txt pdb_data/ --no-sign-request
unzip pdb_data/pdb_mmcif.zip -d pdb_data
${OF_DIR}/scripts/flatten_roda.sh alignment_data/alignment_dir_roda alignment_data/ && \
 rm -r alignment_data/alignment_dir_roda
``


Highly truncated output:

> ```
> [...]
>   inflating: pdb_data/mmcif_files/3n25.cif
>   inflating: pdb_data/mmcif_files/5bpe.cif
>   inflating: pdb_data/obsolete.dat
> ```


## Creating alignment DBs

```
python ${OF_DIR}/scripts/alignment_db_scripts/create_alignment_db_sharded.py \
 alignment_data/alignments \
 alignment_data/alignment_dbs \
 alignment_db \
 --n_shards 10 \
 --duplicate_chains_file pdb_data/duplicate_pdb_chains.txt
```

sample output:

> ```
> Getting chain directories...
> 131487it [00:01, 93532.58it/s]
> Creating 10 alignment-db files...
> 
> Created all shards. 
> Extending super index with duplicate chains...
> Added 502947 duplicate chains to index.
> 
> Writing super index...
> Done.
> ```

Verify the alighnemt DBs

```
grep "files" alignment_data/alignment_dbs/alignment_db.index | wc -l
```

Expected output:

> ```
> 634434
> ```


## Generating cluster-files

Generate a .fasta file of all sequences in the training set.

```
python ${OF_DIR}/scripts/alignment_data_to_fasta.py \
 alignment_data/all-seqs.fasta \
 --alignment_db_index alignment_data/alignment_dbs/alignment_db.index
```

Sample output:

> ```
> Creating FASTA from alignment dbs...
> 100%|█████████████████████████████████| 634434/634434 [40:03<00:00, 263.97it/s]
> FASTA file written to alignment_data/all-seqs.fasta.
> ```

Generate a cluster file at 40% sequence identity, which will contain all
chains in a particular cluster on the same line.

```
python ${OF_DIR}/scripts/fasta_to_clusterfile.py \
 alignment_data/all-seqs.fasta \
 alignment_data/all-seqs_clusters-40.txt \
 /opt/conda/bin/mmseqs \
 --seq-id 0.4
```

Sample truncated output:

> ```
> [...]
> rmdb _mmseqs_out_temp/585534219710102476/clu -v 3 
> 
> Time for processing: 0h 0m 0s 82ms
> Reformatting output file...
> Cleaning up mmseqs2 output...
> Done!
> ```


## Generating Cache files

OpenFold requires “cache” files with metadata information for each chain.

Download the data caches for OpenProteinSetfrom RODA

```
aws s3 cp s3://openfold/data_caches/ pdb_data/ --recursive --no-sign-request
```

Sample output:

> ```
> download: s3://openfold/data_caches/mmcif_cache.json to pdb_data/mmcif_cache.json
> download: s3://openfold/data_caches/chain_data_cache.json to pdb_data/chain_data_cache.json
> ```


Create data caches for your own datasets.

```
mkdir pdb_data/data_caches
python ${OF_DIR}/scripts/generate_mmcif_cache.py \
 pdb_data/mmcif_files \
 pdb_data/data_caches/mmcif_cache.json \
 --no_workers $(nproc)
```

samoke output:

> ```
> 100%|██████████████████████████████| 185158/185158 [1:04:15<00:00, 48.03it/s]

> ```

Generate chain-data-cache for filtering training samples and adjusting
per-chain sampling probabilities

```
python ${OF_DIR}/scripts/generate_chain_data_cache.py \
 pdb_data/mmcif_files \
 pdb_data/data_caches/chain_data_cache.json \
 --cluster_file alignment_data/all-seqs_clusters-40.txt \
 --no_workers $(nproc)
```

Sample output:

> ```
> 100%|██████████████████████████████| 185158/185158 [1:15:58<00:00, 40.62it/s]
> ```

