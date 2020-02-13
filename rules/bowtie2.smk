def get_fq(wildcards):
    if config["trimmomatic"]["skip"]:
        # no trimming, use raw reads
        return "data/" + units.loc[(wildcards.sample, wildcards.unit), ["fq1", "fq2"]].dropna()
    else:
        # yes trimming, use output/trimmed reads
        if not is_single_end(**wildcards):
            # paired-end sample
            return expand("output/trimmed/{sample}-{unit}.{num}.fq.gz",
                            num=[1, 2], **wildcards)
        # single end sample
        return ["output/trimmed/{sample}-{unit}.fq.gz".format(**wildcards)]

rule bowtie2_mapping:
    input:
        sample=get_fq
    output:
        temp("output/mapped/{sample}-{unit, [^.]+}.bam")
    log:
        "output/logs/bowtie2/{sample}-{unit}.log"
    params:
        index=config["bowtie2"]["index"],
        extra=config["bowtie2"]["extra"]
    threads: 
        config["threads"]
    wrapper:
        "0.49.0/bio/bowtie2/align"
