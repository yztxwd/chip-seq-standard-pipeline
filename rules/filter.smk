rule mark_duplicates:
    input:
        lambda wildcards: "output/mapped/{sample}-{rep}-{unit}.se.sort.bam" if any(pd.isnull(samples.loc[wildcards.sample, "fq2"])) else "output/mapped/{sample}-{rep}-{unit}.pe.sort.bam"
    output:
        bam=temp("output/mapped/{sample}-{rep, [^-]+}-{unit, [^.]+}.markDuplicates.bam"),
        metrics="output/picard/markDuplicates/{sample}-{rep, [^-]+}-{unit, [^.]+}.markDuplicates.txt"
    params:
        config["mark_duplicates"]
    log:
        "logs/picard/markDuplicates/{sample}-{rep}-{unit}.log"
    conda:
        f"{snake_dir}/envs/common.yaml"
    shell:
        """
        picard MarkDuplicates \
            I={input}\
            O={output.bam} \
            M={output.metrics} \
            {params} > {log}
        """

rule samtools_view:
    input:
        "output/mapped/{sample}-{rep}-{unit}.markDuplicates.bam"
    output:
        temp("output/mapped/{sample}-{rep, [^-]+}-{unit, [^.]+}.flag.bam")
    params:
        lambda wildcards: ((config["samtools_view"]["se"] if is_single_end(**wildcards) 
            else config["samtools_view"]["pe"])) + " -@ " + str(config["threads"])
    conda:
        f"{snake_dir}/envs/common.yaml"
    shell:
        """
        samtools view {params} {input} > {output}
        """

rule mapq_filter:
    input:
        "output/mapped/{sample}-{rep}-{unit}.flag.sortName.bam"
    output:
        temp("output/mapped/{sample}-{rep, [^-]+}-{unit, [^.]+}.flag.filtered.bam"),
    params:
        lambda wildcards: (config["filter"]["se"] if is_single_end(**wildcards) 
            else config["filter"]["pe"]) 
    conda:
        "../envs/py3.yaml"
    script:
        "../scripts/reads_filter_smk.py"

rule samtools_flagstat:
    input:
        "output/mapped/{sample}-{rep}-{unit}.flag.bam" if config['filter']['skip'] else "output/mapped/{smaple}-{rep, [^-]+}-{unit}.flag.filtered.bam"
    output:
        "qc/flagstat/{sample}-{rep, [^-]+}-{unit, [^.]+}.flagstat"
    conda:
        f"{snake_dir}/envs/common.yaml"
    shell:
        """
        samtools flagstat {input} > {output}
        """

