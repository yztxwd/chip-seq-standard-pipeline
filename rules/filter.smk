rule mark_duplicates:
    input:
        "output/mapped/{sample}-{rep}-{unit}.bam"
    output:
        bam=temp("output/mapped/{sample}-{rep, [^-]+}-{unit, [^.]+}.markDuplicates.bam"),
        metrics="dedup/{sample}.metrics.txt"
    log:
        "logs/picard/dedup/{sample}.log"
    params:
        ""
    resources:
        mem_mb=1024
    wrapper:
        "0.72.0/bio/picard/markduplicates"

rule samtools_view:
    input:
        "output/mapped/{sample}-{rep}-{unit}.markDuplicates.bam"
    output:
        temp("output/mapped/{sample}-{rep, [^-]+}-{unit, [^.]+}.flag.bam")
    params:
        lambda wildcards: ((config["samtools_view"]["se"] if is_single_end(**wildcards) 
            else config["samtools_view"]["pe"])) + " -@ " + str(config["threads"])
    wrapper:
        f"file:{snake_dir}/wrappers/samtools/view"

rule samtools_sort:
    input:
        "output/mapped/{sample}-{rep}-{unit}.flag.bam"
    output:
        temp("output/mapped/{sample}-{rep, [^-]+}-{unit, [^.]+}.flag.sort.bam")
    params:
        "-n -@ " + str(config["threads"])
    wrapper:
        f"file:{snake_dir}/wrappers/samtools/sort"

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

rule samtools_flagstat:
    input:
        "output/mapped/{sample}-{rep}-{unit}.flag.bam" if config['filter']['skip'] else "output/mapped/{smaple}-{rep, [^-]+}-{unit}.flag.filtered.bam"
    output:
        "qc/flagstat/{sample}-{rep, [^-]+}-{unit, [^.]+}.flagstat"
    wrapper:
        f"file:{snake_dir}/wrappers/samtools/flagstat"

rule samtools_sort_coord:
    input:
        "output/mapped/{sample}-{rep}-{unit}.flag.bam" if config['filter']['skip'] else "output/mapped/{sample}-{rep}-{unit}.flag.filtered.bam"
    output:
        "output/mapped/{sample}-{rep, [^-]+}-{unit, [^.]+}.clean.sort.bam"
    params:
        "-@ " + str(config["threads"])
    wrapper:
        f"file:{snake_dir}/wrappers/samtools/sort"

rule samtools_index:
    input:
        "{header}.bam"
    output:
        "{header}.bam.bai"
    params:
        "-@ " + str(config["threads"])
    wrapper:
        f"file:{snake_dir}/wrappers/samtools/index"

