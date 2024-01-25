#!/usr/bin/env python3

import pandas as pd

import sys

if len(sys.argv) != 3:
    exit("Usage: mess_tables.py <assembly_summary.tsv> <out>")


tsv = sys.argv[1]
out = sys.argv[2]

pd.read_csv(tsv, sep="\t")[["asm_name", "proportion"]].to_csv(out, sep="\t", index=None)
