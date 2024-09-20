# benchmark-MeSS-CAMISIM

Nextflow pipeline to benchmark two shotgun metagenomic communities simulators.

## Setup NCBI API key

Go to https://www.ncbi.nlm.nih.gov/account/login/ to create an NCBI account and get an API key.

Before launching the pipeline set your key as a secret:

```sh
nextflow secrets set NCBI_KEY 0123456789abcdef
```

## Run the pipeline
### Using the example tables in data
```sh
nextflow run main.nf --input data -params-file run-params.yml
```


### Subsets piepeline
You can download a total set of genomes from a given taxon (bacteria for example), and run CAMISIM and MeSS on subsamples of that set.

For example, download 6 bacterial reference genomes and simulate reads at 1X coverage depth for 1,2,3 subsets:

```sh
nextflow run main.nf -params-file subsets-params.yml --total 6 --subsets 1,2,3 --outdir subsets
```

