#!/usr/bin/env python3

import pandas as pd
import numpy as np
import sys
import shutil

if len(sys.argv) != 7:
    exit("Usage: subsample.py <nb> <seed> <mu> <sigma> <assembly_summary.tsv> <out>")

nb = int(sys.argv[1])
seed = int(sys.argv[2])
mu = int(sys.argv[3])
sigma = int(sys.argv[4])
tsv = sys.argv[5]
out = sys.argv[6]


def get_lognormal_dist(df, mu, sigma):
    df["lognormal"] = np.random.lognormal(mean=mu, sigma=sigma, size=len(df))
    df["proportion"] = df["lognormal"] / df["lognormal"].sum()
    return df


np.random.seed(seed)
df = pd.read_csv(tsv, sep="\t")
df = df.sample(nb, random_state=seed)
df = get_lognormal_dist(df, mu, sigma)
df["sample"] = [f"sample{nb}"] * len(df)
df["nb"] = [1] * len(df)
for path in df["path"]:
    shutil.copy(path, ".")
df.to_csv(out, sep="\t", index=None)
