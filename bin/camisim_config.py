#!/usr/bin/env python3

import glob
import sys
import os
import configparser


if len(sys.argv) != 7:
    exit("Usage: camisim_config.py <cami_path> <cpus> <nb> <size> <in> <out>")


def write_config(camipath, cpus, nb, size, meta, id2genome, dist, config, outfile):
    with open(outfile, "w") as f:
        for section in config.sections():
            f.write(f"[{section}]\n")
            for key, val in config.items(section):
                if key == "output_directory":
                    val = f"sample{nb}"
                if key == "max_processors":
                    val = cpus
                if key in [
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


cami_path = sys.argv[1]
cpus = int(sys.argv[2])
nb = int(sys.argv[3])
size = sys.argv[4]
config = configparser.ConfigParser()
config.read(sys.argv[5])
out = sys.argv[6]

dist_path = os.path.abspath(glob.glob("*_distribution.txt")[0])
meta_path = os.path.abspath(glob.glob("*_metadata.tsv")[0])
gen2id_path = os.path.abspath(glob.glob("*_genome_to_id.tsv")[0])

write_config(cami_path, cpus, nb, size, meta_path, gen2id_path, dist_path, config, out)
