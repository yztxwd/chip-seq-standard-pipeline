rule bowtie2_mapping_pe:
    input:
        r1=lambda wildcards: "data/" + samples.loc[(wildcards.sample, wildcards.rep, wildcards.unit), "fq1"] if config['trimmomatic']['skip'] else "output/trimmed/{sample}-{rep}-{unit}.trim.1.fq.gz",
        r2=lambda wildcards: "data/" + samples.loc[(wildcards.sample, wildcards.rep, wildcards.unit), "fq2"] if config['trimmomatic']['skip'] else "output/trimmed/{sample}-{rep}-{unit}.trim.2.fq.gz"
    output:
        temp("output/mapped/{sample}-{rep}-{unit, [^.]+}.pe.bam")
    log:
        "logs/bowtie2/{sample}-{rep, [^-]+}-{unit}.log"
    params:
        index=lambda wildcards: config["bowtie2"]["index"],
        extra=config["bowtie2"]["extra"]
    threads: 
        config["threads"]
    conda:
        f"{snake_dir}/envs/common.yaml"
    shell:
        """
        bowtie2 --threads {threads} {params.extra} \
            -x {params.index} -1 {input.r1} -2 {input.r2} \
            | samtools view -Sbh -o {output} &> {log}
        """

rule bowtie2_mapping_se:
    input:
        lambda wildcards: "data/" + samples.loc[(wildcards.sample, wildcards.rep, wildcards.unit), "fq1"] if config['trimmomatic']['skip'] else "output/trimmed/{sample}-{rep}-{unit}.trim.fq.gz"
    output:
        temp("output/mapped/{sample}-{rep}-{unit, [^.]+}.se.bam")
    log:
        "logs/bowtie2/{sample}-{rep, [^-]+}-{unit}.log"
    params:
        index=lambda wildcards: config["bowtie2"]["index"],
        extra=config["bowtie2"]["extra"]
    threads: 
        config["threads"]
    conda:
        f"{snake_dir}/envs/common.yaml"
    shell:
        """
        bowtie2 --threads {threads} {params.extra} \
            -x {params.index} -U {input} \
            | samtools view -Sbh -o {output} &> {log}
        """  
