#!/usr/bin/env python3

import pandas as pd
import random
import sys

if len(sys.argv) != 4:
    exit("Usage: subsample.py <subsets> <seed> <assembly_summary.tsv>")

nbs = sys.argv[1].split(",")
seed = int(sys.argv[2])
tsv = sys.argv[3]

random.seed(seed)
seeds = random.sample(range(1, 1000000), len(nbs))
nb2seed = dict(zip(nbs, seeds))
all_df = pd.read_csv(tsv, sep="\t")
for nb in nbs:
    df = all_df.sample(int(nb), random_state=nb2seed[nb])
    df["cov_sim"] = [1] * len(df)
    df[
        ["accession", "total_sequence_length", "number_of_contigs", "cov_sim"]
    ].to_csv(f"subset_{nb}.tsv", sep="\t", index=None)
