# benchmark-MeSS-CAMISIM
Nextflow pipeline to benchmark two shotgun metagenomic communities simulators.

## Clone CAMISIM and MeSS repositories
We will use CAMISIM's python3 branch
```bash
git clone https://github.com/metagenlab/MeSS.git
git clone https://github.com/CAMI-challenge/CAMISIM
cd CAMISIM
git checkout python3
```
## Create config and input files, download assemblies
```bash
nextflow run init.nf
```

## Run the benchmark 
```bash
nextflow run benchmark.nf --with-trace trace.txt --with-report report.html --with-timeline timeline.html
```