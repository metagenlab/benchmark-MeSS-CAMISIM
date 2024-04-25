#!/usr/bin/env python3

import glob
import sys
import os
import configparser
import pandas as pd


if len(sys.argv) != 11:
    exit(
        "Usage: camisim_config.py <summary> <cami_path> <seed> <cpus> <sample> <read_len> <frag_len> <frag_sd> <in> <out>"
    )


def write_config(
    camipath,
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
                if key in [
                    "base_profile_name",
                    "readsim",
                    "error_profiles",
                    "strain_simulation_template",
                ]:
                    val = os.path.join(camipath, val)
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
                f.write(f"{key}={val}\n")


summary = sys.argv[1]
cami_path = sys.argv[2]
seed = sys.argv[3]
cpus = int(sys.argv[4])
sample = sys.argv[5]
read_len = sys.argv[6]
frag_len = sys.argv[7]
frag_sd = sys.argv[8]
config = configparser.ConfigParser()
config.read(sys.argv[9])
out = sys.argv[10]

dist_path = os.path.abspath(glob.glob("distribution_*")[0])
meta_path = os.path.abspath(glob.glob("metadata_*")[0])
gen2id_path = os.path.abspath(glob.glob("genome_to_id_*")[0])

nb = pd.read_csv(gen2id_path, sep="\t", names=["fasta", "path"]).shape[0]
size = pd.read_csv(summary, sep="\t")["bases"].sum() / 10**9

write_config(
    cami_path,
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
    out,
)
