# Examples of running the commands shown in the Micro-C Pipeline Documents

The following examples assume you have started an interactive Slurm session with multiple cores in the job e.g.

```
$ salloc --cluster=ub-hpc --partition=general-compute --qos=general-compute --exclusive --time=10:00:00
```

...and started the container like this:

```
$ apptainer shell -B /util:/util,/scratch:/scratch,/vscratch:/vscratch,/projects:/projects Micro-C-$(arch).sif
Apptainer>
```

Note: /util is mounted because there are datafiles already downloaded in the
/util/software/data/Micro-C  and /util/software/data/HiChIP  directories

**All the following commands are run from the Apptainer> prompt**

## Pre-Alignment

Create links to the datafiles already downloaded at CCR

```
ln -s /util/software/data/Micro-C/hg38.fasta
ln -s /util/software/data/Micro-C/hg38.fasta.chrom.sizes
```

NOTE: These are the small 2M reads data sets - ONLY FOR TESTING
      use the 800M reads data sets for all other use cases

```
ln -s /util/software/data/Micro-C/MicroC_2M_R1.fastq
ln -s /util/software/data/Micro-C/MicroC_2M_R2.fastq
```

This results in:

> ```
> ls -l
> lrwxrwxrwx 1 [CCRusername] nogroup         38 May 27 12:21 hg38.fasta -> /util/software/data/Micro-C/hg38.fasta
> lrwxrwxrwx 1 [CCRusername] nogroup         38 May 27 12:21 hg38.fasta.chrom.sizes -> /util/software/data/Micro-C/hg38.fasta.chrom.sizes
> lrwxrwxrwx 1 [CCRusername] nogroup         46 May 27 12:21 MicroC_2M_R1.fastq -> /util/software/data/Micro-C/MicroC_2M_R1.fastq
> lrwxrwxrwx 1 [CCRusername] nogroup         46 May 27 12:21 MicroC_2M_R2.fastq -> /util/software/data/Micro-C/MicroC_2M_R2.fastq
> ```

running "samtools faidx"

```
samtools faidx hg38.fasta
```

This generates the file: hg38.fasta.fai

> ```
> ls -sh hg38.fasta.fai 
> 31K hg38.fasta.fai
> ```

From this file we generate the hg38.genome file:

```
cut -f1,2 hg38.fasta.fai > hg38.genome
```

NOTE: The following step takes about an hour and 10 minutes to run:

```
bwa index hg38.fasta
```

samlple command output:

> ```
> [bwa_index] Pack FASTA... 25.22 sec
> [bwa_index] Construct BWT for the packed sequence...
> [BWTIncCreate] textLength=6598420078, availableWord=476288832
> [BWTIncConstructFromPacked] 10 iterations done. 99999998 characters processed.
> [BWTIncConstructFromPacked] 20 iterations done. 199999998 characters processed.
> [BWTIncConstructFromPacked] 30 iterations done. 299999998 characters processed.
> [...]
> [BWTIncConstructFromPacked] 700 iterations done. 6533110046 characters processed.
> [BWTIncConstructFromPacked] 710 iterations done. 6559598606 characters processed.
> [BWTIncConstructFromPacked] 720 iterations done. 6583137646 characters processed.
> [bwt_gen] Finished constructing BWT in 728 iterations.
> [bwa_index] 2699.36 seconds elapse.
> [bwa_index] Update BWT... 19.52 sec
> [bwa_index] Pack forward-only FASTA... 16.56 sec
> [bwa_index] Construct SA from BWT and Occ... 977.68 sec
> [main] Version: 0.7.17-r1188
> [main] CMD: bwa index hg38.fasta
> [main] Real time: 3752.184 sec; CPU: 3738.340 sec
> ```

This creates five files:

> ```
> ls -lh hg38.fasta.{sa,amb,ann,pac,bwt}
> -rw-rw-r-- 1 [CCRusername] nogroup  22K May 27 14:51 hg38.fasta.amb
> -rw-rw-r-- 1 [CCRusername] nogroup  34K May 27 14:51 hg38.fasta.ann
> -rw-rw-r-- 1 [CCRusername] nogroup 3.1G May 27 14:51 hg38.fasta.bwt
> -rw-rw-r-- 1 [CCRusername] nogroup 787M May 27 14:51 hg38.fasta.pac
> -rw-rw-r-- 1 [CCRusername] nogroup 1.6G May 27 15:08 hg38.fasta.sa
> ```


## From fastq to final valid pairs bam file

```
# create variables for the bwa and pairtools commands that follow:
procs_in="$(expr $(nproc) / 2)"
procs_out="${procs_in}"
total_procs="$(expr ${procs_in} + ${procs_out})"
echo "procs_in = ${procs_in}  procs_out= ${procs_out}  total_procs = ${total_procs}"
```

sample command output:

> ```
> procs_in = 32  procs_out= 32  total_procs = 64
> ```

```
bwa mem -5SP -T0 -t${total_procs} hg38.fasta MicroC_2M_R1.fastq MicroC_2M_R2.fastq | \
 pairtools parse --min-mapq 40 --walks-policy 5unique --max-inter-align-gap 30 --nproc-in ${procs_in} --nproc-out ${procs_out} --chroms-path hg38.genome | \
 pairtools sort --tmpdir=${SLURMTMPDIR} --nproc ${total_procs} | \
 pairtools dedup --nproc-in ${procs_in} --nproc-out ${procs_out} --mark-dups --output-stats stats.txt | \
 pairtools split --nproc-in ${procs_in} --nproc-out ${procs_out} --output-pairs mapped.pairs --output-sam - | \
 samtools view -bS -@${total_procs} | \
 samtools sort -@${total_procs} -o mapped.PT.bam; samtools index mapped.PT.bam
```

sample command output:

> ```
> M::bwa_idx_load_from_disk] read 0 ALT contigs
> [M::process] read 2666668 sequences (400000200 bp)...
> [M::process] read 1333332 sequences (199999800 bp)...
> [M::mem_pestat] # candidate unique pairs for (FF, FR, RF, RR): (43257, 287780, 42072, 43790)
> [M::mem_pestat] analyzing insert size distribution for orientation FF...
> [M::mem_pestat] (25, 50, 75) percentile: (1178, 2697, 5061)
> [M::mem_pestat] low and high boundaries for computing mean and std.dev: (1, 12827)
> [M::mem_pestat] mean and std.dev: (3360.80, 2604.91)
> [M::mem_pestat] low and high boundaries for proper pairs: (1, 16710)
> [M::mem_pestat] analyzing insert size distribution for orientation FR...
> [M::mem_pestat] (25, 50, 75) percentile: (107, 138, 205)
> [M::mem_pestat] low and high boundaries for computing mean and std.dev: (1, 401)
> [M::mem_pestat] mean and std.dev: (139.28, 61.46)
> [M::mem_pestat] low and high boundaries for proper pairs: (1, 499)
> [M::mem_pestat] analyzing insert size distribution for orientation RF...
> [M::mem_pestat] (25, 50, 75) percentile: (1096, 2615, 5006)
> [M::mem_pestat] low and high boundaries for computing mean and std.dev: (1, 12826)
> [M::mem_pestat] mean and std.dev: (3290.40, 2638.68)
> [M::mem_pestat] low and high boundaries for proper pairs: (1, 16736)
> [M::mem_pestat] analyzing insert size distribution for orientation RR...
> [M::mem_pestat] (25, 50, 75) percentile: (1197, 2699, 5039)
> [M::mem_pestat] low and high boundaries for computing mean and std.dev: (1, 12723)
> [M::mem_pestat] mean and std.dev: (3359.06, 2599.26)
> [M::mem_pestat] low and high boundaries for proper pairs: (1, 16565)
> [M::mem_process_seqs] Processed 2666668 reads in 1628.155 CPU sec, 42.032 real sec
> [M::mem_pestat] # candidate unique pairs for (FF, FR, RF, RR): (21791, 144114, 21308, 21772)
> [M::mem_pestat] analyzing insert size distribution for orientation FF...
> [M::mem_pestat] (25, 50, 75) percentile: (1177, 2701, 5088)
> [M::mem_pestat] low and high boundaries for computing mean and std.dev: (1, 12910)
> [M::mem_pestat] mean and std.dev: (3366.27, 2615.22)
> [M::mem_pestat] low and high boundaries for proper pairs: (1, 16821)
> [M::mem_pestat] analyzing insert size distribution for orientation FR...
> [M::mem_pestat] (25, 50, 75) percentile: (106, 138, 203)
> [M::mem_pestat] low and high boundaries for computing mean and std.dev: (1, 397)
> [M::mem_pestat] mean and std.dev: (139.02, 61.19)
> [M::mem_pestat] low and high boundaries for proper pairs: (1, 494)
> [M::mem_pestat] analyzing insert size distribution for orientation RF...
> [M::mem_pestat] (25, 50, 75) percentile: (1110, 2653, 5076)
> [M::mem_pestat] low and high boundaries for computing mean and std.dev: (1, 13008)
> [M::mem_pestat] mean and std.dev: (3310.85, 2634.75)
> [M::mem_pestat] low and high boundaries for proper pairs: (1, 16974)
> [M::mem_pestat] analyzing insert size distribution for orientation RR...
> [M::mem_pestat] (25, 50, 75) percentile: (1193, 2705, 5058)
> [M::mem_pestat] low and high boundaries for computing mean and std.dev: (1, 12788)
> [M::mem_pestat] mean and std.dev: (3367.65, 2606.91)
> [M::mem_pestat] low and high boundaries for proper pairs: (1, 16653)
> [M::mem_process_seqs] Processed 1333332 reads in 801.710 CPU sec, 21.316 real sec
> [main] Version: 0.7.17-r1188
> [main] CMD: bwa mem -5SP -T0 -t40 hg38.fasta MicroC_2M_R1.fastq MicroC_2M_R2.fastq
> [main] Real time: 143.249 sec; CPU: 2446.412 sec
> WARNING:py.warnings:/usr/local/lib/python3.12/dist-packages/pairtools-1.1.3-py3.12-linux-x86_64.egg/pairtools/lib/stats.py:410: RuntimeWarning: invalid value encountered in divide
> [bam_sort_core] merging from 0 files and 40 in-memory blocks...
> ```

This generates four files:

> ```
> ls -lh mapped.* stats.txt 
> -rw-rw-r-- 1 [CCRusername] nogroup 123M May 27 16:02 mapped.pairs
> -rw-rw-r-- 1 [CCRusername] nogroup 476M May 27 16:02 mapped.PT.bam
> -rw-rw-r-- 1 [CCRusername] nogroup 3.8M May 27 16:02 mapped.PT.bam.bai
> -rw-rw-r-- 1 [CCRusername] nogroup  53K May 27 16:02 stats.txt
> ```


## Library QC

```
get_qc.py -p stats.txt 
```

sample commadn output:

> ```
> Total Read Pairs                              2,000,000  100%
> Unmapped Read Pairs                           132,393    6.62%
> Mapped Read Pairs                             1,551,564  77.58%
> PCR Dup Read Pairs                            5,117      0.26%
> No-Dup Read Pairs                             1,546,447  77.32%
> No-Dup Cis Read Pairs                         1,230,133  79.55%
> No-Dup Trans Read Pairs                       316,314    20.45%
> No-Dup Valid Read Pairs (cis >= 1kb + trans)  1,397,616  90.38%
> No-Dup Cis Read Pairs < 1kb                   148,831    9.62%
> No-Dup Cis Read Pairs >= 1kb                  1,081,302  69.92%
> No-Dup Cis Read Pairs >= 10kb                 822,235    53.17%
> ```


## Library Complexity
(from Micro-C Docs)

```
preseq lc_extrap -bam -pe -extrap 2.1e9 -step 1e8 -seg_len 1000000000 -output out.preseq mapped.PT.bam
```

This gives an error output:

> ```
> max count before zero is less than min required count (4) duplicates removed
> ```

This web page:
  https://github.com/nugentechnologies/NuMetWG
suggests that the above error can be resolved by using samtools to filter multiple alignments.
Unfortunately, no example was provided


# ChiP enrichment
(from HiChiP Docs]

The following example uses a link to the ENCFF017XLW.bed file already downloaded at CCR

```
ln -s /util/software/data/HiChIP/ENCFF017XLW.bed
enrichment_stats.sh -g hg38.genome -b mapped.PT.bam -p ENCFF017XLW.bed -t 16 -x CTCF
```

This generates four files:

> ```
> ls -l CTCF_*
> -rw-rw-r-- 1 [CCRusername] nogroup      701 May 29 13:35 CTCF_hichip_qc_metrics.txt
> -rw-rw-r-- 1 [CCRusername] nogroup  5077511 May 29 13:35 CTCF_peak_intersect_500.bed
> -rw-rw-r-- 1 [CCRusername] nogroup  9577469 May 29 13:35 CTCF_peaks_intersect_1000.bed
> -rw-rw-r-- 1 [CCRusername] nogroup 18214790 May 29 13:35 CTCF_peaks_intersect_2000.bed
> ```

```
cat CTCF_hichip_qc_metrics.txt
```

sample output:

> ```
> Total ChIP peaks                                                     41,017
> Mean ChIP peak size                                                  309 bp
> Median ChIP peak size                                                356 bp
> Total reads in 500 bp around center of peaks                         44,322   0.93%
> Total reads in 1000 bp around center of peaks                        81,799   1.72%
> Total reads in 2000 bp around summits                                150,191  3.15%
> Observed/Expected ratio for reads in 500 bp around center of peaks   1.5
> Observed/Expected ratio for reads in 1000 bp around center of peaks  1.38
> Observed/Expected ratio for reads in 2000 bp around center of peaks  1.27
> ```

Generating the entichment image

```
plot_chip_enrichment.py -bam mapped.PT.bam -peaks ENCFF017XLW.bed -output enrichment.png
```

sample output:

> ```
> [mpileup] 1 samples in 1 input files
> [mpileup] 1 samples in 1 input files
> [...]
> [mpileup] 1 samples in 1 input files
> [mpileup] 1 samples in 1 input files
> ```

This generates the file enrichment.png

> ```  
> ls -lh enrichment.png 
> -rw-rw-r-- 1 [CCRusername] nogroup 184K May 29 13:55 enrichment.png
> ```


## Generating HiC contact maps using Juicer tools

NOTE: there is a bug in hic_tools with valid headers from a valid
      pairix format file, so we have to trim out headers other than
      "## pairs" and "#columns"
 see:
   https://github.com/aidenlab/HiCTools/issues/13

so we trim all other headers from the mapped.pairs file:

```
grep -E '^(##[[:space:]]+pairs|#columns|[^#])' mapped.pairs > ht_mapped.pairs
```

...then use the ht_mapped.pairs with hic_tools.jar

```
java -Xmx96000m  -Djava.awt.headless=true -jar /opt/Micro-C/hic_tools.jar pre --threads $(nproc) ht_mapped.pairs contact_map.hic hg38.genome
```

sample output:

> ```
> WARNING: sun.reflect.Reflection.getCallerClass is not supported. This will impact performance.
> WARN [2025-06-03T10:58:51,492]  [Globals.java:138] [main]  Development mode is enabled
> Using 40 CPU thread(s) for primary task
> Using 10 CPU thread(s) for secondary task
> No mndIndex provided
> Using single threaded preprocessor
> Start preprocess
> Writing header
> Writing body
> .......[...].......
> Writing footer
> nBytesV5: 1406399
> masterIndexPosition: 43878117
> 
> Finished preprocess
> No normalization vectors
> Skipping GW_* and INTER_* normalizations because these regions have no data in this .hic file
> 
> Calculating norms for zoom BP_2500000
> Calculating norms for zoom BP_1000000
> Calculating norms for zoom BP_500000
> Calculating norms for zoom BP_250000
> Calculating norms for zoom BP_100000
> Calculating norms for zoom BP_50000
> Calculating norms for zoom BP_25000
> Calculating norms for zoom BP_10000
> Calculating norms for zoom BP_5000
> Calculating norms for zoom BP_1000Balancing calculations completed
> No normalization vectors
> Finished writing norms
> ```

This generates a file contact_map.hic

> ```
> ls -sh contact_map.hic
> 82M contact_map.hic
> ```


## Visualizing .hic contact matrix

In CCR's [OnDemand portal](https://ondemand.ccr.buffalo.edu) you can view a .hic file
(once you have started the container) with:

```
java -Xmx96000m -jar /opt/Micro-C/juicebox.jar
```

[File][Open][Local] browse to the path of the .hic file e.g.
 /projects/academic/[...]/contact_map.hic


## Generating cooler contact maps

pairix needs a gzipped version of the mapped.pairs file:

```
bgzip -c mapped.pairs > mapped.pairs.gz
pairix mapped.pairs.gz
```

This will generate a file mapped.pairs.gz.px2

> ```
> ls -sh mapped.pairs.gz.px2
> 3.1M mapped.pairs.gz.px2
> ```

Use cooler to generate a .cool file

```
cooler cload pairix -p $(nproc) hg38.genome:1000 mapped.pairs.gz matrix_1kb.cool
```

sample output:

> ```
> INFO:cooler.cli.cload:Using 40 cores
> INFO:cooler.create:Creating cooler at "/projects/academic/[...]/matrix_1kb.cool::/"
> INFO:cooler.create:Writing chroms
> INFO:cooler.create:Writing bins
> INFO:cooler.create:Writing pixels
> INFO:cooler.create:Binning chr1:0-124479000|*
> INFO:cooler.create:Binning chr1:124479000-248956422|*
> INFO:cooler.create:Binning chr10:0-133797422|*
> [...]
> INFO:cooler.create:Finished chr6:0-170805979|*
> INFO:cooler.create:Finished chr5:0-170706000|*
> INFO:cooler.create:Writing indexes
> INFO:cooler.create:Writing info
> ```

This will generate a file: matrix_1kb.cool

> ```
> ls -sh matrix_1kb.cool
> 8.0M matrix_1kb.cool
> ```

Use cooler to generate a .mcool file:

```
cooler zoomify --balance -p $(nproc) matrix_1kb.cool
```

sample output:

> ```
> INFO:cooler.cli.zoomify:Recursively aggregating "matrix_1kb.cool"
> INFO:cooler.cli.zoomify:Writing to "matrix_1kb.mcool"
> INFO:cooler._reduce:Copying base matrices and producing 14 new zoom levels.
> INFO:cooler._reduce:Bin size: 1000
> INFO:cooler._reduce:Aggregating from 1000 to 2000.
> INFO:cooler.create:Creating cooler at "/projects/academic/[...]/matrix_1kb.mcool::/resolutions/2000"
> [...]
> INFO:cooler._balance:variance is 1.7168765407947152e-05
> INFO:cooler._balance:variance is 1.0568513022616514e-05
> INFO:cooler._balance:variance is 6.505821811737878e-06
> ```

This generates a file matrix_1kb.mcool

> ```
> ls -sh matrix_1kb.mcool
> 38M matrix_1kb.mcool
> ```

Use bamCoverage to generate a bigwig file

```
bamCoverage --bam mapped.PT.bam -of bigwig -o coverage.bw
```

sample output:

> ```
> bamFilesList: ['mapped.PT.bam']
> binLength: 50
> numberOfSamples: None
> [...]
> save_data: False
> out_file_for_raw_data: None
> maxPairedFragmentLength: 1000
> ```

This generates a file coverage.bw

> ```
> ls -sh coverage.bw
> 35M coverage.bw
> ```

In CCR's [OnDemand portal](https://ondemand.ccr.buffalo.edu) you can view this bigwig file
(once you have started the container) with:

```
igv.sh coverage.bw
```


## Differential Analysis

This uses R plugins:

HiCcompare for single-replicate analysis 
see:
   https://www.bioconductor.org/packages/release/bioc/html/HiCcompare.html

 multiHiCcompare for multiple replicate experiments.
 see:
   https://www.bioconductor.org/packages/release/bioc/html/multiHiCcompare.html

 This container does not include "R"
 These plugins can be installed inside R as explained on the above websites


## Conformation Analysis

# A/B Compartments
Example using the test matrix_1kb.mcool

Note: This takes about seven and a half hours to run, most of that time the progress bar is over 93% with litle sign of progress!

```
fanc compartments -f -v MicroC_2M_eigen_64kb.bed -d MicroC_2M_64kb.bed -g hg38.fasta matrix_1kb.mcool@64000 MicroC_2M_64kb.ab
```

sampple output:

> ```
> 2025-06-03 23:27:25,186 INFO FAN-C version: 0.9.28
> 2025-06-03 23:27:25,302 INFO Computing AB compartment matrix
> [...]
> AB 100% (711 of 711) |###########[...]###########| Elapsed Time: 0:29:49 Time:  0:29:49
> Buffers 100% (124 of 124) |#########[...]########| Elapsed Time: 0:00:01 Time:  0:00:01
> Expected 100% (47588015 of 47588015) |###[...]###| Elapsed Time: 0:07:45 Time:  0:07:45
> 2025-06-04 06:50:16,946 INFO Using GC content to orient eigenvector...
> 2025-06-04 06:52:07,659 INFO Returning pre-calculated eigenvector!
> ```

This generates three files:

> ```
> ls -lh MicroC_2M_eigen_64kb.bed MicroC_2M_64kb.bed MicroC_2M_64kb.ab
> -rw-rw-r-- 1 [CCRusername] nogroup 489M Jun  4 06:52 MicroC_2M_64kb.ab
> -rw-rw-r-- 1 [CCRusername] nogroup 955K Jun  4 06:52 MicroC_2M_64kb.bed
> -rw-rw-r-- 1 [CCRusername] nogroup 2.4M Jun  4 06:52 MicroC_2M_eigen_64kb.bed
> ```

# Topologically Associated Domains

```
java -jar -Xmx48000m  -Djava.awt.headless=true \
 -jar /opt/Micro-C/juicer_tools.jar arrowhead --threads $(nproc) -k KR \
 -m 2000 -r 10000 contact_map.hic TAD_calls
```

sample output

> ```
> WARNING: sun.reflect.Reflection.getCallerClass is not supported. This will impact performance.
> WARN [2025-06-04T17:54:24,211]  [Globals.java:138] [main]  Development mode is enabled
> Reading file: contact_map.hic
> HiC file version: 9
> 48512076 131538
> Using 40 CPU thread(s) for primary task
> Warning: Hi-C map may be too sparse to find many domains via Arrowhead.
> max 139.0
> 0% 
> [...]
> 100% 
> 0 domains written to file: /projects/academic/[...]/TAD_calls/10000_blocks.bedpe
> Arrowhead complete
> ```


```
java -jar -Xmx48000m  -Djava.awt.headless=true \
 -jar /opt/Micro-C/juicer_tools.jar arrowhead --threads $(nproc) -k KR \
 -m 2000 -r 5000 contact_map.hic TAD_calls
```

sample output

> ```
> WARNING: sun.reflect.Reflection.getCallerClass is not supported. This will impact performance.
> WARN [2025-06-04T18:04:54,581]  [Globals.java:138] [main]  Development mode is enabled
> Reading file: contact_map.hic
> HiC file version: 9
> 48512076 131538
> Using 40 CPU thread(s) for primary task
> Warning: Hi-C map may be too sparse to find many domains via Arrowhead.
> max 139.0
> 0% 
> [...]
> 100% 
> 0 domains written to file: /projects/academic/[...]/TAD_calls/5000_blocks.bedpe
> Arrowhead complete
> ```

# Chromatin Loops

```
mustache -p $(nproc) -f matrix_1kb.mcool -r 4000 -o MicroC_2M_4000kb_loops.tsv
```

sample output

> ```
> 
> 
> The distance limit is set to 2Mbp
> /usr/local/lib/python3.12/dist-packages/mustache_hic-1.3.3-py3.12.egg/mustache/mustache.py:1028: FutureWarning: Series.__getitem__ treating keys as positions is deprecated. In a future version, integer keys will always be treated as labels (consistent with DataFrame behavior). To access a value by position, use `ser.iloc[pos]`
>   if clr.chromsizes[i] > 1000000:
> Reading contact map...
> 0 8000000
> 6000000 14000000
> 12000000 20000000
> 18000000 26000000
> [...]
> 0 loops found for chrmosome=chr15_MU273374v1_fix, fdr<0.2 in 0.20sec
> Reading contact map...
> 0 1020778
> There is no contact in chrmosome chr21_MU273391v1_fix to work on.
> 0 loops found for chrmosome=chr21_MU273391v1_fix, fdr<0.2 in 0.21sec
> ```

note that mustache found no loops:

> ```
> cat MicroC_2M_4000kb_loops.tsv
> BIN1_CHR	BIN1_START	BIN1_END	BIN2_CHROMOSOME	BIN2_START	BIN2_END	FDR	DETECTION_SCALE
> ```

