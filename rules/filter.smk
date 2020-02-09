rule samtools_view:
    input:
        "mapped/{sample}-{unit}.bam"
    output:
        "mapped/{sample}-{unit, [^.]+}.flag.bam"
    params:
        lambda wildcards: (config["samtools_view"]["se"] if is_single_end(wildcards.sample, wildcards.unit) 
            else config["samtools_view"]["pe"]) + " -@ " + str(config["threads"])
    wrapper:
        "0.49.0/bio/samtools/view"

rule samtools_sort:
    input:
        "mapped/{sample}-{unit}.flag.bam"
    output:
        "mapped/{sample}-{unit, [^.]+}.flag.sort.bam"
    params:
        "-@ " + str(config["threads"])
    wrapper:
        "0.49.0/bio/samtools/sort"

rule mapq_filter:
    input:
        "mapped/{sample}-{unit}.flag.sort.bam"
    output:
        "mapped/{sample}-{unit, [^.]+}.flag.filtered.bam",
        "mapped/{sample}-{unit, [^.]+}.coverage.1b.bg",
        "mapped/{sample}-{unit, [^.]+}.midpoint.1b.bg"
    params:
        lambda wildcards: (config["filter"]["se"] if is_single_end(wildcards.sample, wildcards.unit) 
            else config["filter"]["pe"]) 
    conda:
        "envs/py3.yaml"
    script:
        "scripts/reads_filter_smk.py"

rule samtools_flagstat:
    input:
        "mapped/{smaple}-{unit}.flag.filtered.bam"
    output:
        "summary/{sample}-{unit, [^.]+}.flagstat"
    wrapper:
        "0.49.0/bio/samtools/flagstat"
