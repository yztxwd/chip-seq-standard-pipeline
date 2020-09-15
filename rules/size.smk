rule count_size:
    input:
        "output/mapped/{sample}-{rep}.merged.coverage.1b.bg"
    output:
        freq="output/qc/size/{sample}-{rep, [^-]+}.size.freq",
        png="output/qc/size/{sample}-{rep, [^-]+}.size.png"
    conda:
        "../envs/py3.yaml"
    script:
        "../scripts/count_size_smk.py"
