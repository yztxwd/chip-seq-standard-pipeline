rule multiqc:
    input:
        lambda wildcards: units.loc[(wildcards.sample, wildcards.unit), ["fq1", "fq2"]].dropna()
    output:
        html="qc/fastqc/{sample}-{unit}_fastqc.html",
        zip="qc/fastqc/{sample}-{unit}_fastqc.zip"
    log:
        "logs/{sample}-{unit}.multiqc.log"
    wrapper:
        "0.49.0/bio/fastqc"
