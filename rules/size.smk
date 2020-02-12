rule count_size:
    input:
        "output/mapped/{sample}-{replicate}.merged.coverage.1b.bg"
    output:
        "output/qc/size/{sample}-{replicate}.size.freq"
    conda:
        "../envs/py3.yaml"
    script:
        "../scripts/count_size_smk.py"