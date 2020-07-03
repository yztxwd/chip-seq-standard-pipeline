rule count_size:
    input:
        "output/mapped/{sample}.merged.coverage.1b.bg"
    output:
        freq="output/qc/size/{sample}.size.freq",
        png="output/qc/size/{sample}.size.png"
    conda:
        "../envs/py3.yaml"
    script:
        "../scripts/count_size_smk.py"
