#!/usr/bin/env python3

import sys
import os
import configparser
import pandas as pd


if len(sys.argv) != 13:
    exit(
        "Usage: camisim_config.py <abundance> <dist> <meta> <gen2id> <seed> <cpus> <sample> <read_len> <frag_len> <frag_sd> <in> <out>"
    )


def write_config(
    taxdump,
    seed,
    cpus,
    sample,
    nb,
    read_len,
    frag_len,
    frag_sd,
    size,
    meta,
    id2genome,
    dist,
    config,
    outfile,
):
    with open(outfile, "w") as f:
        for section in config.sections():
            f.write(f"[{section}]\n")
            for key, val in config.items(section):
                if key == "seed":
                    val = seed
                if key == "profile_read_length":
                    val = read_len
                if key == "fragments_size_mean":
                    val = frag_len
                if key == "fragment_size_standard_deviation":
                    val = frag_sd
                if key in ["output_directory", "temp_directory", "dataset_id"]:
                    val = sample
                if key == "max_processors":
                    val = cpus
                if key == "size":
                    val = size
                if key in ["genomes_total", "num_real_genomes"]:
                    val = nb
                if key == "metadata":
                    val = meta
                if key == "id_to_genome_file":
                    val = id2genome
                if key == "distribution_file_paths":
                    val = dist
                if key == "ncbi_taxdump":
                    val = taxdump
                f.write(f"{key}={val}\n")


ncbi_taxdump = os.path.abspath("taxdump")
abundance_df = sys.argv[1]
dist_path = os.path.abspath(sys.argv[2])
meta_path = os.path.abspath(sys.argv[3])
gen2id_path = os.path.abspath(sys.argv[4])
seed = sys.argv[5]
cpus = int(sys.argv[6])
sample = sys.argv[7]
read_len = sys.argv[8]
frag_len = sys.argv[9]
frag_sd = sys.argv[10]
config = configparser.ConfigParser()
config.read(sys.argv[11])
out = sys.argv[12]


nb = pd.read_csv(gen2id_path, sep="\t", names=["fasta", "path"]).shape[0]
size = pd.read_csv(abundance_df, sep="\t")["bases"].sum() / 10**9

write_config(
    ncbi_taxdump,
    seed,
    cpus,
    sample,
    nb,
    read_len,
    frag_len,
    frag_sd,
    size,
    meta_path,
    gen2id_path,
    dist_path,
    config,
    out
)
