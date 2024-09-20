# benchmark-MeSS-CAMISIM

Nextflow pipeline to benchmark two shotgun metagenomic communities simulators.

## Setup NCBI API key

Go to https://www.ncbi.nlm.nih.gov/account/login/ to create an NCBI account and get an API key.

Before launching the pipeline set your key as a secret:

```sh
nextflow secrets set NCBI_KEY 0123456789abcdef
```

## Run using sample tables

```sh
nextflow run main.nf --input data -params-file run-params.yml --container_prefix containers
--outdir run
```


## Run with subsets

```sh
nextflow run main.nf --input data -params-file subsets-params.yml --container_prefix containers
--outdir subsets
```

