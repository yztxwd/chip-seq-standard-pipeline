rule samtools_view:
    input:
        "mapped/{sample}-{unit}.bam"
    output:
        "mapped/{sample}-{unit, [^.]+}.F1804.bam"
    params:
        "-@ 15 -F 1804 -b"
    wrapper:
        "0.49.0/bio/samtools/view"

rule samtools_sort:
    input:
        "mapped/{sample}-{unit}.F1804.bam"
    output:
        "mapped/{sample}-{unit, [^.]+}.F1804.sort.bam"
    params:
        "-@ 15 -F 1804 -b"
    wrapper:
        "0.49.0/bio/samtools/view"

rule mapq_filter:
    input:
        "mapped/{sample}-{unit}.F1804.sort.bam"
    output:
        "mapped/{sample}-{unit, [^.]+}.F1804.filtered.bam",
        "mapped/{sample}-{unit, [^.]+}.coverage.1b.bg",
        "mapped/{sample}-{unit, [^.]+}.midpoint.1b.bg"
    params:
        "-m pair -f 0 -s 0 -t 20"
    conda:
        "envs/py3.yaml"
    script:
        "scripts/reads_filter_smk.py"

rule samtools_flagstat:
    input:
        "mapped/{smaple}-{unit}.F1804.filtered.bam"
    output:
        "summary/{sample}-{unit, [^.]+}.flagstat"
    wrapper:
        "0.49.0/bio/samtools/flagstat"
