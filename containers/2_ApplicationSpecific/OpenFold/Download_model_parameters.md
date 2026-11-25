# OpenFold and AlphaFold 2 model parameters

NOTE: DO NOT do this at CCR unless the copy of the files in
/util/software/data/OpenFold/ and /util/software/data/AlphaFold/
does not satisfy your needs.

## Download the OpenFold and AlphaFold 2 model parameters

Change to your OpenFold directory

```
cd /projects/academic/[YourGroupName]/OpenFold
```

...and make a direcory for the model parameters

```
mkdir -p ./resources
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

Create a directory for the model parameters

```
mkdir -p ./resources/
```

## Download the OpenFold trained parameters

```
bash ${OF_DIR}/scripts/download_openfold_params.sh ./resources/
```

Sample output:

> ```
> download: s3://openfold/openfold_params/LICENSE to resources/openfold_params/LICENSE
> download: s3://openfold/openfold_params/README.txt to resources/openfold_params/README.txt
> download: s3://openfold/openfold_params/finetuning_no_templ_1.pt to resources/openfold_params/finetuning_no_templ_1.pt
> download: s3://openfold/openfold_params/finetuning_5.pt to resources/openfold_params/finetuning_5.pt
> download: s3://openfold/openfold_params/finetuning_3.pt to resources/openfold_params/finetuning_3.pt
> download: s3://openfold/openfold_params/finetuning_2.pt to resources/openfold_params/finetuning_2.pt
> download: s3://openfold/openfold_params/finetuning_4.pt to resources/openfold_params/finetuning_4.pt
> download: s3://openfold/openfold_params/finetuning_ptm_2.pt to resources/openfold_params/finetuning_ptm_2.pt
> download: s3://openfold/openfold_params/finetuning_no_templ_2.pt to resources/openfold_params/finetuning_no_templ_2.pt
> download: s3://openfold/openfold_params/finetuning_ptm_1.pt to resources/openfold_params/finetuning_ptm_1.pt
> download: s3://openfold/openfold_params/finetuning_no_templ_ptm_1.pt to resources/openfold_params/finetuning_no_templ_ptm_1.pt
> download: s3://openfold/openfold_params/initial_training.pt to resources/openfold_params/initial_training.pt
> ```

This has downloaded the OpenFold model params to ./resources/openfold_params/

```
ls -l ./resources/openfold_params/
```

Sample output:

> ```
> total 3654208
> -rw-rw-r-- 1 [CCRusername] nogroup 374586533 Jul 19  2022 finetuning_2.pt
> -rw-rw-r-- 1 [CCRusername] nogroup 374586533 Jul 19  2022 finetuning_3.pt
> -rw-rw-r-- 1 [CCRusername] nogroup 374586533 Jul 19  2022 finetuning_4.pt
> -rw-rw-r-- 1 [CCRusername] nogroup 374586533 Jul 19  2022 finetuning_5.pt
> -rw-rw-r-- 1 [CCRusername] nogroup 373226022 Jul 19  2022 finetuning_no_templ_1.pt
> -rw-rw-r-- 1 [CCRusername] nogroup 373226022 Jul 19  2022 finetuning_no_templ_2.pt
> -rw-rw-r-- 1 [CCRusername] nogroup 373259620 Jul 19  2022 finetuning_no_templ_ptm_1.pt
> -rw-rw-r-- 1 [CCRusername] nogroup 374620131 Jul 19  2022 finetuning_ptm_1.pt
> -rw-rw-r-- 1 [CCRusername] nogroup 374620131 Jul 19  2022 finetuning_ptm_2.pt
> -rw-rw-r-- 1 [CCRusername] nogroup 374586533 Jul 19  2022 initial_training.pt
> -rw-rw-r-- 1 [CCRusername] nogroup     18657 Jul 19  2022 LICENSE
> -rw-rw-r-- 1 [CCRusername] nogroup      2217 Jul 19  2022 README.txt
> ```


## Download the AlphaFold Deepmind model parameters

```
bash ${OF_DIR}/scripts/download_alphafold_params.sh ./resources/
```

Sample output:

> ```
> 
> 08/21 11:38:26 [NOTICE] Downloading 1 item(s)
> 
> 08/21 11:38:26 [NOTICE] Allocating disk space. Use --file-allocation=none to disable it. See --file-allocation option in man page for more details.
>  *** Download Progress Summary as of Thu Aug 21 11:39:29 2025 ***
> ===============================================================================
> [#5fb42b 4.5GiB/5.2GiB(86%) CN:1 DL:60MiB ETA:11s]
> FILE: ./resources//params/alphafold_params_2022-12-06.tar
> -------------------------------------------------------------------------------
> 
> [#5fb42b 5.1GiB/5.2GiB(98%) CN:1 DL:95MiB]
> 08/21 11:39:37 [NOTICE] Download complete: ./resources//params/alphafold_params_2022-12-06.tar
> 
> Download Results:
> gid   |stat|avg speed  |path/URI
> ======+====+===========+=======================================================
> 5fb42b|OK  |    78MiB/s|./resources//params/alphafold_params_2022-12-06.tar
> 
> Status Legend:
> (OK):download completed.
> params_model_1.npz
> params_model_2.npz
> params_model_3.npz
> params_model_4.npz
> params_model_5.npz
> params_model_1_ptm.npz
> params_model_2_ptm.npz
> params_model_3_ptm.npz
> params_model_4_ptm.npz
> params_model_5_ptm.npz
> params_model_1_multimer_v3.npz
> params_model_2_multimer_v3.npz
> params_model_3_multimer_v3.npz
> params_model_4_multimer_v3.npz
> params_model_5_multimer_v3.npz
> LICENSE
> ```

This has downloaded the AlphaFold Deepmind momdel parameters to ./resources/params/

```
ls -l ./resources/params/
```

Sample output:

> ```
> total 5456991
> -rw-rw-r-- 1 [CCRusername] nogroup     18657 Mar 23  2020 LICENSE
> -rw-rw-r-- 1 [CCRusername] nogroup 373043148 Nov 22  2022 params_model_1_multimer_v3.npz
> -rw-rw-r-- 1 [CCRusername] nogroup 373069562 Jul 19  2021 params_model_1.npz
> -rw-rw-r-- 1 [CCRusername] nogroup 373103340 Jul 19  2021 params_model_1_ptm.npz
> -rw-rw-r-- 1 [CCRusername] nogroup 373043148 Nov 22  2022 params_model_2_multimer_v3.npz
> -rw-rw-r-- 1 [CCRusername] nogroup 373069562 Jul 19  2021 params_model_2.npz
> -rw-rw-r-- 1 [CCRusername] nogroup 373103340 Jul 19  2021 params_model_2_ptm.npz
> -rw-rw-r-- 1 [CCRusername] nogroup 373043148 Nov 22  2022 params_model_3_multimer_v3.npz
> -rw-rw-r-- 1 [CCRusername] nogroup 371712506 Jul 19  2021 params_model_3.npz
> -rw-rw-r-- 1 [CCRusername] nogroup 371746284 Jul 19  2021 params_model_3_ptm.npz
> -rw-rw-r-- 1 [CCRusername] nogroup 373043148 Nov 22  2022 params_model_4_multimer_v3.npz
> -rw-rw-r-- 1 [CCRusername] nogroup 371712506 Jul 19  2021 params_model_4.npz
> -rw-rw-r-- 1 [CCRusername] nogroup 371746284 Jul 19  2021 params_model_4_ptm.npz
> -rw-rw-r-- 1 [CCRusername] nogroup 373043148 Nov 22  2022 params_model_5_multimer_v3.npz
> -rw-rw-r-- 1 [CCRusername] nogroup 371712506 Jul 19  2021 params_model_5.npz
> -rw-rw-r-- 1 [CCRusername] nogroup 371746284 Jul 19  2021 params_model_5_ptm.npz
> ```

