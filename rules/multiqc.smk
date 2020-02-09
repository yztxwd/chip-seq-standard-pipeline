rule fastqc:
    input:
        "data/{sample}.fq.gz"
    output:
        html="output/qc/fastqc/{sample}_fastqc.html",
        zip="output/qc/fastqc/{sample}_fastqc.zip"
    params: ""
    log:
        "output/logs/fastqc/{sample}.fastqc.log"
    wrapper:
        "0.49.0/bio/fastqc"  

rule multiqc:
    input:
        ["output/qc/fastqc/" + str(i).replace('.fq.gz', '_fastqc.html') for i in list(units[["fq1", "fq2"]].values.flatten()) if not pd.isnull(i)]
    output:
        "output/qc/multiqc/multiqc.html"
    params:
        config["multiqc"]["params"]
    log:
        "output/logs/multiqc/multiqc.log"
    wrapper:
        "0.49.0/bio/multiqc"
