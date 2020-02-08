def is_single_end(sample, unit):
    return pd.isnull(units.loc[(sample, unit), "fq2"])

def get_fq(wildcards):
    if config["trimming"]["skip"]:
        # no trimming, use raw reads
        return units.loc[(wildcards.sample, wildcards.unit), ["fq1", "fq2"]].dropna()
    else:
        # yes trimming, use trimmed reads
        if not is_single_end(**wildcards):
            # paired-end sample
            return expand("trimmed/{sample}-{unit}.{num}.fq.gz",
                            num=[1, 2], **wildcards)
        # single end sample
        return "trimmed/{sample}-{unit}.fq.gz".format(**wildcards)

rule bowtie2_mapping:
    input:
        sample=get_fq
    output:
        "mapped/{sample}-{unit, [^.]+}.bam"
    log:
        "logs/bowtie2/{sample}-{unit}.log"
    params:
        index="index/genome",
        extra=""
    threads: 
        32
    wrapper:
        "0.49.0/bio/bowtie2/align"
