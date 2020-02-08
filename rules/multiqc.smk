rule multiqc:
    input:
        units.values.flatten()[~pd.isnull(units.values.flatten())]
    output:
        "qc/multiqc/multiqc.html"
    params:
        ""
    log:
        "logs/multiqc.log"
    wrapper:
        "0.49.0/bio/fastqc"
