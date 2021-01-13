rule merge_bam:
    input:
        lambda wildcards: expand("output/mapped/{sample}-{rep}-{unit}.clean.sort.bam", **wildcards, unit=samples.loc[(wildcards.sample, wildcards.rep),  'unit'])
    output:
        temp("output/mapped/{sample}-{rep, [^.]+}.merge.bam")
    params:
        ""
    threads:
        config['threads']
    wrapper:
        f"file:{snake_dir}/wrappers/samtools/merge"

rule merge_bam_sort:
    input:
        "output/mapped/{sample}-{rep}.merge.bam"
    output:
        "output/mapped/{sample}-{rep, [^.]+}.merge.sort.bam"
    params:
        "-@ " + str(config["threads"])
    wrapper:
        f"file:{snake_dir}/wrappers/samtools/sort"

rule samtools_index:
    input:
        "output/mapped/{sample}-{rep}.merge.sort.bam"
    output:
        "output/mapped/{sample}-{rep, [^.]+}.merge.sort.bam.bai"
    params:
        "-@ " + str(config["threads"])
    wrapper:
        f"file:{snake_dir}/wrappers/samtools/index"
