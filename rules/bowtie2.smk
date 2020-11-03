def get_fq(wildcards):
    if config["trimmomatic"]["skip"]:
        # no trimming, use raw reads
        return "data/" + samples.loc[(wildcards.sample, wildcards.rep, wildcards.unit), ["fq1", "fq2"]].dropna()
    else:
        # yes trimming, use output/trimmed reads
        if not is_single_end(**wildcards):
            # paired-end sample
            return expand("output/trimmed/{sample}-{rep}-{unit}.trim.{num}.fq.gz",
                            num=[1, 2], **wildcards)
        # single end sample
        return ["output/trimmed/{sample}-{rep}-{unit}.trim.fq.gz".format(**wildcards)]

rule bowtie2_mapping:
    input:
        sample=get_fq
    output:
        temp("output/mapped/{sample}-{rep}-{unit, [^.]+}.bam")
    log:
        "output/logs/bowtie2/{sample}-{rep, [^-]+}-{unit}.log"
    params:
        index=lambda wildcards: config["bowtie2"]["index"][samples.loc[(wildcards.sample, wildcards.rep, wildcards.unit), "specie"]],
        extra=config["bowtie2"]["extra"]
    threads: 
        config["threads"]
    wrapper:
        f"file:{snake_dir}/wrappers/bowtie2/align"
