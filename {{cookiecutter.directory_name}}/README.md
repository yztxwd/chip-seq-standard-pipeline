# Snakemake pipeline for ChIP-seq data


@author Jianyu Yang, Southern Medical University

# Dependency

- miniconda
- snakemake(>=5.1.2)

# Quick Start

- Put the gzipped fastq data into the data folder
- Modify the samples.tsv and units.tsv file corresponding to the data
- excute the following command in the root directory of the project, you'll see an output folder with all generated files!
    ```
    snakemake --use-conda --cores
    ```

# Introduction

This pipeline aims for standard ChIP-seq fastq files handling, which consists of 
- Standard Procedure:
    - reads trimming
    - bowtie2 mapping
    - reads filtering by samtools and python script
- QC:
    - multiqc report
    - fragment size frequency report

It is written by [Snakemake](https://snakemake.readthedocs.io/en/stable/index.html), which is a very powerful workflow management system, the basic framework is from [rna-seq-star-deseq2](https://github.com/snakemake-workflows/rna-seq-star-deseq2).

# DAG

The example DAG of this pipeline is as follows
![DAG](https://github.com/yztxwd/snakemake-pipeline/raw/master/images/dag.png)
