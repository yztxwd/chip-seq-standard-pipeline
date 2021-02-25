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
        "genomeCoverageBed {params} -ibam {input} | sort -k1,1 -k2,2n 1> {output} 2> {log}"

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

if checkcontrol(samples):
    rule bamCompare:
        input:
            ip="output/mapped/{sample}-{rep}.merge.sort.bam",
            ip_index="output/mapped/{sample}-{rep}.merge.sort.bam.bai",
            input=f"output/mapped/{samples.loc[samples['condition']=='control', 'sample'].iloc[0]}-{{rep}}.merge.sort.bam",
            input_index=f"output/mapped/{samples.loc[samples['condition']=='control', 'sample'].iloc[0]}-{{rep}}.merge.sort.bam.bai"
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
