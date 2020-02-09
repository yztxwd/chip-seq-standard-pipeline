rule fastqc:
    input:
        "data/{sample}.fq.gz"
    output:
        html="qc/fastqc/{sample}_fastqc.html",
        zip="qc/fastqc/{sample}_fastqc.zip"
    params: ""
    log:
        "logs/{sample}.fastqc.log"
    wrapper:
        "0.49.0/bio/fastqc"  

rule multiqc:
    input:
        ["qc/fastqc/" + str(i).replace('.fq.gz', '_fastqc.html') for i in list(units.values.flatten()) if not pd.isnull(i)]
    output:
        "qc/multiqc/multiqc.html"
    params:
        config["multiqc"]["params"]
    log:
        "logs/multiqc.log"
    wrapper:
        "0.49.0/bio/multiqc"
