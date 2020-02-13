rule count_size:
    input:
        "output/mapped/{sample}.merged.coverage.1b.bg"
    output:
        "output/qc/size/{sample}.size.freq"
    conda:
        "../envs/py3.yaml"
    script:
        "../scripts/count_size_smk.py"
