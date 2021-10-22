rule bwa_mapping_pe:
    input:
        r1=lambda wildcards: "data/" + samples.loc[(wildcards.sample, wildcards.rep, wildcards.unit), "fq1"] if config['trimmomatic']['skip'] else "output/trimmed/{sample}-{rep}-{unit}.trim.1.fq.gz",
        r2=lambda wildcards: "data/" + samples.loc[(wildcards.sample, wildcards.rep, wildcards.unit), "fq2"] if config['trimmomatic']['skip'] else "output/trimmed/{sample}-{rep}-{unit}.trim.2.fq.gz"
    output:
        temp("output/mapped/{sample}-{rep}-{unit, [^.]+}.pe.bwa.bam")
    log:
        "logs/bwa/{sample}-{rep, [^-]+}-{unit}.log"
    params:
        index=lambda wildcards: config["bwa"]["index"],
        extra=config["bwa"]["extra"]
    threads: 
        config["threads"]
    resources:
        cpus=config["threads"],
        mem=config['mem']
    conda:
        f"{snake_dir}/envs/bwa.yaml"
    shell:
        """
        bwa mem -t {threads} {params.extra} \
            -x {params.index} {input.r1} {input.r2} \
            | samtools view -Sbh -o {output} > {log}
        """

rule bwa_mapping_se:
    input:
        lambda wildcards: "data/" + samples.loc[(wildcards.sample, wildcards.rep, wildcards.unit), "fq1"] if config['trimmomatic']['skip'] else "output/trimmed/{sample}-{rep}-{unit}.trim.fq.gz"
    output:
        temp("output/mapped/{sample}-{rep}-{unit, [^.]+}.se.bwa.bam")
    log:
        "logs/bwa/{sample}-{rep, [^-]+}-{unit}.log"
    params:
        index=lambda wildcards: config["bwa"]["index"],
        extra=config["bwa"]["extra"]
    threads: 
        config["threads"]
    resources:
        cpus=config["threads"],
        mem=config['mem']
    conda:
        f"{snake_dir}/envs/bwa.yaml"
    shell:
        """
        bwa mem -t {threads} {params.extra} \
            -x {params.index} {input} \
            | samtools view -Sbh -o {output} > {log}
        """  
