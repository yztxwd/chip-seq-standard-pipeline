rule samtools_view:
    input:
        "output/mapped/{sample}-{rep}-{unit}.bam"
    output:
        temp("output/mapped/{sample}-{rep, [^-]+}-{unit, [^.]+}.flag.bam")
    params:
        lambda wildcards: (config["samtools_view"]["se"] if is_single_end(**wildcards) 
            else config["samtools_view"]["pe"]) + " -@ " + str(config["threads"])
    wrapper:
        "0.49.0/bio/samtools/view"

rule samtools_sort:
    input:
        "output/mapped/{sample}-{rep}-{unit}.flag.bam"
    output:
        temp("output/mapped/{sample}-{rep, [^-]+}-{unit, [^.]+}.flag.sort.bam")
    params:
        "-n -@ " + str(config["threads"])
    wrapper:
        "0.49.0/bio/samtools/sort"

rule mapq_filter:
    input:
        "output/mapped/{sample}-{rep}-{unit}.flag.sort.bam"
    output:
        temp("output/mapped/{sample}-{rep, [^-]+}-{unit, [^.]+}.flag.filtered.bam"),
        temp("output/mapped/{sample}-{rep, [^-]+}-{unit, [^.]+}.coverage.1b.bg"),
        temp("output/mapped/{sample}-{rep, [^-]+}-{unit, [^.]+}.midpoint.1b.bg")
    params:
        lambda wildcards: (config["filter"]["se"] if is_single_end(**wildcards) 
            else config["filter"]["pe"]) 
    conda:
        "../envs/py3.yaml"
    script:
        "../scripts/reads_filter_smk.py"

rule samtools_flagstat:
    input:
        "output/mapped/{smaple}-{rep, [^-]+}-{unit}.flag.filtered.bam"
    output:
        "qc/flagstat/{sample}-{rep, [^-]+}-{unit, [^.]+}.flagstat"
    wrapper:
        "0.49.0/bio/samtools/flagstat"
