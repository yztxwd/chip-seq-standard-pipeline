rule count_size:
    input:
        "mapped/{sample}.merged.coverage.1b.bg"
    output:
        "summary/{sample}.size.freq"
    conda:
        "envs/py3.yaml"
    script:
        "scripts/count_size_smk.py"