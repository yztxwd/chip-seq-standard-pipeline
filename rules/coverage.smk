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
    wrapper:
        "v0.69.0/bio/bedtools/genomecov"

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
    wrapper:
        "v0.69.0/bio/ucsc/bedGraphToBigWig"
