rule multiqc:
    input:
        lambda wildcards: df.values.dropna()
    output:
        "qc/multiqc/multiqc.html"
    params:
        ""
    log:
        "logs/{sample}-{unit}.multiqc.log"
    wrapper:
        "0.49.0/bio/fastqc"
