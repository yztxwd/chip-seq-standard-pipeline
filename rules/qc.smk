rule fastqc:
    input:
        "data/{sample}.fastq.gz"
    output:
        html="output/qc/fastqc/{sample}_fastqc.html",
        zip="output/qc/fastqc/{sample}_fastqc.zip"
    params: ""
    log:
        "output/logs/fastqc/{sample}.fastqc.log"
    wrapper:
        f"file:{snake_dir}/wrappers/fastqc" 

rule multiqc:
    input:
        ["output/qc/fastqc/" + str(i).replace('.fastq.gz', '_fastqc.html') for i in list(samples[["fq1", "fq2"]].values.flatten()) if not pd.isnull(i)]
    output:
        "output/qc/multiqc/multiqc.html"
    params:
        config["multiqc"]["params"]
    log:
        "output/logs/multiqc/multiqc.log"
    wrapper:
        f"file:{snake_dir}/wrappers/multiqc" 

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
