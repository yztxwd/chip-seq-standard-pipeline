rule multiqc:
    input:
        units[['fq1', 'fq2']].values.flatten()[~pd.isnull(units[['fq1', 'fq2']].values.flatten())]
    output:
        "qc/multiqc/multiqc.html"
    params:
        ""
    log:
        "logs/multiqc.log"
    wrapper:
        "0.49.0/bio/fastqc"
