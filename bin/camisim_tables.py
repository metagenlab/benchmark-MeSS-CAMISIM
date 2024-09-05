#!/usr/bin/env python3

import pandas as pd
import sys


if len(sys.argv) != 3:
    exit("Usage: camisim_tables.py <abundance.tsv> <sample>")


df = pd.read_csv(sys.argv[1], sep="\t", encoding="utf-8")
prefix = sys.argv[2]

df["OTU"] = df["tax_id"]
df["genome_ID"] = [f"Genome{int(i)}" for i in df.index]
df["NCBI_ID"] = df["tax_id"]
df["novelty_category"] = ["known_strain"] * len(df)

df[["genome_ID", "OTU", "NCBI_ID", "novelty_category"]].to_csv(
    f"metadata_{prefix}.tsv", sep="\t", index=False, encoding="utf-8"
)
df[["genome_ID", "tax_abundance"]].to_csv(
    f"distribution_{prefix}.tsv", sep="\t", index=False, header=False, encoding="utf-8"
)
df[["genome_ID", "path"]].to_csv(
    f"genome_to_id_{prefix}.tsv", sep="\t", index=False, header=False, encoding="utf-8"
)
