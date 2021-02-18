# bigwig and bedGraph coverage file for future use

rule genomecov_bam:
    input:
        "output/mapped/{sample}-{rep}.merge.sort.bam"
    output:
        "output/coverage/{sample}-{rep, [^.]+}.bedGraph"
    log:
        "logs/genomecov/{sample}-{rep}.log"
    params:
        config["genomecov"]
    conda:
        f"{snake_dir}/envs/bedtools.yaml"
    shell:
        "genomeCoverageBed {params} {input} 1> {output} 2> {log}"

rule bedGraphToBigWig:
    input:
        bedGraph="output/coverage/{sample}-{rep}.bedGraph",
        chromsizes=config["bedGraphToBigWig"]["chrom"]
    output:
        "output/coverage/{sample}-{rep, [^.]+}.bw"
    log:
        "logs/bedGraphToBigWig/{sample}-{rep}.log"
    params:
        config["bedGraphToBigWig"]["params"]
    conda:
        f"{snake_dir}/envs/ucsc.yaml"
    shell:
        """
        bedGraphToBigWig {params} {input.bedGraph} {input.chromsizes} \
            {output} &> {log}        
        """
