rule multiqc:
    input:
        units.dropna()
    output:
        "qc/multiqc/multiqc.html"
    params:
        ""
    log:
        "logs/multiqc.log"
    wrapper:
        "0.49.0/bio/fastqc"
