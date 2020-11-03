#!/bin/bash

# generate left-right direction dag
snakemake --dag > images/workflow.dag

sed -i '2a \    rankdir="LR\";' images/workflow.dag

dot -Tpng images/workflow.dag > images/workflow.png
