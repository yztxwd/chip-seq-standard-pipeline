#!/data1/yztxwd/miniconda3/envs/py3/bin/python
#coding=utf-8

import sys, os, re
import pandas as pd

from collections import defaultdict

# load input and output from snakemake object
coverage = snakemake.input[0]
output = snakemake.output[0]

# count the fragment size frequency
store = {}
with open(coverage, 'r') as f:
    for line in f:
        chr, start, end, depth, id = line.split('\t')
        start = int(start); end = int(end)
        store[file][end-start+1] += 1

# save the fragment size frequency
dfStore = {}
for file in files:
    dfStore[file] = pd.DataFrame(store[file].values(), store[file].keys())
    dfStore[file].columns = [file]
merge = pd.concat(dfStore.values(), axis=1)
merge.fillna(0)
merge.to_csv(output, sep='\t')
