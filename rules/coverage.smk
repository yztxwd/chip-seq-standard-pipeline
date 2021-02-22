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

if checkcontrol(samples):
    rule bamCompare:
        input:
            ip="output/mapped/{sample}-{rep}.merge.sort.bam",
            input=f"output/mapped/{samples.loc[samples['condition']=='control', 'sample'].iloc[0]}-{{rep}}.merge.sort.bam"
        output:
            "output/coverage/{sample}-{rep}.bamCompare.bw"
        params:
            config['bamCompare']
        threads:
            config['threads']
        conda:
            f"{snake_dir}/envs/deeptools.yaml"
        shell:
            """
            bamCompare -b1 {input.ip} -b2 {input.input} -o {output} -of bigwig \
                {params} -p {threads}
            """
