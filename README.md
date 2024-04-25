# benchmark-MeSS-CAMISIM

Nextflow pipeline to benchmark two shotgun metagenomic communities simulators.

## Setup

### 1) Clone CAMISIM repository

```bash
git clone https://github.com/CAMI-challenge/CAMISIM
```

### 2) Edit CAMISIM path in nextflow.config

```bash
env {
    CAMI_PATH = "path/to/CAMISIM"
}
```

### 3) Download and decompress taxdump

```bash
curl https://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz -o taxdump.tar.gz
tar -xzvf taxdump.tar.gz
```

### 4) Edit CAMISIM config

You need to edit paths to samtools binaries and taxdump path

```ini
samtools=/path/to/your/samtools/bin
ncbi_taxdump=/path/to/your/taxdump
```

### 5) download genomes with assembly_finder

```bash
assembly_finder -i bacteria -nb 2000 --assembly-level complete --reference --api-key $api-key
```

### 5) Edit params

Download path and repo paths

```yaml
summary: "path/to/bacteria/assembly_summary.tsv"
config: "path/to/repo/benchmark-MeSS-CAMISIM/default_config.ini"
err_profile: "path/to/CAMISIM/tools/art_illumina-2.3.6/profiles/ART_MBARC-26_HiSeq_R"
```

## Run

```bash
nextflow run main.nf -c nextflow.config -params-file params.yml
```
