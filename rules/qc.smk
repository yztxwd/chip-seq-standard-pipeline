rule fastqc:
    input:
        "data/{sample}.fastq.gz"
    output:
        html="output/qc/fastqc/{sample}_fastqc.html",
        zip="output/qc/fastqc/{sample}_fastqc.zip"
    params: ""
    log:
        "output/logs/fastqc/{sample}.fastqc.log"
    conda:
        f"{snake_dir}/wrappers/fastqc/environment.yaml"
    shell:
        """
        fastqc {params} --quiet \
          --outdir output/qc/fastqc/ {input[0]} \
          > {log}
        """

rule multiqc:
    input:
        dir=["output/qc/fastqc/"]
    output:
        html="output/qc/multiqc/multiqc.html",
        dir="output/qc/multiqc/"
    params:
        config["multiqc"]["params"]
    log:
        "output/logs/multiqc/multiqc.log"
    conda:
        f"{snake_dir}/wrappers/multiqc/envrionment.yaml"
    shell:
        """
        multiqc {params} --force \
          -o {output.dir} \
          -n {output.html} \
          {input.dir} \
          &> {log}
        """

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
