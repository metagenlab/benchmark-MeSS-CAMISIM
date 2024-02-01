#!/usr/bin/env python3

import pandas as pd

import sys

if len(sys.argv) != 3:
    exit("Usage: camisim_tables.py <assembly_summary.tsv> <prefix>")


tsv = sys.argv[1]
prefix = sys.argv[2]

cami_df = pd.read_csv(tsv, sep="\t")
cami_df["OTU"] = cami_df["taxid"]
cami_df["genome_ID"] = [f"Genome{int(i)}" for i in cami_df.index]
cami_df["NCBI_ID"] = cami_df["taxid"]
cami_df["novelty_category"] = ["known_strain"] * len(cami_df)

cami_df[["genome_ID", "OTU", "NCBI_ID", "novelty_category"]].to_csv(
    f"metadata_{prefix}.tsv",
    sep="\t",
    index=None,
)
cami_df[["genome_ID", "proportion"]].to_csv(
    f"distribution_{prefix}.tsv",
    sep="\t",
    index=None,
    header=False,
)
cami_df[["genome_ID", "path"]].to_csv(
    f"genome_to_id_{prefix}.tsv",
    sep="\t",
    index=None,
    header=False,
)
