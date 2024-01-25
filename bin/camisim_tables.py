#!/usr/bin/env python3

import pandas as pd

import sys

if len(sys.argv) != 3:
    exit("Usage: camisim_tables.py <assembly_summary.tsv> <prefix>")


tsv = sys.argv[1]
prefix = sys.argv[2]

cami_df = pd.read_csv(tsv, sep="\t")
cami_df["path"] = [path.replace(".gz", "") for path in cami_df["path"]]
cami_df["OTU"] = [float(i) + 1 for i in cami_df.index]
cami_df["genome_ID"] = [f"Genome{i}" for i in cami_df["OTU"]]
cami_df["NCBI_ID"] = cami_df["taxid"]
cami_df["novelty_category"] = ["known_strain"] * len(cami_df)

cami_df[["genome_ID", "OTU", "NCBI_ID", "novelty_category"]].to_csv(
    f"{prefix}_metadata.tsv",
    sep="\t",
    index=None,
)
cami_df[["genome_ID", "proportion"]].to_csv(
    f"{prefix}_distribution.txt",
    sep="\t",
    index=None,
    header=None,
)
cami_df[["genome_ID", "path"]].to_csv(
    f"{prefix}_genome_to_id.tsv",
    sep="\t",
    index=None,
    header=None,
)
