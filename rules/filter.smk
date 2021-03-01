rule mark_duplicates:
    input:
        lambda wildcards: "output/mapped/{sample}-{rep}-{unit}.se.bam" if any(pd.isnull(samples.loc[wildcards.sample, "fq2"])) else "output/mapped/{sample}-{rep}-{unit}.pe.bam"
    output:
        bam=temp("output/mapped/{sample}-{rep, [^-]+}-{unit, [^.]+}.markDuplicates.bam"),
        metrics="output/picard/markDuplicates/{sample}-{rep, [^-]+}-{unit, [^.]+}.markDuplicates.txt"
    params:
        config["mark_duplicates"]
    conda:
        f"{snake_dir}/envs/common.yaml"
    shell:
        """
        picard MarkDuplicates \
            I={input}\
            O={output.bam} \
            M={output.metrics} \
            {params}
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

rule samtools_sort:
    input:
        "output/mapped/{sample}-{rep}-{unit}.flag.bam"
    output:
        temp("output/mapped/{sample}-{rep, [^-]+}-{unit, [^.]+}.flag.sort.bam")
    params:
        "-n"
    threads:
        config['threads']
    conda:
        f"{snake_dir}/envs/common.yaml"
    shell:
        """
        samtools sort {params} -@ {threads} -o {output} {input}
        """

rule mapq_filter:
    input:
        "output/mapped/{sample}-{rep}-{unit}.flag.sort.bam"
    output:
        temp("output/mapped/{sample}-{rep, [^-]+}-{unit, [^.]+}.flag.filtered.bam"),
    params:
        lambda wildcards: (config["filter"]["se"] if is_single_end(**wildcards) 
            else config["filter"]["pe"]) 
    conda:
        "../envs/py3.yaml"
    script:
        "../scripts/reads_filter_smk.py"

rule samtools_sort_coord:
    input:
        "output/mapped/{sample}-{rep}-{unit}.flag.bam" if config['filter']['skip'] else "output/mapped/{sample}-{rep}-{unit}.flag.filtered.bam"
    output:
        "output/mapped/{sample}-{rep, [^-]+}-{unit, [^.]+}.clean.sort.bam"
    params:
        ""
    threads:
        config['threads']
    conda:
        f"{snake_dir}/envs/common.yaml"
    shell:
        """
        samtools sort {params} -@ {threads} -o {output} {input}
        """

rule samtools_index:
    input:
        "{header}.bam"
    output:
        "{header}.bam.bai"
    params:
        ""
    conda:
        f"{snake_dir}/envs/common.yaml"
    shell:
        """
        samtools index {params} {input} {output}
        """

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

