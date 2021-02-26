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
        bam="output/mapped/{sample}-{rep}.merge.sort.bam",
        bai="output/mapped/{sample}-{rep}.merge.sort.bam.bai"
    output:
        png="output/qc/bamPEFragmentSize/{sample}-{rep, [^-]+}.hist.png"
    params:
        title="{sample}-{rep}",
        extra="--plotFileFormat png"
    threads:
        config["threads"]
    conda:
        "../envs/deeptools.yaml"
    shell:
        "bamPEFragmentSize --bamfiles {input.bam} --histogram {output.png} {params.extra} -T {params.title} -p {threads}"
