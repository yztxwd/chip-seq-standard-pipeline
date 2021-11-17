import pandas as pd
from snakemake.utils import validate, min_version

#### Set minimum snakemake version ####
min_version("5.1.2")

#### Load config and sample sheets ####

configfile: "config.yaml"
#validate(config, schema="schemas/config.schema.yaml")

samples = pd.read_table(config["samples"]).set_index(["sample", "rep", "unit"], drop=False)
#validate(samples, schema="schemas/samples.schema.yaml")

#### target rules ####

rule all:
    input:
        "output/qc/multiqc/multiqc.html",
        expand("output/qc/bamPEFragmentSize/{samples}-{rep}.hist.png", zip, samples=samples["sample"], rep=samples["rep"]),
        expand("output/coverage/{samples}-{rep}.bgToBw.bw", zip, samples=samples["sample"], rep=samples["rep"]),
        expand("output/coverage/{samples}-{rep}.bamCov.bw", zip, samples=samples["sample"], rep=samples["rep"]),
        expand('output/coverage/{samples}-{rep}.bamCompare.bw', zip, 
                 samples=samples.loc[samples["condition"]!="control", "sample"] if "control" in samples["condition"].values else [],
                 rep=samples.loc[samples["condition"]!="control", "rep"] if "control" in samples["condition"].values else []),
        expand("output/idr/{samples}.idr.peaks", samples=samples.loc[samples["condition"]!="control", "sample"])

#### setup singularity ####

# this container defines the underlying OS for each job when using the workflow
# with --use-conda --use-singularity
singularity: "docker://continuumio/miniconda3"

#### setup report ####
report: "report/workflow.rst"

#### load rules ####
include: "snakemake-pipeline-general/rules/global.smk"
include: "snakemake-pipeline-general/rules/qc.smk"
include: "snakemake-pipeline-general/rules/trim.smk"
include: "snakemake-pipeline-general/rules/fastp.smk"
include: "snakemake-pipeline-general/rules/bowtie2.smk"
include: "snakemake-pipeline-general/rules/bwa.smk"
include: "snakemake-pipeline-general/rules/filter.smk"
include: "snakemake-pipeline-general/rules/merge.smk"
include: "snakemake-pipeline-general/rules/coverage.smk"
include: "rules/macs2.smk"
include: "rules/idr.smk"
