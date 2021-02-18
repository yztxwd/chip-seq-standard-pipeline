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

rule bowtie2_mapping_pe:
    input:
        r1="output/trimmed/{sample}-{rep}-{unit}.trim.1.fq.gz",
        r2="output/trimmed/{sample}-{rep}-{unit}.trim.2.fq.gz"
    output:
        temp("output/mapped/{sample}-{rep}-{unit, [^.]+}.pe.bam")
    log:
        "output/logs/bowtie2/{sample}-{rep, [^-]+}-{unit}.log"
    params:
        index=lambda wildcards: config["bowtie2"]["index"],
        extra=config["bowtie2"]["extra"]
    threads: 
        config["threads"]
    conda:
        f"file:{snake_dir}/wrappers/bowtie2/align/environment.yaml"
    shell:
        """
        bowtie2 --threads {threads} {params.extra} \
            -x {params.index} -1 {input.r1} -2 {input.r2} \
            | samtools view -Sbh -o {output} &> {log}
        """

rule bowtie2_mapping_se:
    input:
        "output/trimmed/{sample}-{rep}-{unit}.trim.fq.gz"
    output:
        temp("output/mapped/{sample}-{rep}-{unit, [^.]+}.se.bam")
    log:
        "output/logs/bowtie2/{sample}-{rep, [^-]+}-{unit}.log"
    params:
        index=lambda wildcards: config["bowtie2"]["index"],
        extra=config["bowtie2"]["extra"]
    threads: 
        config["threads"]
    conda:
        f"file:{snake_dir}/wrappers/bowtie2/align/environment.yaml"
    shell:
        """
        bowtie2 --threads {threads} {params.extra} \
            -x {params.index} -U {input} \
            | samtools view -Sbh -o {output} &> {log}
        """  
