rule merge_bam:
    input:
        lambda wildcards: expand("output/mapped/{sample}-{rep}-{unit}.clean.sort.bam", **wildcards, unit=samples.loc[(wildcards.sample, wildcards.rep),  'unit'])
    output:
        temp("output/mapped/{sample}-{rep, [^.]+}.merge.bam")
    params:
        ""
    threads:
        config['threads']
    conda:
        f"{snake_dir}/envs/common.yaml"
    shell:
        """
        samtools merge -@ {threads} {params} \
            {output} {input}
        """

rule merge_bam_sort:
    input:
        "output/mapped/{sample}-{rep}.merge.bam"
    output:
        "output/mapped/{sample}-{rep, [^.]+}.merge.sort.bam"
    params:
        ""
    threads:
        config['threads']
    conda:
        f"{snake_dir}/envs/common.yaml"
    shell:
        """
        samtools sort {params} -@ {threads} -o {output} {input}
        """

